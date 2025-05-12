import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:provider/provider.dart';
import 'models/workout.dart';
import 'providers/achievement.dart';

class ActiveWorkoutPage extends StatefulWidget {
  final Workout workout;

  const ActiveWorkoutPage({
    Key? key,
    required this.workout,
  }) : super(key: key);

  @override
  State<ActiveWorkoutPage> createState() => _ActiveWorkoutPageState();
}

class _ActiveWorkoutPageState extends State<ActiveWorkoutPage> {
  int currentExerciseIndex = 0;
  List<Set<int>> completedSets = [];
  late Timer _timer;
  Duration _elapsed = const Duration();
  bool _isActive = true;
  int _caloriesBurned = 0;
  Map<int, bool> _exerciseCompleted = {};

  @override
  void initState() {
    super.initState();
    completedSets = List.generate(
      widget.workout.exercises.length,
      (index) => <int>{},
    );
    _exerciseCompleted = {};
    startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isActive) {
        setState(() {
          _elapsed += const Duration(seconds: 1);
        });
      }
    });
  }

  String get formattedTime {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(_elapsed.inMinutes.remainder(60));
    String seconds = twoDigits(_elapsed.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  WorkoutExercise get currentExercise {
    if (currentExerciseIndex >= widget.workout.exercises.length) {
      return widget.workout.exercises.last;
    }
    return widget.workout.exercises[currentExerciseIndex];
  }

  void completeSet(int setIndex) {
    setState(() {
      if (completedSets[currentExerciseIndex].contains(setIndex)) {
        completedSets[currentExerciseIndex].remove(setIndex);
        _caloriesBurned -= (currentExercise.config.calories / currentExercise.config.sets).round();
      } else {
        completedSets[currentExerciseIndex].add(setIndex);
        _caloriesBurned += (currentExercise.config.calories / currentExercise.config.sets).round();
      }
    });
  }

  bool isSetCompleted(int setIndex) {
    return completedSets[currentExerciseIndex].contains(setIndex);
  }

  void onCompleteExercise() {
    if (completedSets[currentExerciseIndex].length != currentExercise.config.sets) {
      // Show warning if not all sets are completed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Incomplete Exercise'),
          content: const Text('You haven\'t completed all sets. Are you sure you want to continue?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                moveToNextExercise();
              },
              child: const Text('Continue Anyway'),
            ),
          ],
        ),
      );
      return;
    }

    moveToNextExercise();
  }

  void moveToNextExercise() {
    if (currentExerciseIndex < widget.workout.exercises.length - 1) {
      setState(() {
        currentExerciseIndex++;
      });
    } else {
      completeWorkout();
    }
  }

  Future<void> completeWorkout() async {
    _timer.cancel();
    _isActive = false;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Session expired. Please log in again.'),
          backgroundColor: Colors.red,
        ),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      return;
    }

    try {
      final now = DateTime.now();
      
      // Update user data
      final userRef = FirebaseDatabase.instance.ref('users/${user.uid}');
      bool userDataCreated = false;

      for (int i = 0; i < 3; i++) {
        try {
          final userSnapshot = await userRef.get();
          if (!userSnapshot.exists) {
            await userRef.set({
              'email': user.email,
              'createdAt': now.toIso8601String(),
              'lastActive': now.toIso8601String(),
              'totalWorkouts': 1,
            });
          } else {
            await userRef.update({
              'lastActive': now.toIso8601String(),
            });
          }
          userDataCreated = true;
          break;
        } catch (e) {
          if (i == 2) throw e;
          await Future.delayed(const Duration(seconds: 1));
        }
      }

      if (!userDataCreated) {
        throw Exception('Failed to create/update user data');
      }

      // Save workout history
      final workoutRef = FirebaseDatabase.instance.ref('workoutHistory/${user.uid}').push();
      await workoutRef.set({
        'workoutId': widget.workout.id,
        'workoutTitle': widget.workout.title,
        'completedAt': now.toIso8601String(),
        'duration': _elapsed.inSeconds,
        'caloriesBurned': _caloriesBurned,
        'exercisesCompleted': widget.workout.exercises.length,
      });

      // Update weekly stats
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekKey = '${weekStart.year}-${weekStart.month}-${weekStart.day}';
      final weeklyStatsRef = FirebaseDatabase.instance.ref('weeklyStats/${user.uid}/$weekKey');

      // Update weekly stats and check for achievements
      final weeklySnapshot = await weeklyStatsRef.get();
      if (weeklySnapshot.exists) {
        final data = Map<String, dynamic>.from(weeklySnapshot.value as Map);
        
        // Get current active days
        Set<int> activeWorkoutDays;
        if (data.containsKey('activeWorkoutDays')) {
          if (data['activeWorkoutDays'] is List) {
            activeWorkoutDays = Set<int>.from(List<int>.from(data['activeWorkoutDays']));
          } else {
            activeWorkoutDays = Set<int>.from(data['activeWorkoutDays'] as Set);
          }
        } else {
          activeWorkoutDays = {};
        }
        
        // Add today's workout
        activeWorkoutDays.add(now.weekday - 1);  // 0-based index for weekday
        
        await weeklyStatsRef.update({
          'totalCalories': (data['totalCalories'] as int? ?? 0) + _caloriesBurned,
          'totalWorkouts': (data['totalWorkouts'] as int? ?? 0) + 1,
          'totalDuration': (data['totalDuration'] as int? ?? 0) + _elapsed.inMinutes,
          'activeWorkoutDays': activeWorkoutDays.toList(),
        });
      } else {
        await weeklyStatsRef.set({
          'totalCalories': _caloriesBurned,
          'totalWorkouts': 1,
          'totalDuration': _elapsed.inMinutes,
          'activeWorkoutDays': [now.weekday - 1],
          'weekStart': weekStart.toIso8601String(),
        });
      }

      if (!mounted) return;

      // Check achievements
      await Provider.of<AchievementProvider>(context, listen: false).checkAchievements();

      // Show completion message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Workout completed! Calories burned: $_caloriesBurned, Time: $formattedTime',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate back
      Navigator.popUntil(
        context,
        (route) => route.settings.name == '/workout' || route.isFirst,
      );
    } catch (e) {
      if (!mounted) return;
      
      String errorMessage = 'Error saving workout data';
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'You don\'t have permission to save workout data';
      } else if (e.toString().contains('auth')) {
        errorMessage = 'Session expired. Please log in again';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.workout.title,
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                formattedTime,
                style: TextStyle(
                  color: Colors.blue[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_caloriesBurned cal',
                style: TextStyle(
                  color: Colors.orange[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: (currentExerciseIndex) / widget.workout.exercises.length,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[400]!),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${currentExerciseIndex} of ${widget.workout.exercises.length} exercises completed',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  currentExercise.exercise.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  currentExercise.exercise.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ...List.generate(
                  currentExercise.config.sets,
                  (index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: InkWell(
                      onTap: () => completeSet(index),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSetCompleted(index)
                                ? Colors.green
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Set ${index + 1}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              '${currentExercise.config.reps} reps',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const Spacer(),
                            Icon(
                              Icons.check_circle,
                              color: isSetCompleted(index) ? Colors.green : Colors.grey[300],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: onCompleteExercise,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            currentExerciseIndex < widget.workout.exercises.length - 1
                ? 'Complete Exercise'
                : 'Finish Workout',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}