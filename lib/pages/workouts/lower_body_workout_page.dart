import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../services/exercise_library_service.dart';

class LowerBodyWorkoutPage extends StatelessWidget {
  final String difficulty;

  const LowerBodyWorkoutPage({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  List<WorkoutExercise> _getExercises() {
    final exercises = [
      _getExercise('Legs', 'squats'),
      _getExercise('Legs', 'leg_press'),
      _getExercise('Legs', 'leg_extension'),
      _getExercise('Legs', 'leg_curl'),
      if (difficulty != 'Beginner') _getExercise('Legs', 'romanian_deadlifts'),
      if (difficulty == 'Advanced') _getExercise('Legs', 'front_squats'),
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

    switch (difficulty.toLowerCase()) {
      case 'beginner':
        sets = 3;
        reps = 12;
        calories = _getCaloriesForExercise(exercise.id, 'Beginner');
        break;
      case 'intermediate':
        sets = 4;
        reps = 10;
        calories = _getCaloriesForExercise(exercise.id, 'Intermediate');
        break;
      case 'advanced':
        sets = 5;
        reps = 8;
        calories = _getCaloriesForExercise(exercise.id, 'Advanced');
        break;
      default:
        sets = 3;
        reps = 12;
        calories = 50;
    }

    return ExerciseConfig(
      sets: sets,
      reps: reps,
      calories: calories,
    );
  }

  int _getCaloriesForExercise(String exerciseId, String difficulty) {
    final Map<String, Map<String, int>> caloriesByExercise = {
      'squats': {'Beginner': 50, 'Intermediate': 60, 'Advanced': 65},
      'front_squats': {'Beginner': 45, 'Intermediate': 55, 'Advanced': 60},
      'leg_press': {'Beginner': 40, 'Intermediate': 45, 'Advanced': 50},
      'romanian_deadlifts': {'Beginner': 40, 'Intermediate': 50, 'Advanced': 55},
      'leg_curl': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'leg_extension': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
    };

    return caloriesByExercise[exerciseId]?[difficulty] ?? 
      (difficulty == 'Beginner' ? 70 : difficulty == 'Intermediate' ? 95 : 115);
  }

  Workout _buildWorkout() {
    return Workout(
      id: 'lower_body_${difficulty.toLowerCase()}',
      title: 'Lower Body Focus',
      description: 'Leg-focused workout to build strength and stability',
      category: 'Strength',
      difficulty: difficulty,
      imageUrl: 'assets/images/workouts/lower_body.jpg',
      exercises: _getExercises(),
      addedAt: DateTime.now(),
      customDuration: difficulty.toLowerCase() == 'beginner' ? 45 
                     : difficulty.toLowerCase() == 'intermediate' ? 60 
                     : 75, // Duration in minutes
    );
  }

  @override
  Widget build(BuildContext context) {
    final workout = _buildWorkout();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${workout.difficulty} Lower Body Workout'),
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
                      _buildDetail('Reps', exercise.reps.toString()),
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
