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
      _getExercise('Legs', 'front_squats'),
      _getExercise('Legs', 'leg_press'),
      _getExercise('Legs', 'romanian_deadlifts'),
      _getExercise('Legs', 'leg_curl'),
      _getExercise('Legs', 'leg_extension'),
    ];

    const totalCalories = 150; // Fixed total calories
    final caloriesPerExercise = totalCalories ~/ exercises.length;

    return exercises.map((exercise) {
      int sets = difficulty.toLowerCase() == 'advanced' ? 5 : 
                 difficulty.toLowerCase() == 'intermediate' ? 4 : 3;
      int reps = difficulty.toLowerCase() == 'advanced' ? 8 : 
                 difficulty.toLowerCase() == 'intermediate' ? 10 : 12;

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
      id: 'lower_body_${difficulty.toLowerCase()}',
      title: 'Lower Body Focus',
      description: 'Leg-focused workout to build strength and stability',
      category: 'Strength',
      difficulty: difficulty,
      imageUrl: 'assets/images/workouts/lower_body.jpg',
      exercises: _getExercises(),      
      addedAt: DateTime.now(),
      customDuration: 20, // Updated from 18 to 20 minutes
      customCalories: 150, // Fixed 150 calories
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
