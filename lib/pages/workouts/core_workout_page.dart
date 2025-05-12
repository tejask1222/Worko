import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../services/exercise_library_service.dart';

class CoreWorkoutPage extends StatelessWidget {
  final String difficulty;

  const CoreWorkoutPage({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  List<WorkoutExercise> _getExercises() {
    final exercises = [
      _getExercise('Core', 'plank'),
      _getExercise('Core', 'crunches'),
      _getExercise('Core', 'russianTwists'),
      _getExercise('Cardio', 'mountainClimbers'),
      if (difficulty != 'Beginner') _getExercise('Core', 'leg_raises'),
      if (difficulty == 'Advanced') _getExercise('Core', 'dragon_flags'),
    ].where((e) => e != null).toList();

    return exercises.map((exercise) => WorkoutExercise(
      exercise: exercise,
      config: _getExerciseConfig(exercise),
    )).toList();
  }

  Exercise _getExercise(String muscleGroup, String exerciseId) {
    final exercises = ExerciseLibraryService.getExercisesByMuscleGroup(muscleGroup);
    return exercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => exercises.first,
    );
  }

  ExerciseConfig _getExerciseConfig(Exercise exercise) {
    int sets;
    int reps;
    int calories;

    // Core exercises often use different rep ranges
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        sets = 3;
        reps = exercise.id == 'plank' ? 30 : 15; // 30 seconds for planks, 15 reps for others
        calories = exercise.targetMuscles.contains('Cardio') ? 100 : 50;
        break;
      case 'intermediate':
        sets = 4;
        reps = exercise.id == 'plank' ? 45 : 20;
        calories = exercise.targetMuscles.contains('Cardio') ? 120 : 70;
        break;
      case 'advanced':
        sets = 5;
        reps = exercise.id == 'plank' ? 60 : 25;
        calories = exercise.targetMuscles.contains('Cardio') ? 150 : 90;
        break;
      default:
        sets = 3;
        reps = 15;
        calories = 50;
    }

    return ExerciseConfig(
      sets: sets,
      reps: reps,
      calories: calories,
    );
  }

  Workout _buildWorkout() {
    return Workout(
      id: 'core_${difficulty.toLowerCase()}',
      title: 'Core Crusher',
      description: 'Core-focused workout for a stronger midsection',
      category: 'Core',
      difficulty: difficulty,
      imageUrl: 'assets/images/workouts/core.jpg',
      exercises: _getExercises(),
      addedAt: DateTime.now(),
      customDuration: difficulty.toLowerCase() == 'beginner' ? 30 
                     : difficulty.toLowerCase() == 'intermediate' ? 45 
                     : 60, // Duration in minutes
    );
  }

  @override
  Widget build(BuildContext context) {
    final workout = _buildWorkout();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${workout.difficulty} Core Workout'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetail('Sets', exercise.sets.toString()),
                      _buildDetail(
                        'Reps', 
                        exercise.exercise.id == 'plank' 
                          ? '${exercise.reps} sec' 
                          : exercise.reps.toString()
                      ),
                      _buildDetail('Calories', '${exercise.calories}'),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to active workout page
            Navigator.pushNamed(context, '/active_workout', arguments: workout);
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('Start Workout'),
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
