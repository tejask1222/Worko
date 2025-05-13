import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../services/exercise_library_service.dart';

class FullBodyWorkoutPage extends StatelessWidget {
  final String difficulty;

  const FullBodyWorkoutPage({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  List<WorkoutExercise> _getExercises() {
    // Get default exercises for full body workout
    final exercises = ExerciseLibraryService.getDefaultWorkoutExercises('Full Body');
    
    // Customize the exercise configuration based on difficulty
    return exercises.map((exercise) {
      int sets = difficulty.toLowerCase() == 'advanced' ? 5 : 
                 difficulty.toLowerCase() == 'intermediate' ? 4 : 3;
      int reps = difficulty.toLowerCase() == 'advanced' ? 8 : 
                 difficulty.toLowerCase() == 'intermediate' ? 10 : 12;
      
      // Calculate calories per exercise
      int calories = 120 ~/ exercises.length; // Total workout calories divided by number of exercises

      return WorkoutExercise(
        exercise: exercise.exercise,
        config: ExerciseConfig(
          sets: sets,
          reps: reps,
          calories: calories,
        ),
      );
    }).toList();
  }

  Workout _buildWorkout() {
    return Workout(
      id: 'full_body_${difficulty.toLowerCase()}',
      title: 'Full Body Workout',
      description: 'Complete full body workout targeting all major muscle groups',
      category: 'Strength',
      difficulty: difficulty,
      imageUrl: 'assets/images/workouts/full_body.jpg',
      exercises: _getExercises(),
      addedAt: DateTime.now(),
      customDuration: 20, // Updated from 18 to 20 minutes
      customCalories: 120, // Fixed 120 calories
    );
  }

  @override
  Widget build(BuildContext context) {
    final workout = _buildWorkout();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${workout.difficulty} Full Body Workout'),
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
            // Navigate to workout detail or active workout page
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
