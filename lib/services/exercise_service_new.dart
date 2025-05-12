import '../models/workout.dart';
import 'exercise_library_service.dart';

class ExerciseService {
  static final Map<String, Map<String, int>> defaultCalories = {
    'Beginner': {'PPL': 160, 'SingleMuscle': 900},
    'Intermediate': {'PPL': 1650, 'SingleMuscle': 1680},
    'Advanced': {'PPL': 2430, 'SingleMuscle': 3240},
  };

  static final Map<String, Map<String, List<String>>> exerciseIds = {
    'Chest': {
      'Beginner': ['barbell benchpresss', 'incline_dumbbell_press', 'cable_chest_fly'],
      'Intermediate': ['barbell benchpresss', 'incline_dumbbell_press', 'dumbbell_pullover', 'cable_chest_fly'],
      'Advanced': ['barbell benchpresss', 'incline_dumbbell_press', 'decline_bench_press', 'dumbbell_pullover', 'chest_dips', 'cable_chest_fly'],
    },
    'Back': {
      'Beginner': ['lat_pulldown', 'seated_cable_row', 'dumbbell_row'],
      'Intermediate': ['deadlift', 'lat_pulldown', 'dumbbell_row', 'seated_cable_row'],
      'Advanced': ['deadlift', 'bent_over_row', 'pullups', 'seated_cable_row'],
    },
  };

  static final Map<String, Map<String, Map<String, List<String>>>> pplExerciseIds = {
    'Monday': {
      'Beginner': {
        'exercises': [
          'bench_press',
          'incline_dumbbell_press',
          'chest_dips',
          'tricep_pushdowns'
        ]
      },
      'Intermediate': {
        'exercises': [
          'bench_press',
          'incline_dumbbell_press',
          'chest_dips',
          'cable_chest_fly',
          'tricep_pushdowns',
        ]
      },
      'Advanced': {
        'exercises': [
          'bench_press',
          'incline_dumbbell_press',
          'cable_chest_fly',
          'chest_dips',
          'tricep_pushdowns',
          'close_grip_bench_press',
        ]
      }
    }
  };

  static int getCalories(String difficulty, String workoutType) {
    final totalCalories = defaultCalories[difficulty]?[workoutType] ?? 900;
    return totalCalories;
  }

  static int getWorkoutDuration(String difficulty, [String? day]) {
    switch (difficulty.toLowerCase()) {      case 'beginner':
        return 120;
      case 'intermediate':
        return 290;
      case 'advanced':
        return 440;
      default:
        return 180;
    }
  }

  static Exercise findExercise(String muscleGroup, String exerciseId) {
    try {
      final exercises = ExerciseLibraryService.getExercisesByMuscleGroup(muscleGroup);
      return exercises.firstWhere(
        (e) => e.id == exerciseId,
        orElse: () => exercises.first,
      );
    } catch (e) {
      throw Exception('Could not find exercise: $muscleGroup / $exerciseId');
    }
  }

  static int _getSetsForDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 3;
      case 'intermediate':
        return 4;
      case 'advanced':
        return 5;
      default:
        return 3;
    }
  }

  static int _getRepsForDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 12;
      case 'intermediate':
        return 10;
      case 'advanced':
        return 8;
      default:
        return 12;
    }
  }

  static int _getCaloriesForExercise(String id, String difficulty) {
    String workoutType = id.contains('ppl') ? 'PPL' : 'SingleMuscle';
    final totalCalories = defaultCalories[difficulty]?[workoutType] ?? 900;
    // Calculate per-exercise calories based on workout type
    if (workoutType == 'PPL') {
      // For PPL, split total calories among exercises in that day's workout
      for (final dayData in pplExerciseIds.values) {
        final exercises = dayData[difficulty]?['exercises'] as List<String>?;
        if (exercises != null && exercises.contains(id)) {
          return totalCalories ~/ exercises.length;
        }
      }
    } else {
      // For SingleMuscle, split total calories among exercises in the muscle group
      for (final muscleGroup in exerciseIds.values) {
        final exercises = muscleGroup[difficulty];
        if (exercises != null && exercises.contains(id)) {
          return totalCalories ~/ exercises.length;
        }
      }
    }
    return totalCalories; // Default to total workout calories if no distribution found
  }

  static ExerciseConfig getExerciseConfig(String id, {required String difficulty, String workoutType = 'SingleMuscle'}) {
    return ExerciseConfig(
      sets: _getSetsForDifficulty(difficulty),
      reps: _getRepsForDifficulty(difficulty),
      calories: _getCaloriesForExercise(id, difficulty),
    );
  }

  static List<WorkoutExercise> getExercisesForMuscle(String muscleGroup, String difficulty) {
    final List<String> exerciseIdsList = exerciseIds[muscleGroup]?[difficulty] ?? [];
    return exerciseIdsList.map((exerciseId) {
      final Exercise exercise = findExercise(muscleGroup, exerciseId);
      final ExerciseConfig config = getExerciseConfig(exerciseId, difficulty: difficulty);
      return WorkoutExercise(exercise: exercise, config: config);
    }).toList();
  }

  static List<WorkoutExercise> getExercisesForPPLWorkout(String day, String difficulty) {
    List<String> exerciseIds = pplExerciseIds[day]?[difficulty]?['exercises'] ?? [];
    return exerciseIds.map((id) {
      final allExercises = ExerciseLibraryService.getAllExercises();
      final exercise = allExercises.firstWhere(
        (e) => e.id == id,
        orElse: () => Exercise(
          id: id,
          name: id.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' '),
          description: 'Default exercise',
          targetMuscles: 'Default target',
          imageUrl: 'assets/images/workouts/$id.jpg',
        ),
      );

      return WorkoutExercise(exercise: exercise, config: getExerciseConfig(id, difficulty: difficulty, workoutType: 'PPL'));
    }).toList();
  }

  static bool isPPLWorkoutDay(String day) {
    return pplExerciseIds.containsKey(day);
  }

  static List<String> getPPLDays() {
    return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  }
}
