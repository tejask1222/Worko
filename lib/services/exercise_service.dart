import '../models/workout.dart';
import 'exercise_library_service.dart';

class ExerciseService {
  static final Map<String, Map<String, Map<String, List<String>>>> pplExerciseIds = {
    'Monday': {
      'Beginner': {
        'exercises': [
          'bench_press', 'incline_dumbbell_press', 'tricep_pushdowns', 'overhead_tricep_extension'
        ]
      },
      'Intermediate': {
        'exercises': [
          'flat_barbell_bench', 'incline_dumbbell_press', 'cable_chest_fly',
          'skull_crushers', 'tricep_pushdowns', 'overhead_tricep_extension'
        ]
      },
      'Advanced': {
        'exercises': [
          'flat_barbell_bench', 'incline_dumbbell_press', 'cable_chest_fly', 'chest_dips',
          'skull_crushers', 'tricep_pushdowns', 'close_grip_bench_press', 'overhead_tricep_extension'
        ]
      }
    },
    'Tuesday': {
      'Beginner': {
        'exercises': [
          'lat_pulldown', 'seated_cable_row', 'barbell_curl', 'hammer_curl'
        ]
      },
      'Intermediate': {
        'exercises': [
          'deadlift', 'pullups', 'seated_cable_row',
          'barbell_curl', 'preacher_curl', 'hammer_curl'
        ]
      },
      'Advanced': {
        'exercises': [
          'deadlift', 'bent_over_row', 'pullups', 'seated_cable_row',
          'barbell_curl', 'incline_dumbbell_curl', 'preacher_curl', 'cable_curl'
        ]
      }
    },
    'Wednesday': {
      'Beginner': {
        'exercises': [
          'squats', 'leg_curl', 'dumbbell_shoulder_press', 'lateral_raises', 'rear_delt_fly'
        ]
      },
      'Intermediate': {
        'exercises': [
          'back_squat', 'romanian_deadlift', 'standing_calf_raise',
          'dumbbell_shoulder_press', 'arnold_press', 'lateral_raises', 'upright_row'
        ]
      },
      'Advanced': {
        'exercises': [
          'back_squat', 'romanian_deadlift', 'leg_press', 'standing_calf_raise',
          'dumbbell_shoulder_press', 'arnold_press', 'lateral_raises', 'upright_row', 'front_raise'
        ]
      }
    },
    'Thursday': {
      'Beginner': {
        'exercises': [
          'dumbbell_chest_press', 'machine_chest_fly', 'close_grip_bench_press', 'tricep_dips'
        ]
      },
      'Intermediate': {
        'exercises': [
          'incline_machine_press', 'dumbbell_pullover', 'cable_crossovers',
          'close_grip_bench_press', 'tricep_kickbacks', 'tricep_dips'
        ]
      },
      'Advanced': {
        'exercises': [
          'incline_barbell_press', 'dumbbell_chest_press', 'pec_deck',
          'tricep_dips', 'skull_crushers', 'tricep_kickbacks', 'overhead_cable_extension'
        ]
      }
    },
    'Friday': {
      'Beginner': {
        'exercises': [
          'tbar_row', 'dumbbell_row', 'barbell_curl', 'concentration_curl'
        ]
      },
      'Intermediate': {
        'exercises': [
          'tbar_row', 'lat_pulldown', 'dumbbell_row',
          'cable_curl', 'zottman_curl', 'concentration_curl'
        ]
      },
      'Advanced': {
        'exercises': [
          'tbar_row', 'dumbbell_row', 'lat_pulldown', 'machine_row',
          'barbell_curl', 'hammer_curl', 'zottman_curl', 'spider_curl'
        ]
      }
    },
    'Saturday': {
      'Beginner': {
        'exercises': [
          'leg_press', 'walking_lunges', 'dumbbell_shoulder_press', 'face_pulls', 'upright_row'
        ]
      },
      'Intermediate': {
        'exercises': [
          'front_squat', 'leg_press', 'seated_calf_raise',
          'front_raise', 'face_pulls', 'rear_delt_fly', 'reverse_pec_deck'
        ]
      },
      'Advanced': {
        'exercises': [
          'front_squat', 'leg_curl', 'walking_lunges', 'seated_calf_raise',
          'rear_delt_fly', 'face_pulls', 'cable_rear_fly'
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
      'Beginner': ['squats', 'leg_press', 'leg_extension'],
      'Intermediate': ['squats', 'leg_press', 'leg_curl', 'leg_extension'],
      'Advanced': ['squats', 'front_squat', 'leg_press', 'romanian_deadlift', 'leg_curl', 'leg_extension'],
    },
  };

  static ExerciseConfig getExerciseConfig(String exerciseId, String difficulty) {
    // Base sets and reps by difficulty
    int sets = difficulty == 'Beginner' ? 3 : difficulty == 'Intermediate' ? 4 : 5;
    int reps = difficulty == 'Beginner' ? 12 : difficulty == 'Intermediate' ? 10 : 8;

    // Exercise-specific calorie mappings
    final Map<String, Map<String, int>> caloriesByExercise = {
      // Chest exercises
      'barbell benchpresss': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'incline_dumbbell_press': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'decline_bench_press': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'dumbbell_pullover': {'Beginner': 20, 'Intermediate': 30, 'Advanced': 30},
      'chest_dips': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'cable_chest_fly': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 30},

      // Back exercises
      'deadlifts': {'Beginner': 50, 'Intermediate': 60, 'Advanced': 70},
      'pullups': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 45},
      'latPulldown': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'dumbbell_row': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'tbar_row': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'seated_cable_row': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'straight_arm_pulldown': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},

      // Biceps exercises
      'barbell_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'preacher_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'hammer_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'concentration_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'incline_dumbbell_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'spider_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'cable_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},

      // Triceps exercises
      'close_grip_bench_press': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'skull_crushers': {'Beginner': 20, 'Intermediate': 30, 'Advanced': 30},
      'overhead_tricep_extension': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'tricep_pushdowns': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'overhead_cable_extension': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'tricep_kickbacks': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},

      // Shoulder exercises
      'barbell_overhead_press': {'Beginner': 25, 'Intermediate': 35, 'Advanced': 40},
      'dumbbell_shoulder_press': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'arnold_press': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'lateral_raises': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 25},
      'front_raise': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'rear_delt_fly': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 25},

      // Legs exercises
      'squats': {'Beginner': 50, 'Intermediate': 60, 'Advanced': 65},
      'front_squat': {'Beginner': 45, 'Intermediate': 55, 'Advanced': 60},
      'leg_press': {'Beginner': 40, 'Intermediate': 45, 'Advanced': 50},
      'romanian_deadlift': {'Beginner': 40, 'Intermediate': 50, 'Advanced': 55},
      'leg_curl': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'leg_extension': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
    };

    // Get calories for the specific exercise and difficulty, or use a default value
    int calories = caloriesByExercise[exerciseId]?[difficulty] ??
        (difficulty == 'Beginner' ? 70 : difficulty == 'Intermediate' ? 95 : 115);

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

  static int getWorkoutDuration(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return 45; // 45-60 mins
      case 'intermediate':
        return 60; // 60-75 mins
      case 'advanced':
        return 75; // 75-90 mins
      default:
        return 45;
    }
  }

  static List<WorkoutExercise> getExercisesForMuscle(String muscleGroup, String difficulty) {
    final List<String> exerciseIdsList = exerciseIds[muscleGroup]?[difficulty] ?? [];
    final List<WorkoutExercise> exercises = [];

    for (final exerciseId in exerciseIdsList) {
      final Exercise exercise = findExercise(muscleGroup, exerciseId);
      final ExerciseConfig config = getExerciseConfig(exerciseId, difficulty);
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
    return getExercisesForPPLWorkout(day, difficulty);
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
      // Chest exercises
      'barbell benchpresss': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'incline_dumbbell_press': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'cable_chest_fly': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'chest_dips': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'dumbbell_chest_press': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'machine_chest_fly': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'pec_deck': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'decline_bench_press': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      
      // Back exercises
      'lat_pulldown': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'seated_cable_row': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'deadlift': {'Beginner': 50, 'Intermediate': 60, 'Advanced': 70},
      'bent_over_row': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'tbar_row': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'pullups': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'dumbbell_row': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'machine_row': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'straight_arm_pulldown': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      
      // Arms exercises
      'barbell_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'preacher_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'hammer_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'concentration_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'incline_dumbbell_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'spider_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'cable_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'zottman_curl': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'close_grip_bench_press': {'Beginner': 30, 'Intermediate': 35, 'Advanced': 40},
      'skull_crushers': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'tricep_pushdowns': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'overhead_cable_extension': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'overhead_tricep_extension': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'tricep_kickbacks': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      
      // Shoulder exercises
      'barbell_overhead_press': {'Beginner': 25, 'Intermediate': 35, 'Advanced': 40},
      'dumbbell_shoulder_press': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'arnold_press': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'lateral_raises': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 25},
      'front_raise': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'rear_delt_fly': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 25},
      'face_pulls': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'upright_row': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'reverse_pec_deck': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'cable_rear_fly': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      
      // Legs exercises
      'squats': {'Beginner': 50, 'Intermediate': 60, 'Advanced': 65},
      'front_squat': {'Beginner': 45, 'Intermediate': 55, 'Advanced': 60},
      'leg_press': {'Beginner': 40, 'Intermediate': 45, 'Advanced': 50},
      'romanian_deadlift': {'Beginner': 40, 'Intermediate': 50, 'Advanced': 55},
      'leg_curl': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'leg_extension': {'Beginner': 25, 'Intermediate': 30, 'Advanced': 35},
      'standing_calf_raise': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'seated_calf_raise': {'Beginner': 20, 'Intermediate': 25, 'Advanced': 30},
      'walking_lunges': {'Beginner': 35, 'Intermediate': 40, 'Advanced': 45},
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
