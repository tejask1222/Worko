import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../services/exercise_library_service.dart';
import '../../active_workout_page.dart';
import '../../services/workout_instructions_service.dart';

class BeginnerSingleMusclePage extends StatelessWidget {
  static const List<String> dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  static const List<String> muscleGroups = ['Chest', 'Back', 'Biceps', 'Triceps', 'Shoulders', 'Legs'];
  
  final int dayIndex;

  const BeginnerSingleMusclePage({
    Key? key,
    required this.dayIndex,
  }) : super(key: key);

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
    final exerciseIds = _getExerciseIdsForGroup(muscleGroup);
    
    return exerciseIds.map((id) => _getExercise(exercises, id)).toList();
  }

  List<String> _getExerciseIdsForGroup(String muscleGroup) {
    switch (muscleGroup) {
      case 'Chest':
        return ['barbell_benchpress', 'incline_dumbbell_press', 'cable_chest_fly'];
      case 'Back':
        return ['latPulldown', 'seated_cable_row', 'dumbbell_row'];
      case 'Biceps':
        return ['barbell_curl', 'hammer_curl', 'concentration_curl'];
      case 'Triceps':
        return ['tricep_pushdowns', 'skull_crushers', 'tricep_kickbacks'];
      case 'Shoulders':
        return ['barbell_overhead_press', 'lateralRaises', 'rear_delt_fly'];
      case 'Legs':
        return ['squats', 'leg_press', 'leg_extension'];
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
      sets: 3,
      reps: 12,
      calories: exercise.targetMuscles.contains('Cardio') ? 70 : 50,
    );
  }
  Workout _buildWorkout() {
    return Workout(
      id: 'beginner_single_muscle_${dayIndex + 1}',
      title: '${dayNames[dayIndex]} - ${muscleGroups[dayIndex]}',
      description: 'Day ${dayIndex + 1} of 6-day beginner single muscle split focusing on ${muscleGroups[dayIndex]}',
      category: 'Strength',
      difficulty: 'Beginner',
      imageUrl: 'assets/images/workouts/beginner_single_muscle.jpg',
      exercises: _getExercises(),
      addedAt: DateTime.now(),
      customDuration: 30, // 30 minutes for beginner workouts
    );
  }

  int _calculateTotalCalories(List<WorkoutExercise> exercises) {
    return exercises.fold(0, (sum, exercise) => sum + exercise.config.calories);
  }

  int _calculateEstimatedDuration(List<WorkoutExercise> exercises) {
    final totalSets = exercises.fold(0, (sum, exercise) => sum + exercise.config.sets);
    return (totalSets * 2).round(); // 2 minutes per set for beginners (including rest)
  }

  @override
  Widget build(BuildContext context) {
    final workout = _buildWorkout();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Beginner ${muscleGroups[dayIndex]} Workout'),
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
            ListView.builder(
              padding: const EdgeInsets.all(16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
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
                            _buildDetail('Sets', '3'),
                            _buildDetail('Reps', '12'),
                            _buildDetail('Rest', '90 sec'),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Tip: Focus on proper form and controlled movements.',
                            style: TextStyle(
                              color: Colors.blue[700],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
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
