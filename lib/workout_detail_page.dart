import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/workout.dart';
import 'active_workout_page.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class WorkoutDetailPage extends StatelessWidget {
  final Workout workout;

  const WorkoutDetailPage({
    Key? key,
    required this.workout,
  }) : super(key: key);

  // Calculate total duration (estimating 1 minute per set)
  int get estimatedDuration {
    return workout.exercises.fold(0, (sum, exercise) => sum + exercise.config.sets);
  }

  // Calculate total calories
  int get totalCalories {
    return workout.exercises.fold(0, (sum, exercise) => sum + exercise.config.calories);
  }

  Future<File> _getImageFile(String assetPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${assetPath.split('/').last}');

    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      final buffer = byteData.buffer;
      await file.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
    }
    return file;
  }

  // Get user preference for showing workout instructions
  Future<bool> _shouldShowInstructions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return true;
    
    final prefSnapshot = await FirebaseDatabase.instance
        .ref('userPreferences/${user.uid}/showWorkoutInstructions')
        .get();
    
    // If preference doesn't exist or is true, show instructions
    return !prefSnapshot.exists || prefSnapshot.value == true;
  }

  // Save user preference for showing workout instructions
  Future<void> _saveInstructionsPreference(bool show) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    
    await FirebaseDatabase.instance
        .ref('userPreferences/${user.uid}')
        .update({'showWorkoutInstructions': show});
  }

  // Show instructions dialog
  Future<void> _showInstructionsDialog(BuildContext context) async {
    bool showAgain = true;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Workout Instructions'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Click each set one by one and then after completing the exercise click "Complete Exercise" to move to next exercise.\n\nNote: You can click all sets at once after completing the exercise and then click "Complete Exercise".',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: !showAgain,
                        onChanged: (bool? value) {
                          setState(() {
                            showAgain = !(value ?? false);
                          });
                        },
                      ),
                      Expanded(
                        child: const Text(
                          'Don\'t show this message again',
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await _saveInstructionsPreference(showAgain);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActiveWorkoutPage(workout: workout),
                    ),
                  );
                }
              },
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildExerciseCard(WorkoutExercise workoutExercise) {
    final exercise = workoutExercise.exercise;
    final config = workoutExercise.config;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: FutureBuilder<File>(
              future: _getImageFile(exercise.imageUrl),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return Image.asset(
                    exercise.imageUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  );
                }
                return Image.file(
                  snapshot.data!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  exercise.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  exercise.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Target: ${exercise.targetMuscles}',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildConfigDetail('Sets', config.sets.toString()),
                    _buildConfigDetail('Reps', config.reps.toString()),
                    _buildConfigDetail('Calories', '${config.calories} cal'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 20, color: Colors.blue[600]),
                      const SizedBox(width: 8),
                      Text(
                        '$estimatedDuration min',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 24),
                      Icon(Icons.local_fire_department_outlined, size: 20, color: Colors.orange[600]),
                      const SizedBox(width: 8),
                      Text(
                        '$totalCalories cal',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(width: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          workout.difficulty,
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Exercises',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: workout.exercises.length,
              itemBuilder: (context, index) {
                return _buildExerciseCard(workout.exercises[index]);
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () async {
            if (await _shouldShowInstructions()) {
              await _showInstructionsDialog(context);
            } else {
              if (context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActiveWorkoutPage(workout: workout),
                  ),
                );
              }
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Start Workout',
            style: TextStyle(
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