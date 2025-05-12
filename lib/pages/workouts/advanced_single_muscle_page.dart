import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../services/exercise_library_service.dart';

class AdvancedSingleMusclePage extends StatelessWidget {
  final int dayIndex;

  const AdvancedSingleMusclePage({
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

    static final Map<String, List<String>> _exerciseIds = {
    'Chest': [
      'barbell_benchpress',
      'incline_dumbbell_press',
      'decline_bench_press',
      'dumbbell_pullover',
      'chest_dips',
      'cable_chest_fly',
    ],
    'Back': [
      'deadlifts',
      'pullups',
      'tbar_row',
      'dumbbell_row',
      'seated_cable_row',
      'straight_arm_pulldown',
    ],
    'Biceps': [
      'barbell_curl',
      'preacher_curl',
      'incline_dumbbell_curl',
      'hammer_curl',
      'spider_curl',
      'cable_curl',
    ],
    'Triceps': [
      'close_grip_bench_press',
      'skull_crushers',
      'tricep_pushdowns',
      'overhead_cable_extension',
      'overhead_tricep_extension',
      'tricep_kickbacks',
    ],
    'Shoulders': [
      'barbell_overhead_press',
      'dumbbell_shoulder_press',
      'arnold_press',
      'lateralRaises',
      'front_raise',
      'rear_delt_fly',
    ],
    'Legs': [
      'squats',
      'front_squats',
      'leg_press',
      'romanian_deadlifts',
      'leg_curl',
      'leg_extension',
    ],
  };

  List<Exercise> _getMuscleGroupExercises(String muscleGroup) {
    final muscleCategory = muscleGroup == 'Biceps' || muscleGroup == 'Triceps' ? 'Arms' : muscleGroup;
    final exercises = ExerciseLibraryService.getExercisesByMuscleGroup(muscleCategory);
    final exerciseIds = _exerciseIds[muscleGroup] ?? [];
    
    return exerciseIds.map((id) => _getExercise(exercises, id)).toList();
  }

  Exercise _getExercise(List<Exercise> exercises, String exerciseId) {
    return exercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => exercises.first,
    );
  }

  ExerciseConfig _getExerciseConfig(Exercise exercise) {
    // Advanced configuration: 5 sets, 8 reps with fixed calories
    final int exerciseCalories = 3240 ~/ (_exerciseIds[muscleGroups[dayIndex]] ?? []).length; // Distribute calories evenly
    return ExerciseConfig(
      sets: 5,
      reps: 8,
      calories: exerciseCalories,
    );
  }

  Workout _buildWorkout() {
    final muscleGroup = muscleGroups[dayIndex];
    
    return Workout(
      id: 'advanced_single_muscle_${dayIndex + 1}',
      title: '${dayNames[dayIndex]} - $muscleGroup',
      description: 'Day ${dayIndex + 1} of 6-day advanced single muscle split focusing on $muscleGroup',
      category: 'Strength',
      difficulty: 'Advanced',
      imageUrl: 'assets/images/workouts/advanced_single_muscle.jpg',
      exercises: _getExercises(),
      addedAt: DateTime.now(),
      customDuration: 440, // Fixed 440 minutes for advanced workouts
    );
  }

  @override
  Widget build(BuildContext context) {
    final workout = _buildWorkout();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced ${muscleGroups[dayIndex]} Workout'),
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
