import 'package:flutter/material.dart';
import '../../models/workout.dart';
import '../../services/exercise_library_service.dart';
import '../../active_workout_page.dart';
import '../../services/workout_instructions_service.dart';

class SingleMuscleSplitPage extends StatelessWidget {
  static const List<String> dayNames = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  static const List<String> muscleGroups = ['Chest', 'Back', 'Biceps', 'Triceps', 'Shoulders', 'Legs'];
  
  final String difficulty;
  final int dayIndex;

  const SingleMuscleSplitPage({
    Key? key,
    required this.difficulty,
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
    final exerciseIds = _getExerciseIdsForLevel(muscleGroup);
    
    return exerciseIds.map((id) => _getExercise(exercises, id)).toList();
  }

  List<String> _getExerciseIdsForLevel(String muscleGroup) {
    switch (muscleGroup) {
      case 'Chest':
        return difficulty.toLowerCase() == 'beginner' 
          ? ['barbell benchpresss', 'incline_dumbbell_press', 'cable_chest_fly']
          : difficulty.toLowerCase() == 'intermediate'
            ? ['barbell benchpresss', 'incline_dumbbell_press', 'dumbbell_pullover', 'cable_chest_fly']
            : ['barbell benchpresss', 'incline_dumbbell_press', 'decline_bench_press', 'dumbbell_pullover', 'chest_dips', 'cable_chest_fly'];
      case 'Back':
        return difficulty.toLowerCase() == 'beginner'
          ? ['lat_pulldown', 'seated_cable_row', 'dumbbell_row']
          : difficulty.toLowerCase() == 'intermediate'
            ? ['deadlift', 'lat_pulldown', 'dumbbell_row', 'seated_cable_row']
            : ['deadlift', 'bent_over_row', 'pullups', 'seated_cable_row'];
      case 'Legs':
        return difficulty.toLowerCase() == 'beginner'
          ? ['squats', 'leg_press', 'leg_curl', 'leg_extension']
          : difficulty.toLowerCase() == 'intermediate'
            ? ['squats', 'leg_press', 'leg_curl', 'leg_extension']
            : ['squats', 'front_squat', 'leg_press', 'romanian_deadlift', 'leg_curl', 'leg_extension'];
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
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return ExerciseConfig(sets: 3, reps: 12, calories: 50);
      case 'intermediate':
        return ExerciseConfig(sets: 4, reps: 10, calories: 70);
      case 'advanced':
      default:
        return ExerciseConfig(
          sets: 5,
          reps: 8,
          calories: exercise.targetMuscles.contains('Cardio') ? 150 : 90,
        );
    }  }

  Workout _buildWorkout() {
    final dailyDuration = difficulty.toLowerCase() == 'beginner' ? 30
                       : difficulty.toLowerCase() == 'intermediate' ? 45
                       : 60;
    
    return Workout(
      id: '${difficulty.toLowerCase()}_single_muscle_${dayIndex + 1}',
      title: '${dayNames[dayIndex]} - ${muscleGroups[dayIndex]} ($difficulty)',
      description: 'Day ${dayIndex + 1} of 6-day $difficulty single muscle split focusing on ${muscleGroups[dayIndex]}',
      category: 'Strength',
      difficulty: difficulty,
      imageUrl: 'assets/images/workouts/${difficulty.toLowerCase()}_single_muscle.jpg',
      exercises: _getExercises(),
      addedAt: DateTime.now(),
      customDuration: dailyDuration,
    );
  }
  int _calculateTotalCalories(List<WorkoutExercise> exercises) {
    return exercises.fold(0, (sum, exercise) => sum + exercise.config.calories);
  }

  int _calculateEstimatedDuration(List<WorkoutExercise> exercises) {
    final totalSets = exercises.fold(0, (sum, exercise) => sum + exercise.config.sets);
    return (totalSets * 1.5).round(); // 1.5 minutes per set including rest
  }

  @override
  Widget build(BuildContext context) {
    final workout = _buildWorkout();
    
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          workout.title,
          style: const TextStyle(color: Colors.black),
        ),
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
                  const SizedBox(width: 24),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      difficulty,
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Exercises',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
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
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(
                          exercise.exercise.imageUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise.exercise.name,
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
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Target: ${exercise.exercise.targetMuscles}',
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildDetail('Sets', exercise.config.sets.toString()),
                                _buildDetail('Reps', exercise.config.reps.toString()),
                                _buildDetail('Calories', '${exercise.config.calories}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
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
