import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../services/exercise_library_service.dart';

class IntermediateSingleMusclePage extends StatelessWidget {
  final int dayIndex;

  const IntermediateSingleMusclePage({
    Key? key,
    required this.dayIndex,
  }) : super(key: key);

  static const List<String> muscleGroups = ['Chest', 'Back', 'Biceps', 'Triceps', 'Shoulders', 'Legs'];
  static const List<String> dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

  List<WorkoutExercise> _getExercises() {
    final muscleGroup = muscleGroups[dayIndex];
    final exercises = _getMuscleGroupExercises(muscleGroup);
    return exercises.map((exercise) => WorkoutExercise(
      exercise: exercise,
      config: _getExerciseConfig(exercise),
    )).toList();
  }

  List<Exercise> _getMuscleGroupExercises(String muscleGroup) {
    final muscleCategory = muscleGroup == 'Biceps' || muscleGroup == 'Triceps' ? 'Arms' : muscleGroup;
    final exercises = ExerciseLibraryService.getExercisesByMuscleGroup(muscleCategory);
    
    // Return 4 exercises for intermediate level
    switch (muscleGroup) {
      case 'Chest':
        return [
          _getExercise(exercises, 'barbell_benchpress'),
          _getExercise(exercises, 'incline_dumbbell_press'),
          _getExercise(exercises, 'dumbbell_pullover'),
          _getExercise(exercises, 'cable_chest_fly'),
        ];
      case 'Back':
        return [
          _getExercise(exercises, 'deadlifts'),
          _getExercise(exercises, 'latPulldown'),
          _getExercise(exercises, 'dumbbell_row'),
          _getExercise(exercises, 'seated_cable_row'),
        ];
      case 'Biceps':
        return [
          _getExercise(exercises, 'barbell_curl'),
          _getExercise(exercises, 'preacher_curl'),
          _getExercise(exercises, 'incline_dumbbell_curl'),
          _getExercise(exercises, 'cable_curl'),
        ];
      case 'Triceps':
        return [
          _getExercise(exercises, 'close_grip_bench_press'),
          _getExercise(exercises, 'skull_crushers'),
          _getExercise(exercises, 'overhead_tricep_extension'),
          _getExercise(exercises, 'tricep_pushdowns'),
        ];
      case 'Shoulders':
        return [
          _getExercise(exercises, 'dumbbell_shoulder_press'),
          _getExercise(exercises, 'arnold_press'),
          _getExercise(exercises, 'lateralRaises'),
          _getExercise(exercises, 'rear_delt_fly'),
        ];
      case 'Legs':
        return [
          _getExercise(exercises, 'squats'),
          _getExercise(exercises, 'leg_press'),
          _getExercise(exercises, 'leg_curl'),
          _getExercise(exercises, 'leg_extension'),
        ];
      default:
        return exercises.take(4).toList();
    }
  }

  Exercise _getExercise(List<Exercise> exercises, String exerciseId) {
    return exercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => exercises.first,
    );
  }

  List<String> _getExerciseIdsForGroup(String muscleGroup) {
    switch (muscleGroup) {
      case 'Chest':
        return ['barbell_benchpress', 'incline_dumbbell_press', 'decline_bench_press', 'dumbbell_pullover'];
      case 'Back':
        return ['latPulldown', 'seated_cable_row', 'dumbbell_row', 'barbell_row'];
      case 'Biceps':
        return ['barbell_curl', 'hammer_curl', 'concentration_curl', 'preacher_curl'];
      case 'Triceps':
        return ['tricep_pushdowns', 'overhead_tricep_extension', 'skull_crushers', 'tricep_kickbacks'];
      case 'Shoulders':
        return ['barbell_overhead_press', 'arnold_press', 'lateralRaises', 'rear_delt_fly'];
      case 'Legs':
        return ['squats', 'leg_press', 'romanian_deadlift', 'leg_extension', 'leg_curl'];
      default:
        return [];
    }
  }

  ExerciseConfig _getExerciseConfig(Exercise exercise) {
    // Intermediate configuration: 4 sets, 10 reps with fixed calories
    final int exerciseCalories = 1680 ~/ _getExerciseIdsForGroup(muscleGroups[dayIndex]).length;
    return ExerciseConfig(
      sets: 4,
      reps: 10,
      calories: exerciseCalories, // Evenly distribute 1680 calories across exercises
    );
  }

  int _calculateTotalCalories(List<WorkoutExercise> exercises) {
    return 1680; // Fixed 1680 calories for intermediate workouts
  }

  int _calculateEstimatedDuration(List<WorkoutExercise> exercises) {
    return 290; // Fixed 290 minutes for intermediate workouts
  }

  Workout _buildWorkout() {    return Workout(
      id: 'intermediate_single_muscle_${dayIndex + 1}',
      title: '${dayNames[dayIndex]} - ${muscleGroups[dayIndex]}',
      description: 'Day ${dayIndex + 1} of 6-day intermediate single muscle split focusing on ${muscleGroups[dayIndex]}',
      category: 'Strength',
      difficulty: 'Intermediate',
      imageUrl: 'assets/images/workouts/intermediate_single_muscle.jpg',
      exercises: _getExercises(),
      addedAt: DateTime.now(),
      customDuration: 180, // Fixed 180 minutes for intermediate workouts
      customCalories: 1680, // Fixed 1680 calories for intermediate workouts
    );
  }

  @override
  Widget build(BuildContext context) {
    final workout = _buildWorkout();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Intermediate ${muscleGroups[dayIndex]} Workout'),
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
