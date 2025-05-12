import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../services/exercise_library_service.dart';
import '../../active_workout_page.dart';
import '../../services/workout_instructions_service.dart';

class AdvancedPPLPage extends StatelessWidget {
  static const List<String> dayNames = ['Monday', 'Tuesday', 'Wednesday'];
  static const List<String> splitTypes = ['Push', 'Pull', 'Legs'];
  
  final int dayIndex;

  const AdvancedPPLPage({
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
          'cable_chest_fly',
          'chest_dips',
          'skull_crushers',
          'tricep_pushdowns',
          'close_grip_bench_press',
          'overhead_tricep_extension'
        ];
      case 'Pull':
        return [
          'deadlifts',
          'bent_over_row',
          'pullups',
          'seated_cable_row',
          'barbell_curl',
          'incline_dumbbell_curl',
          'preacher_curl',
          'cable_curl'
        ];
      case 'Legs':
        return [
          'squats',
          'romanian_deadlifts',
          'leg_press',
          'standing_calf_raises',
          'dumbbell_shoulder_press',
          'arnold_press',
          'lateralRaises',
          'upright_row',
          'front_raise'
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
    final primaryCompound = [
      'barbell_benchpress',
      'deadlifts',
      'squats',
    ].contains(exercise.id);

    final secondaryCompound = [
      'romanian_deadlifts',
      'bent_over_row',
      'dumbbell_shoulder_press',
      'close_grip_bench_press',
    ].contains(exercise.id);

    if (primaryCompound) {
      return ExerciseConfig(sets: 5, reps: 6, calories: _getCaloriesForExercise(exercise.id));
    } else if (secondaryCompound) {
      return ExerciseConfig(sets: 4, reps: 8, calories: _getCaloriesForExercise(exercise.id));
    } else {
      return ExerciseConfig(sets: 4, reps: 10, calories: _getCaloriesForExercise(exercise.id));
    }
  }

  int _getCaloriesForExercise(String exerciseId) {
    final caloriesMap = {
      'barbell_benchpress': 60,
      'incline_dumbbell_press': 50,
      'cable_chest_fly': 40,
      'chest_dips': 40,
      'skull_crushers': 35,
      'tricep_pushdowns': 30,
      'close_grip_bench_press': 35,
      'overhead_tricep_extension': 30,
      'deadlifts': 70,
      'bent_over_row': 50,
      'pullups': 45,
      'seated_cable_row': 40,
      'barbell_curl': 35,
      'incline_dumbbell_curl': 30,
      'preacher_curl': 30,
      'cable_curl': 30,
      'squats': 65,
      'romanian_deadlifts': 55,
      'leg_press': 45,
      'standing_calf_raises': 30,
      'dumbbell_shoulder_press': 35,
      'arnold_press': 30,
      'lateralRaises': 25,
      'upright_row': 25,
      'front_raise': 20,
    };
    return caloriesMap[exerciseId] ?? 40;
  }

  String _getSplitDescription(String splitType) {
    switch (splitType) {
      case 'Push':
        return 'Advanced chest and triceps hypertrophy workout';
      case 'Pull':
        return 'Advanced back and biceps strength training';
      case 'Legs':
        return 'Advanced legs and shoulders volume workout';
      default:
        return '';
    }
  }

  Workout _buildWorkout() {
    final splitType = splitTypes[dayIndex];
    return Workout(
      id: 'advanced_ppl_${dayIndex + 1}',
      title: '${dayNames[dayIndex]} - $splitType',
      description: _getSplitDescription(splitType),
      category: 'Strength',
      difficulty: 'Advanced',
      imageUrl: 'assets/images/workouts/advanced_ppl.jpg',
      exercises: _getExercises(),
      addedAt: DateTime.now(),
      customDuration: 75,
    );
  }

  int _calculateTotalCalories(List<WorkoutExercise> exercises) {
    return exercises.fold(0, (sum, exercise) => sum + exercise.config.calories);
  }

  int _calculateEstimatedDuration(List<WorkoutExercise> exercises) {
    return 75; // Fixed 75 minutes for advanced workouts
  }

  @override
  Widget build(BuildContext context) {
    final workout = _buildWorkout();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Advanced ${splitTypes[dayIndex]} Workout'),
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
                'Advanced Training Protocol:',
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
                    Text('• Primary compounds: 5 sets × 6 reps'),
                    Text('• Secondary compounds: 4 sets × 8 reps'),
                    Text('• Isolation exercises: 4 sets × 10 reps'),
                    Text('• Rest 2-3 mins for compounds'),
                    Text('• Rest 1-2 mins for isolations'),
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
                final isPrimaryCompound = [
                  'barbell_benchpress',
                  'deadlifts',
                  'squats',
                ].contains(exercise.exercise.id);

                final isSecondaryCompound = [
                  'romanian_deadlifts',
                  'bent_over_row',
                  'dumbbell_shoulder_press',
                  'close_grip_bench_press',
                ].contains(exercise.exercise.id);

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
                            _buildDetail('Sets', isPrimaryCompound ? '5' : '4'),
                            _buildDetail(
                              'Reps', 
                              isPrimaryCompound ? '6' : 
                              isSecondaryCompound ? '8' : '10'
                            ),
                            _buildDetail(
                              'Rest',
                              isPrimaryCompound || isSecondaryCompound ? '2-3m' : '1-2m'
                            ),
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
