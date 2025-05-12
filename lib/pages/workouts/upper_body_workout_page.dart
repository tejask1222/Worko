import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../services/exercise_library_service.dart';

class UpperBodyWorkoutPage extends StatelessWidget {
  final String difficulty;

  const UpperBodyWorkoutPage({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  List<WorkoutExercise> _getExercises() {
    final exercises = [
      // Chest exercises
      _getExercise('Chest', 'barbell_benchpress'),
      _getExercise('Chest', 'incline_dumbbell_press'),
      
      // Back exercises
      _getExercise('Back', 'latPulldown'),
      _getExercise('Back', 'seated_cable_row'),
      
      // Shoulder exercises
      _getExercise('Shoulders', 'barbell_overhead_press'),
      _getExercise('Shoulders', 'lateralRaises'),
      
      // Arms exercises
      _getExercise('Arms', 'barbell_curl'),
      _getExercise('Arms', 'tricep_pushdowns'),
    ];

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
      'barbell_benchpress': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'incline_dumbbell_press': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'latPulldown': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'seated_cable_row': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'barbell_overhead_press': {'Beginner': 25, 'Intermediate': 35, 'Advanced': 40},
      'lateralRaises': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 25},
      'barbell_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'tricep_pushdowns': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
    };

    return caloriesByExercise[exerciseId]?[difficulty] ?? 
      (difficulty == 'Beginner' ? 70 : difficulty == 'Intermediate' ? 95 : 115);
  }

  Workout _buildWorkout() {
    return Workout(
      id: 'upper_body_${difficulty.toLowerCase()}',
      title: 'Upper Body Blast',
      description: 'Intense upper body workout focusing on chest, back, shoulders and arms',
      category: 'Strength',
      difficulty: difficulty,
      imageUrl: 'assets/images/workouts/upper_body.jpg',
      exercises: _getExercises(),
      addedAt: DateTime.now(),
      customDuration: difficulty.toLowerCase() == 'beginner' ? 50 
                     : difficulty.toLowerCase() == 'intermediate' ? 65 
                     : 80, // Duration in minutes
    );
  }

  @override
  Widget build(BuildContext context) {
    final workout = _buildWorkout();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${workout.difficulty} Upper Body Workout'),
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
