import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../services/exercise_library_service.dart';
import '../../services/exercise_service.dart';
import '../../active_workout_page.dart';
import '../../services/workout_instructions_service.dart';

class IntermediatePPLPage extends StatelessWidget {
  static const List<String> dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  static const List<String> splitTypes = ['Push', 'Pull', 'Legs', 'Push', 'Pull', 'Legs'];
  
  final int dayIndex;

  const IntermediatePPLPage({
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
    final exerciseIds = _getExerciseIdsForType(splitType);
    
    return exerciseIds.map((id) => _getExercise(exercises, id)).toList();
  }

  List<String> _getExerciseIdsForType(String splitType) {
    switch (splitType) {
      case 'Push':
        return [
          'barbell_benchpress',
          'incline_dumbbell_press',
          'decline_bench_press',
          'tricep_pushdowns',
          'tricep_kickbacks',
        ];
      case 'Pull':
        return [
          'latPulldown',
          'seated_cable_row',
          'dumbbell_row',
          'barbell_curl',
          'hammer_curl',
        ];
      case 'Legs':
        return [
          'squats',
          'leg_press',
          'romanian_deadlift',
          'barbell_overhead_press',
          'lateralRaises',
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
      sets: 4,
      reps: 10,
      calories: 1650 ~/ _getExerciseIdsForType(splitTypes[dayIndex]).length, // Distribute 1650 calories evenly
    );
  }

  String _getSplitDescription(String splitType) {
    switch (splitType) {
      case 'Push':
        return 'Intermediate chest and triceps workout';
      case 'Pull':
        return 'Intermediate back and biceps training';
      case 'Legs':
        return 'Intermediate legs and shoulders session';
      default:
        return '';
    }
  }

  Workout _buildWorkout() {
    final splitType = splitTypes[dayIndex];
    return Workout(
      id: 'intermediate_ppl_${dayIndex + 1}',
      title: '${dayNames[dayIndex]} - $splitType',
      description: _getSplitDescription(splitType),
      category: 'Strength',
      difficulty: 'Intermediate',
      imageUrl: 'assets/images/workouts/intermediate_ppl.jpg',
      exercises: _getExercises(),
      addedAt: DateTime.now(),      customDuration: 300, // 300 minutes for intermediate PPL workouts
      customCalories: 1650, // 1650 calories for intermediate PPL workouts
    );
  }

  int _calculateTotalCalories(List<WorkoutExercise> exercises) {
    return 1650; // Fixed 1650 calories for intermediate PPL workouts
  }

  int _calculateEstimatedDuration(List<WorkoutExercise> exercises) {
    return 300; // Fixed 300 minutes for intermediate PPL workouts
  }

  @override
  Widget build(BuildContext context) {
    final workout = _buildWorkout();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Intermediate ${splitTypes[dayIndex]} Workout'),
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
                'Workout Guidelines:',
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
                    Text('• Compound lifts: 4 sets × 8-10 reps'),
                    Text('• Isolation exercises: 3 sets × 10-12 reps'),
                    Text('• Rest 60-90 seconds between sets'),
                    Text('• Progressive overload when possible'),
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
                final isCompound = [
                  'barbell_benchpress',
                  'deadlifts',
                  'squats',
                  'romanian_deadlifts',
                  'dumbbell_shoulder_press'
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
                            _buildDetail('Sets', isCompound ? '4' : '3'),
                            _buildDetail('Reps', isCompound ? '8-10' : '10-12'),
                            _buildDetail('Rest', '60-90s'),
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
