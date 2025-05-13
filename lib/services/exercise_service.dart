import '../models/workout.dart';
import 'exercise_library_service.dart';

class ExerciseService {
  static String _getMuscleGroupForExercise(String id) {
    String muscleTarget = _getMuscleTarget(id);
    switch (muscleTarget) {
      case 'Chest':
      case 'Triceps':
        return muscleTarget;
      case 'Back':
      case 'Biceps':
        return muscleTarget;
      case 'Legs':
      case 'Shoulders':
        return muscleTarget;
      default:
        return 'Other';
    }
  }

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
          'overhead_tricep_extension'
        ]
      },
      'Advanced': {
        'exercises': [
          'bench_press',
          'incline_dumbbell_press',
          'cable_chest_fly',
          'chest_dips',
          'skull_crushers',
          'tricep_pushdowns',
          'close_grip_bench_press',
          'overhead_tricep_extension'
        ]
      }
    },
    'Tuesday': {
      'Beginner': {
        'exercises': [
          'pull_ups',
          'latPulldown',
          'seated_cable_row',
          'barbell_curl'
        ]
      },
      'Intermediate': {
        'exercises': [
          'pull_ups',
          'barbell_row',
          'seated_cable_row',
          'barbell_curl',
          'hammer_curl',
          'zottman_curl'
        ]
      },
      'Advanced': {
        'exercises': [
          'pull_ups',
          'deadlifts',
          'barbell_row',
          'seated_cable_row',
          'barbell_curl',
          'incline_dumbbell_curl',
          'preacher_curl',
          'cable_curl'
        ]
      }
    },
    'Wednesday': {
      'Beginner': {
        'exercises': [
          'squats',
          'leg_press',
          'leg_curl',
          'standing_calf_raise',
          'dumbbell_shoulder_press'
        ]
      },
      'Intermediate': {
        'exercises': [
          'squats',
          'romanian_deadlift',
          'leg_press',
          'leg_curl',
          'standing_calf_raise',
          'dumbbell_shoulder_press',
          'lateralRaises',
          'rear_delt_fly'
        ]
      },
      'Advanced': {
        'exercises': [
          'squats',
          'front_squat',
          'romanian_deadlift',
          'leg_press',
          'leg_curl',
          'standing_calf_raise',
          'dumbbell_shoulder_press',
          'arnold_press',
          'lateralRaises',
          'upright_row'
        ]
      }
    },
    'Thursday': {
      'Beginner': {
        'exercises': [
          'dumbbell_bench_press',
          'cable_chest_fly',
          'chest_dips', // Using chest_dips instead of tricep_dips for consistent naming
          'tricep_pushdowns'
        ]
      },
      'Intermediate': {
        'exercises': [
          'dumbbell_bench_press',
          'incline_bench_press',
          'cable_chest_fly',
          'chest_dips',
          'skull_crushers',
          'tricep_pushdowns'
        ]
      },
      'Advanced': {
        'exercises': [
          'dumbbell_bench_press',
          'incline_bench_press',
          'decline_bench_press',
          'cable_chest_fly',
          'chest_dips',
          'close_grip_bench_press',
          'skull_crushers',
          'tricep_pushdowns'
        ]
      }
    },
    'Friday': {
      'Beginner': {
        'exercises': [
          'barbell_row',
          'lat_pulldown',
          'barbell_curl', // Changed from zottman_curl since it's not in beginner exercises
          'hammer_curl'
        ]
      },
      'Intermediate': {
        'exercises': [
          'deadlifts',
          'barbell_row',
          'lat_pulldown',
          'zottman_curl',
          'preacher_curl',
          'cable_curl'
        ]
      },
      'Advanced': {
        'exercises': [
          'deadlifts',
          'barbell_row',
          'meadows_row',
          'lat_pulldown',
          'zottman_curl',
          'preacher_curl',
          'spider_curl',
          'cable_curl'
        ]
      }
    },
    'Saturday': {
      'Beginner': {
        'exercises': [
          'squats',
          'leg_press',
          'seated_calf_raise',
          'barbell_overhead_press',
          'lateralRaises'
        ]
      },
      'Intermediate': {
        'exercises': [
          'squats',
          'hack_squat',
          'leg_press',
          'leg_curl',
          'seated_calf_raise',
          'barbell_overhead_press',
          'lateralRaises',
          'face_pulls'
        ]
      },
      'Advanced': {
        'exercises': [
          'squats',
          'hack_squat',
          'bulgarian_split_squat',
          'leg_press',
          'leg_curl',
          'seated_calf_raise',
          'barbell_overhead_press',
          'military_press',
          'lateralRaises',
          'face_pulls'
        ]
      }
    }
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
    'Biceps': {
      'Beginner': ['barbell_curl', 'hammer_curl', 'concentration_curl'],
      'Intermediate': ['barbell_curl', 'preacher_curl', 'incline_dumbbell_curl', 'cable_curl'],
      'Advanced': ['barbell_curl', 'preacher_curl', 'incline_dumbbell_curl', 'hammer_curl', 'spider_curl', 'cable_curl'],
    },
    'Triceps': {
      'Beginner': ['tricep_pushdowns', 'skull_crushers', 'tricep_kickbacks'],
      'Intermediate': ['close_grip_bench_press', 'skull_crushers', 'overhead_tricep_extension', 'tricep_pushdowns'],
      'Advanced': ['close_grip_bench_press', 'skull_crushers', 'tricep_pushdowns', 'overhead_cable_extension', 'overhead_tricep_extension', 'tricep_kickbacks'],
    },
    'Shoulders': {
      'Beginner': ['barbell_overhead_press', 'lateral_raises', 'rear_delt_fly'],
      'Intermediate': ['dumbbell_shoulder_press', 'arnold_press', 'lateral_raises', 'rear_delt_fly'],
      'Advanced': ['barbell_overhead_press', 'dumbbell_shoulder_press', 'arnold_press', 'lateral_raises', 'front_raise', 'rear_delt_fly'],
    },
    'Legs': {
      'Beginner': ['squats', 'leg_press', 'leg_curl'],
      'Intermediate': ['squats', 'leg_press', 'leg_curl', 'romanian_deadlift'],
      'Advanced': ['squats', 'front_squat', 'leg_press', 'romanian_deadlift', 'leg_curl'],
    },
  };

  static int _getSetsForDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 3; // 3 sets for beginners to build foundation
      case 'intermediate':
        return 4; // 4 sets for intermediates to increase volume
      case 'advanced':
        return 5; // 5 sets for advanced to maximize volume
      default:
        return 3;
    }
  }

  static int _getRepsForDifficulty(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 12; // Higher reps for form and endurance
      case 'intermediate':
        return 10; // Moderate reps balancing hypertrophy and strength
      case 'advanced':
        return 8; // Lower reps focusing on strength and progressive overload
      default:
        return 12;
    }
  }

  static int getCalories(String difficulty, String workoutType) {
    return defaultCalories[difficulty]?[workoutType] ?? 900; // Default to 900 calories
  }

  static ExerciseConfig getExerciseConfig(String id, {required String difficulty, String workoutType = 'SingleMuscle'}) {
    int sets;
    int reps;
    int calories = getCalories(difficulty, workoutType);

    switch (difficulty.toLowerCase()) {
      case 'beginner':
        sets = 3;
        reps = 12;
        break;
      case 'intermediate':
        sets = 4;
        reps = 10;
        break;
      case 'advanced':
        sets = 5;
        reps = 8;
        break;
      default:
        sets = 3;
        reps = 12;
    }

    return ExerciseConfig(
      sets: sets,
      reps: reps,
      calories: calories,
    );
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
  static int getWorkoutDuration(String difficulty, [String? day]) {
    // If no day is provided, return default duration
    if (day == null) {
      switch (difficulty.toLowerCase()) {
        case 'beginner':
          return 120; // Default for non-PPL beginner workouts
        case 'intermediate':
          return 290; // Default for non-PPL intermediate workouts
        case 'advanced':
          return 440; // Default for non-PPL advanced workouts
        default:
          return 180;
      }
    }

    // For PPL workouts, return specific durations based on day and difficulty
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        // Monday, Tuesday, Thursday, Friday: 25min
        // Wednesday, Saturday: 30min
        if (day == 'Wednesday' || day == 'Saturday') {
          return 30;
        }
        return 25;
        
      case 'intermediate':
        // Monday, Tuesday, Thursday, Friday: 45min
        // Wednesday, Saturday: 60min
        if (day == 'Wednesday' || day == 'Saturday') {
          return 60;
        }
        return 45;
        
      case 'advanced':
        // Monday, Tuesday, Thursday, Friday: 70min
        // Wednesday, Saturday: 90min
        if (day == 'Wednesday' || day == 'Saturday') {
          return 90;
        }
        return 70;
        
      default:
        return 180;
    }
  }
  static final Map<String, Map<String, int>> defaultCalories = {
    'Beginner': {'PPL': 160, 'SingleMuscle': 900},
    'Intermediate': {'PPL': 1650, 'SingleMuscle': 1680},
    'Advanced': {'PPL': 2430, 'SingleMuscle': 3240},
  };

  static List<WorkoutExercise> getExercisesForMuscle(String muscleGroup, String difficulty) {
    final List<String> exerciseIdsList = exerciseIds[muscleGroup]?[difficulty] ?? [];
    final List<WorkoutExercise> exercises = [];

    for (final exerciseId in exerciseIdsList) {
      final Exercise exercise = findExercise(muscleGroup, exerciseId);
      final ExerciseConfig config = getExerciseConfig(exerciseId, difficulty: difficulty);
      exercises.add(WorkoutExercise(exercise: exercise, config: config));
    }

    return exercises;
  }

  static List<WorkoutExercise> getExercisesForPPLWorkout(String day, String difficulty) {
    List<String> exerciseIds = pplExerciseIds[day]?[difficulty]?['exercises'] ?? [];
    return exerciseIds.map((id) {
      final allExercises = ExerciseLibraryService.getAllExercises();
      final exercise = allExercises.firstWhere(
        (e) => e.id == id,
        orElse: () => Exercise(
          id: id,
          name: _getExerciseName(id),
          description: 'Target: ${_getMuscleTarget(id)}',
          targetMuscles: _getMuscleTarget(id),
          imageUrl: 'assets/images/workouts/$id.jpg',
        ),
      );

      final config = ExerciseConfig(
        sets: _getSetsForDifficulty(difficulty),
        reps: _getRepsForDifficulty(difficulty),
        calories: _getCaloriesForExercise(id, difficulty),
      );

      return WorkoutExercise(exercise: exercise, config: config);
    }).toList();
  }

  static List<WorkoutExercise> getPPLExercises(String splitType, String difficulty) {
    String day;
    switch (splitType.toLowerCase()) {
      case 'push':
        day = 'Monday';
        break;
      case 'pull':
        day = 'Tuesday';
        break;
      case 'legs':
        day = 'Wednesday';
        break;
      default:
        return [];
    }

    final exerciseIds = pplExerciseIds[day]?[difficulty]?['exercises'] ?? [];
    if (exerciseIds.isEmpty) return [];

    final totalCalories = defaultCalories[difficulty]?['PPL'] ?? 900;
    final caloriesPerExercise = totalCalories ~/ exerciseIds.length;

    return exerciseIds.map((id) {
      final muscleGroup = _getMuscleGroupForExercise(id);
      try {
        final exercise = findExercise(muscleGroup, id);
        return WorkoutExercise(
          exercise: exercise,
          config: ExerciseConfig(
            sets: _getSetsForDifficulty(difficulty),
            reps: _getRepsForDifficulty(difficulty),
            calories: caloriesPerExercise,
          ),
        );
      } catch (e) {
        print('Error creating exercise for $id: $e');
        return null;
      }
    }).whereType<WorkoutExercise>().toList();
  }

  static bool isPPLWorkoutDay(String day) {
    return pplExerciseIds.containsKey(day);
  }

  static String _getExerciseName(String id) {
    return id.split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  static String _getMuscleTarget(String id) {
    if (id.contains('press') || id.contains('fly') || id.contains('dips')) return 'Chest';
    if (id.contains('curl')) return 'Biceps';
    if (id.contains('tricep') || id.contains('skull') || id.contains('pushdown')) return 'Triceps';
    if (id.contains('squat') || id.contains('lunge') || id.contains('calf')) return 'Legs';
    if (id.contains('row') || id.contains('pulldown') || id.contains('deadlift')) return 'Back';
    if (id.contains('lateral') || id.contains('press') || id.contains('raise')) return 'Shoulders';
    return 'Other';
  }

  static int _getCaloriesForExercise(String id, String difficulty) {
    final Map<String, Map<String, int>> caloriesByExercise = {
      // Push exercises
      'bench_press': {'Beginner': 35, 'Intermediate': 40, 'Advanced': 45},
      'dumbbell_bench_press': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'incline_bench_press': {'Beginner': 35, 'Intermediate': 40, 'Advanced': 45},
      'decline_bench_press': {'Beginner': 35, 'Intermediate': 40, 'Advanced': 45},
      'cable_chest_fly': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'tricep_dips': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'skull_crushers': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'tricep_pushdowns': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'overhead_tricep_extension': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'close_grip_bench_press': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},

      // Pull exercises
      'pullups': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'latPulldown': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'barbell_row': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'meadows_row': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'seated_cable_row': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'deadlifts': {'Beginner': 45, 'Intermediate': 50, 'Advanced': 55},
      'barbell_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'hammer_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'incline_dumbbell_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'preacher_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'spider_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'zottman_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'cable_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},

      // Legs exercises
      'squats': {'Beginner': 50, 'Intermediate': 60, 'Advanced': 65},
      'front_squat': {'Beginner': 45, 'Intermediate': 55, 'Advanced': 60},
      'hack_squat': {'Beginner': 45, 'Intermediate': 55, 'Advanced': 60},
      'bulgarian_split_squat': {'Beginner': 35, 'Intermediate': 45, 'Advanced': 50},
      'leg_press': {'Beginner': 40, 'Intermediate': 45, 'Advanced': 50},
      'leg_curl': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'romanian_deadlift': {'Beginner': 40, 'Intermediate': 50, 'Advanced': 55},
      'standing_calf_raise': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'seated_calf_raise': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},

      // Shoulder exercises
      'dumbbell_shoulder_press': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'barbell_overhead_press': {'Beginner': 35, 'Intermediate': 40, 'Advanced': 45},
      'military_press': {'Beginner': 35, 'Intermediate': 40, 'Advanced': 45},
      'arnold_press': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'lateralRaises': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'front_raise': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'upright_row': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'face_pulls': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'rear_delt_fly': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
    };

    // Get calories for the specific exercise and difficulty, or use a default value
    return caloriesByExercise[id]?[difficulty] ??
        (difficulty == 'Beginner' ? 70 : difficulty == 'Intermediate' ? 95 : 115);
  }

  static String getPPLDayDescription(String day) {
    switch (day) {
      case 'Monday':
      case 'Thursday':
        return 'Push Day (Chest + Triceps)';
      case 'Tuesday':
      case 'Friday':
        return 'Pull Day (Back + Biceps)';
      case 'Wednesday':
      case 'Saturday':
        return 'Legs Day + Shoulders';
      default:
        return 'Rest Day';
    }
  }

  static final Map<String, List<String>> pplMuscleGroups = {
    'Push': ['Chest', 'Shoulders', 'Triceps'],
    'Pull': ['Back', 'Biceps'],
    'Legs': ['Legs', 'Shoulders'],
  };

  static final Map<String, String> dayToSplitType = {
    'Monday': 'Push',
    'Tuesday': 'Pull',
    'Wednesday': 'Legs',
    'Thursday': 'Push',
    'Friday': 'Pull',
    'Saturday': 'Legs',
  };

  static List<String> getPPLDays() {
    return ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
  }
}
