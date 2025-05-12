import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../services/exercise_library_service.dart';
import '../../active_workout_page.dart';
import '../../services/workout_instructions_service.dart';

class BeginnerPPLPage extends StatelessWidget {
  static const List<String> dayNames = ['Monday', 'Tuesday', 'Wednesday'];
  static const List<String> splitTypes = ['Push', 'Pull', 'Legs'];
  
  final int dayIndex;

  const BeginnerPPLPage({
    Key? key,
    required this.dayIndex,
  }) : super(key: key);

  List<WorkoutExercise> _getExercises() {
    final splitType = splitTypes[dayIndex];
    final exercises = _getSplitExercises(splitType);
    return exercises.map((exercise) => WorkoutExercise(
      exercise: exercise,
      config: _getExerciseConfig(exercise),
    )).toList();
  }

  List<Exercise> _getSplitExercises(String splitType) {
    final exercises = ExerciseLibraryService.getExercisesByMuscleGroup(splitType);
    final exerciseIds = _getExerciseIdsForSplit(splitType);
    
    return exerciseIds.map((id) => _getExercise(exercises, id)).toList();
  }

  List<String> _getExerciseIdsForSplit(String splitType) {
    switch (splitType) {
      case 'Push':
        return [
          'barbell_benchpress',
          'incline_dumbbell_press',
          'tricep_pushdowns',
          'overhead_tricep_extension'
        ];
      case 'Pull':
        return [
          'latPulldown',
          'seated_cable_row',
          'barbell_curl',
          'hammer_curl'
        ];
      case 'Legs':
        return [
          'squats',
          'leg_curl',
          'dumbbell_shoulder_press',
          'lateralRaises',
          'rear_delt_fly'
        ];
      default:
        return [];
    }
  }

  Exercise _getExercise(List<Exercise> exercises, String exerciseId) {
    return exercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => exercises.first,
    );
  }

  ExerciseConfig _getExerciseConfig(Exercise exercise) {
    return ExerciseConfig(
      sets: 3,
      reps: 12,
      calories: _getCaloriesForExercise(exercise.id),
    );
  }

  int _getCaloriesForExercise(String exerciseId) {
    final caloriesMap = {
      'squats': 50,
      'barbell_benchpress': 40,
      'incline_dumbbell_press': 35,
      'tricep_pushdowns': 30,
      'overhead_tricep_extension': 30,
      'latPulldown': 40,
      'seated_cable_row': 35,
      'barbell_curl': 30,
      'hammer_curl': 30,
      'leg_curl': 35,
      'dumbbell_shoulder_press': 30,
      'lateralRaises': 25,
      'rear_delt_fly': 25,
    };
    return caloriesMap[exerciseId] ?? 30;
  }

  String _getSplitDescription(String splitType) {
    switch (splitType) {
      case 'Push':
        return 'Focus on chest and triceps';
      case 'Pull':
        return 'Target back and biceps';
      case 'Legs':
        return 'Work on legs and shoulders';
      default:
        return '';
    }
  }

  Workout _buildWorkout() {
    final splitType = splitTypes[dayIndex];
    return Workout(
      id: 'beginner_ppl_${dayIndex + 1}',
      title: '${dayNames[dayIndex]} - $splitType',
      description: 'Beginner ${splitType} workout - ${_getSplitDescription(splitType)}',
      category: 'Strength',
      difficulty: 'Beginner',
      imageUrl: 'assets/images/workouts/beginner_ppl.jpg',
      exercises: _getExercises(),
      addedAt: DateTime.now(),
      customDuration: 45,
    );
  }

  int _calculateTotalCalories(List<WorkoutExercise> exercises) {
    return exercises.fold(0, (sum, exercise) => sum + exercise.config.calories);
  }

  int _calculateEstimatedDuration(List<WorkoutExercise> exercises) {
    return 45; // Fixed 45 minutes for beginner workouts
  }

  @override
  Widget build(BuildContext context) {
    final workout = _buildWorkout();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Beginner ${splitTypes[dayIndex]} Workout'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.timer_outlined, size: 20, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${_calculateEstimatedDuration(workout.exercises)} min',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 24),
                  Icon(Icons.local_fire_department_outlined, 
                       size: 20, 
                       color: Colors.orange[600]),
                  const SizedBox(width: 8),
                  Text(
                    '${_calculateTotalCalories(workout.exercises)} cal',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Recommended for beginners:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('• Focus on proper form'),
                    Text('• Rest 90 seconds between sets'),
                    Text('• Stay hydrated'),
                    Text('• Warm up before starting'),
                  ],
                ),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: workout.exercises.length,
              itemBuilder: (context, index) {
                final exercise = workout.exercises[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${index + 1}. ${exercise.exercise.name}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          exercise.exercise.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildDetail('Sets', '3'),
                            _buildDetail('Reps', '10-12'),
                            _buildDetail('Rest', '90 sec'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () async {
            if (await WorkoutInstructionsService.shouldShowInstructions()) {
              if (context.mounted) {
                await WorkoutInstructionsService.showInstructionsDialog(
                  context: context,
                  workout: workout,
                );
              }
            } else if (context.mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ActiveWorkoutPage(workout: workout),
                ),
              );
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

  Widget _buildDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
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
}
