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
      _getExercise('Core', 'russiantwists'),
      _getExercise('Core', 'mountainclimbers'),
    ];
    
    const totalWorkoutCalories = 80; // Fixed total calories
    final caloriesPerExercise = totalWorkoutCalories ~/ exercises.length;

    return exercises.map((exercise) {
      int sets;
      int reps;

      // Set reps/duration based on exercise type and difficulty
      if (exercise.id == 'plank') {
        sets = 3;
        reps = difficulty.toLowerCase() == 'advanced' ? 60 : // 60 seconds
               difficulty.toLowerCase() == 'intermediate' ? 45 : // 45 seconds
               30; // 30 seconds for beginner
      } else {
        sets = difficulty.toLowerCase() == 'advanced' ? 5 : 
               difficulty.toLowerCase() == 'intermediate' ? 4 : 3;
        reps = difficulty.toLowerCase() == 'advanced' ? 25 : 
               difficulty.toLowerCase() == 'intermediate' ? 20 : 15;
      }

      return WorkoutExercise(
        exercise: exercise,
        config: ExerciseConfig(
          sets: sets,
          reps: reps,
          calories: caloriesPerExercise,
        ),
      );
    }).toList();
  }

  Exercise _getExercise(String muscleGroup, String exerciseId) {
    final exercises = ExerciseLibraryService.getExercisesByMuscleGroup(muscleGroup);
    return exercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => exercises.first,
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
      exercises: _getExercises(),      addedAt: DateTime.now(),
      customDuration: 15, // Fixed 15 minutes
      customCalories: 80, // Fixed 80 calories
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
