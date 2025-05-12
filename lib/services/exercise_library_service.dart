import '../models/workout.dart';

class ExerciseLibraryService {  static final Map<String, List<Exercise>> _exercises = {
    'Chest': [
      Exercise(
        id: 'pushups',
        name: 'Push-ups',
        description: 'A compound exercise that targets your chest, shoulders, and triceps',
        targetMuscles: 'Chest, Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/pushup.jpg',
      ),
      Exercise(
        id: 'benchpress',
        name: 'Bench Press',
        description: 'A fundamental chest exercise that builds upper body strength',
        targetMuscles: 'Chest, Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/benchpress.jpg',
      ),
      Exercise(
        id: 'bench_press',
        name: 'Bench Press',
        description: 'A fundamental chest exercise that builds upper body strength',
        targetMuscles: 'Chest, Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/bench_press.jpg',
      ),
      Exercise(
        id: 'dumbbell_bench_press',
        name: 'Dumbbell Bench Press',
        description: 'A fundamental chest exercise that builds upper body strength',
        targetMuscles: 'Chest, Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/dumbbell_bench_press.jpg',
      ),
      Exercise(
        id: 'dips',
        name: 'Dips',
        description: 'A bodyweight exercise that targets chest and triceps',
        targetMuscles: 'Chest, Triceps',
        imageUrl: 'assets/images/workouts/dips.jpeg',
      ),      Exercise(
        id: "barbell benchpresss",
        name: "Barbell Bench Press",
        description: "A compound weightlifting exercise that primarily targets the chest, shoulders, and triceps.",
        targetMuscles: "Chest, Shoulders, Triceps",
        imageUrl: 'assets/images/workouts/barbell_benchpress.jpg',
      ),
      Exercise(
        id: "incline_dumbbell_press",
        name: "Incline Dumbbell Press",
        description: "An upper chest focused exercise that targets the clavicular head of the pectoralis major",
        targetMuscles: "Chest, Shoulders, Triceps",
        imageUrl: 'assets/images/workouts/incline_dumbbell_press.jpg',
      ),
      Exercise(
        id: "cable_chest_fly",
        name: "Cable Chest Fly",
        description: "An isolation exercise that targets the chest muscles through horizontal adduction",
        targetMuscles: "Chest",
        imageUrl: 'assets/images/workouts/cable_chest_fly.jpg',
      ),
      Exercise(
        id: "dumbbell_pullover",
        name: "Dumbbell Pullover",
        description: "A compound exercise that targets both the chest and lats through a large range of motion",
        targetMuscles: "Chest, Back",
        imageUrl: 'assets/images/workouts/dumbbell_pullover.jpeg',
      ),
      Exercise(
        id: 'decline_bench_press',
        name: 'Decline Bench Press',
        description: 'A bench press variation that targets the lower chest',
        targetMuscles: 'Chest, Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/decline_bench_press.jpeg',
      ),
      Exercise(
        id: 'chest_dips',
        name: 'Chest Dips',
        description: 'A bodyweight exercise emphasizing the lower chest with a forward lean',
        targetMuscles: 'Chest, Triceps, Shoulders',
        imageUrl: 'assets/images/workouts/chest_dips.jpg',
      ),
      Exercise(
        id: 'flat_barbell_bench',
        name: 'Flat Barbell Bench Press',
        description: 'The classic compound chest exercise for building strength and mass',
        targetMuscles: 'Chest, Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/flat_barbell_bench.jpg',
      ),
      Exercise(
        id: 'incline_machine_press',
        name: 'Incline Machine Press',
        description: 'A machine-based chest press that targets the upper chest',
        targetMuscles: 'Chest, Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/incline_machine_press.jpg',
      ),
      Exercise(
        id: 'pec_deck',
        name: 'Pec Deck Machine',
        description: 'An isolation exercise that focuses on chest contraction',
        targetMuscles: 'Chest',
        imageUrl: 'assets/images/workouts/pec_deck.jpg',
      ),
      Exercise(
        id: 'cable_crossovers',
        name: 'Cable Crossovers',
        description: 'A cable exercise that provides constant tension through the chest',
        targetMuscles: 'Chest',
        imageUrl: 'assets/images/workouts/cable_crossovers.jpg',
      ),
      Exercise(
        id: 'dumbbell_chest_press',
        name: 'Dumbbell Chest Press',
        description: 'A dumbbell variation of the bench press for balanced development',
        targetMuscles: 'Chest, Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/dumbbell_chest_press.jpg',
      ),
      Exercise(
        id: 'machine_chest_fly',
        name: 'Machine Chest Fly',
        description: 'A machine-based isolation exercise for the chest muscles',
        targetMuscles: 'Chest',
        imageUrl: 'assets/images/workouts/machine_chest_fly.jpg',
      ),
      Exercise(
        id: 'incline_barbell_press',
        name: 'Incline Barbell Press',
        description: 'A compound exercise targeting the upper chest',
        targetMuscles: 'Chest, Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/incline_barbell_press.jpg',
      ),
      Exercise(
        id: 'incline_bench_press',
        name: 'Incline Bench Press',
        description: 'A compound exercise targeting the upper chest',
        targetMuscles: 'Chest, Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/incline_bench_press.jpg',
      ),
      Exercise(
        id: 'reverse_pec_deck',
        name: 'Reverse Pec Deck',
        description: 'A machine exercise targeting the rear deltoids and upper back',
        targetMuscles: 'Shoulders, Back',
        imageUrl: 'assets/images/workouts/reverse_pec_deck.jpg',
      ),
    ],    'Legs': [
      Exercise(
        id: 'squats',
        name: 'Squats',
        description: 'A foundational lower body exercise that builds strength and stability',
        targetMuscles: 'Quadriceps, Hamstrings, Glutes',
        imageUrl: 'assets/images/workouts/squat.jpg',
      ),
      Exercise(
        id: 'bulgarian_split_squat',
        name: 'Bulgarian Split Squats',
        description: 'A a foundational unilateral lower body exercise that builds strength, balance, and stability, primarily targeting the quads, glutes, and hamstrings.',
        targetMuscles: 'Quadriceps, Hamstrings, Glutes',
        imageUrl: 'assets/images/workouts/bulgarian_split_squat.jpg',
      ),
      Exercise(
        id: 'back_squat',
        name: 'Back Squat',
        description: 'A barbell squat with the weight resting on upper back, targeting full lower body development',
        targetMuscles: 'Quadriceps, Hamstrings, Glutes, Core',
        imageUrl: 'assets/images/workouts/back_squat.jpg',
      ),
      Exercise(
        id: 'front_squat',
        name: 'Front Squat',
        description: 'A squat variation that emphasizes the quadriceps and core stability',
        targetMuscles: 'Quadriceps, Core',
        imageUrl: 'assets/images/workouts/front_squat.jpg',
      ),
      Exercise(
        id: 'leg_press',
        name: 'Leg Press',
        description: 'A machine compound exercise for lower body development',
        targetMuscles: 'Quadriceps, Hamstrings, Glutes',
        imageUrl: 'assets/images/workouts/leg_press.jpg',
      ),
      Exercise(
        id: 'leg_extension',
        name: 'Leg Extension',
        description: 'A isolation exercise primarily targeting the quadriceps muscles of the front thigh',
        targetMuscles: 'Quadriceps, Hamstrings, Glutes',
        imageUrl: 'assets/images/workouts/leg_extension.jpg',
      ),
      Exercise(
        id: 'romanian_deadlift',
        name: 'Romanian Deadlift',
        description: 'A hip-hinge movement that targets the posterior chain',
        targetMuscles: 'Hamstrings, Lower Back, Glutes',
        imageUrl: 'assets/images/workouts/romanian_deadlift.jpg',
      ),
      Exercise(
        id: 'lunges',
        name: 'Lunges',
        description: 'A unilateral leg exercise that improves balance and strength',
        targetMuscles: 'Quadriceps, Hamstrings, Glutes',
        imageUrl: 'assets/images/workouts/lunges.jpg',
      ),
      Exercise(
        id: 'calfRaises',
        name: 'Calf Raises',
        description: 'An isolation exercise for developing calf muscles',
        targetMuscles: 'Calves',
        imageUrl: 'assets/images/workouts/calfraises.jpg',
      ),
      Exercise(
        id: 'leg_curl',
        name: 'Leg Curl',
        description: 'An isolation exercise targeting the hamstring muscles',
        targetMuscles: 'Hamstrings',
        imageUrl: 'assets/images/workouts/leg_curl.jpeg',
      ),      Exercise(
        id: 'walking_lunges',
        name: 'Walking Lunges',
        description: 'A dynamic leg exercise targeting multiple muscle groups',
        targetMuscles: 'Quadriceps, Glutes, Hamstrings',
        imageUrl: 'assets/images/workouts/walking_lunges.jpg',
      ),
      Exercise(
        id: 'seated_calf_raise',
        name: 'Seated Calf Raise',
        description: 'An isolation exercise for calf development',
        targetMuscles: 'Calves',
        imageUrl: 'assets/images/workouts/seated_calf_raise.jpg',
      ),
      Exercise(
        id: 'standing_calf_raise',
        name: 'Standing Calf Raise',
        description: 'A standing variation of calf raise that targets the gastrocnemius muscle',
        targetMuscles: 'Calves',
        imageUrl: 'assets/images/workouts/standing_calf_raise.jpg',
      ),
      Exercise(
        id: 'hack_squat',
        name: 'Hack Squat',
        description: 'A machine-based squat variation',
        targetMuscles: 'Quadriceps, Glutes',
        imageUrl: 'assets/images/workouts/hack_squat.jpg',
      ),
    ],
    'Back': [
      Exercise(
        id: 'pullups',
        name: 'Pull-ups',
        description: 'An upper body exercise that targets your back and biceps',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/pullup.jpg',
      ),
      Exercise(
        id: 'pull_ups',
        name: 'Pull-ups',
        description: 'An upper body exercise that targets your back and biceps',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/pullups.jpg',
      ),
      Exercise(
        id: 'rows',
        name: 'Rows',
        description: 'A compound pulling exercise that targets the back muscles',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/rows.jpg',
      ),      Exercise(
        id: 'latPulldown',
        name: 'Lat Pulldown',
        description: 'A machine exercise that targets the latissimus dorsi',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/latpulldown.jpg',
      ),
      Exercise(
        id: 'dumbbell_row',
        name: 'Dumbbell Row',
        description: 'A unilateral back exercise that targets the latissimus dorsi and rhomboids',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/dumbbell_row.jpg',
      ),
      Exercise(
        id: 'seated_cable_row',
        name: 'Seated Cable Row',
        description: 'A compound pulling exercise that targets the entire back musculature',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/seated_cable_row.jpg',
      ),
      Exercise(
        id: 'deadlifts',
        name: 'Deadlifts',
        description: 'A compound exercise that targets the entire posterior chain',
        targetMuscles: 'Back, Legs, Core',
        imageUrl: 'assets/images/workouts/deadlifts.jpg',
      ),
      Exercise(
        id: 'tbar_row',
        name: 'T-Bar Row',
        description: 'A compound rowing movement that emphasizes mid-back development',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/tbar_row.jpeg',
      ),
      Exercise(
        id: 'straight_arm_pulldown',
        name: 'Straight-arm Pulldown',
        description: 'An isolation exercise that targets the lats while keeping the arms straight',
        targetMuscles: 'Back',
        imageUrl: 'assets/images/workouts/straight_arm_pulldown.jpeg',
      ),
      Exercise(
        id: 'tbar_row',
        name: 'T-Bar Row',
        description: 'A compound exercise targeting the entire back',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/tbar_row.jpg',
      ),
      Exercise(
        id: 'machine_row',
        name: 'Machine Row',
        description: 'A machine-based back exercise for controlled movement',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/machine_row.jpg',
      ),
      Exercise(
        id: 'lat_pulldown',
        name: 'Lat Pulldown',
        description: 'A machine exercise targeting the latissimus dorsi',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/lat_pulldown.jpg',
      ),
      Exercise(
        id: 'seated_cable_row',
        name: 'Seated Cable Row',
        description: 'A cable exercise for back thickness and width',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/seated_cable_row.jpg',
      ),
      Exercise(
        id: 'chest_supported_row',
        name: 'Chest Supported Row',
        description: 'A back exercise with upper body support for strict form',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/chest_supported_row.jpg',
      ),
      Exercise(
        id: 'meadows_row',
        name: 'Meadows Row',
        description: 'A unilateral back exercise for targeting each side independently',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/meadows_row.jpg',
      ),
    ],
    'Core': [
      Exercise(
        id: 'plank',
        name: 'Plank',
        description: 'An isometric core exercise that builds stability and endurance',
        targetMuscles: 'Core, Shoulders',
        imageUrl: 'assets/images/workouts/plank.jpg',
      ),
      Exercise(
        id: 'crunches',
        name: 'Crunches',
        description: 'A basic abdominal exercise targeting the rectus abdominis',
        targetMuscles: 'Core',
        imageUrl: 'assets/images/workouts/crunches.jpg',
      ),
      Exercise(
        id: 'russianTwists',
        name: 'Russian Twists',
        description: 'A rotational exercise that targets the obliques',
        targetMuscles: 'Core, Obliques',
        imageUrl: 'assets/images/workouts/russiantwists.jpg',
      ),
      Exercise(
        id: 'hanging_leg_raise',
        name: 'Hanging Leg Raise',
        description: 'An advanced core exercise targeting lower abs',
        targetMuscles: 'Core, Hip Flexors',
        imageUrl: 'assets/images/workouts/hanging_leg_raise.jpg',
      ),
      Exercise(
        id: 'cable_woodchop',
        name: 'Cable Woodchop',
        description: 'A rotational core exercise using cable machine',
        targetMuscles: 'Core, Obliques',
        imageUrl: 'assets/images/workouts/cable_woodchop.jpg',
      ),
      Exercise(
        id: 'ab_wheel_rollout',
        name: 'Ab Wheel Rollout',
        description: 'A challenging core stability exercise',
        targetMuscles: 'Core, Shoulders',
        imageUrl: 'assets/images/workouts/ab_wheel_rollout.jpg',
      ),
      Exercise(
        id: 'dragon_flag',
        name: 'Dragon Flag',
        description: 'An advanced core control exercise',
        targetMuscles: 'Core, Lower Back',
        imageUrl: 'assets/images/workouts/dragon_flag.jpg',
      ),
      Exercise(
        id: 'pallof_press',
        name: 'Pallof Press',
        description: 'An anti-rotation core exercise',
        targetMuscles: 'Core, Obliques',
        imageUrl: 'assets/images/workouts/pallof_press.jpg',
      ),
    ],
    'Shoulders': [
      Exercise(        id: 'barbell_overhead_press',
        name: 'Barbell Overhead Press',
        description: 'A compound exercise for developing shoulder strength',
        targetMuscles: 'Shoulders',
        imageUrl: 'assets/images/workouts/barbell_overhead_press.jpg',
      ),      Exercise(
        id: 'lateralRaises',
        name: 'Lateral Raises',
        description: 'An isolation exercise targeting the lateral deltoids',
        targetMuscles: 'Shoulders',
        imageUrl: 'assets/images/workouts/lateralraises.jpg',
      ),
      Exercise(
        id: 'dumbbell_shoulder_press',
        name: 'Dumbbell Shoulder Press',
        description: 'A compound movement for overall shoulder development with dumbbells',
        targetMuscles: 'Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/dumbbell_shoulder_press.jpg',
      ),
      Exercise(
        id: 'rear_delt_fly',
        name: 'Rear Delt Fly',
        description: 'An isolation exercise targeting the posterior deltoids',
        targetMuscles: 'Shoulders',
        imageUrl: 'assets/images/workouts/rear_delt_fly.jpeg',
      ),
      Exercise(
        id: 'arnold_press',
        name: 'Arnold Press',
        description: 'A shoulder press variation that incorporates rotation for complete deltoid development',
        targetMuscles: 'Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/arnold_press.jpeg',
      ),
      Exercise(
        id: 'front_raise',
        name: 'Front Raise',
        description: 'An isolation exercise targeting the anterior deltoids',
        targetMuscles: 'Shoulders',
        imageUrl: 'assets/images/workouts/front_raise.jpeg',
      ),
      Exercise(
        id: 'face_pulls',
        name: 'Face Pulls',
        description: 'An exercise targeting rear deltoids and rotator cuff',
        targetMuscles: 'Shoulders, Upper Back',
        imageUrl: 'assets/images/workouts/face_pulls.jpg',
      ),
      Exercise(
        id: 'upright_row',
        name: 'Upright Row',
        description: 'A compound exercise for shoulder development',
        targetMuscles: 'Shoulders, Traps',
        imageUrl: 'assets/images/workouts/upright_row.jpg',
      ),
      Exercise(
        id: 'military_press',
        name: 'Military Press',
        description: 'A compound overhead pressing movement',
        targetMuscles: 'Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/military_press.jpg',
      ),
      Exercise(
        id: 'lateral_raises',
        name: 'Lateral Raises',
        description: 'An isolation exercise for lateral deltoids',
        targetMuscles: 'Shoulders',
        imageUrl: 'assets/images/workouts/lateral_raises.jpg',
      ),
      Exercise(
        id: 'bent_over_lateral_raises',
        name: 'Bent Over Lateral Raises',
        description: 'An isolation exercise for rear deltoids',
        targetMuscles: 'Shoulders',
        imageUrl: 'assets/images/workouts/bent_over_lateral_raises.jpg',
      ),
    ],
    'Arms': [
      Exercise(
        id: 'bicepCurls',
        name: 'Bicep Curls',
        description: 'An isolation exercise for bicep development',
        targetMuscles: 'Biceps',
        imageUrl: 'assets/images/workouts/bicepcurls.jpg',
      ),
      Exercise(
        id: 'barbell_curl',
        name: 'Barbell Curl',
        description: 'A compound exercise that allows for heavy loading of the biceps',
        targetMuscles: 'Biceps, Forearms',
        imageUrl: 'assets/images/workouts/barbell_curl.jpg',
      ),
      Exercise(
        id: 'hammer_curl',
        name: 'Hammer Curl',
        description: 'A bicep variation that emphasizes the brachialis and forearm development',
        targetMuscles: 'Biceps, Forearms',
        imageUrl: 'assets/images/workouts/hammer_curl.jpeg',
      ),
      Exercise(
        id: 'concentration_curl',
        name: 'Concentration Curl',
        description: 'An isolation exercise that maximizes bicep peak contraction',
        targetMuscles: 'Biceps',
        imageUrl: 'assets/images/workouts/concentration_curl.jpeg',
      ),
      Exercise(
        id: 'tricepExtensions',
        name: 'Tricep Extensions',
        description: 'An isolation exercise targeting the triceps',
        targetMuscles: 'Triceps',
        imageUrl: 'assets/images/workouts/tricepextensions.jpg',
      ),
      Exercise(
        id: 'skull_crushers',
        name: 'Skull Crushers',
        description: 'A lying tricep extension exercise that effectively targets all three heads of the triceps',
        targetMuscles: 'Triceps',
        imageUrl: 'assets/images/workouts/skull_crushers.jpeg',
      ),
      Exercise(
        id: 'tricep_pushdowns',
        name: 'Tricep Pushdowns',
        description: 'A cable exercise that isolates the triceps through downward extension',
        targetMuscles: 'Triceps',
        imageUrl: 'assets/images/workouts/tricep_pushdowns.jpeg',
      ),
      Exercise(
        id: 'preacher_curl',
        name: 'Preacher Curl',
        description: 'An isolation exercise for biceps that eliminates body momentum',
        targetMuscles: 'Biceps',
        imageUrl: 'assets/images/workouts/preacher_curl.jpeg',
      ),
      Exercise(
        id: 'incline_dumbbell_curl',
        name: 'Incline Dumbbell Curl',
        description: 'A bicep exercise performed on an incline bench for increased stretch',
        targetMuscles: 'Biceps',
        imageUrl: 'assets/images/workouts/incline_dumbbell_curl.jpeg',
      ),
      Exercise(
        id: 'spider_curl',
        name: 'Spider Curl',
        description: 'A bicep isolation exercise performed lying face down on an incline bench',
        targetMuscles: 'Biceps',
        imageUrl: 'assets/images/workouts/spider_curl.jpeg',
      ),
      Exercise(
        id: 'cable_curl',
        name: 'Cable Curl',
        description: 'A bicep exercise using cables for constant tension',
        targetMuscles: 'Biceps',
        imageUrl: 'assets/images/workouts/cable_curl.jpeg',
      ),
      Exercise(
        id: 'close_grip_bench_press',
        name: 'Close-grip Bench Press',
        description: 'A compound exercise that emphasizes tricep development',
        targetMuscles: 'Triceps, Chest',
        imageUrl: 'assets/images/workouts/close_grip_bench_press.jpeg',
      ),
      Exercise(
        id: 'overhead_tricep_extension',
        name: 'Overhead Tricep Extension',
        description: 'An overhead movement that emphasizes the long head of the triceps',
        targetMuscles: 'Triceps',
        imageUrl: 'assets/images/workouts/overhead_tricep_extension.jpeg',
      ),
      Exercise(
        id: 'overhead_cable_extension',
        name: 'Overhead Cable Extension',
        description: 'A tricep isolation exercise using cables for constant tension',
        targetMuscles: 'Triceps',
        imageUrl: 'assets/images/workouts/overhead_cable_extension.jpg',
      ),
      Exercise(
        id: 'tricep_kickbacks',
        name: 'Tricep Kickbacks',
        description: 'An isolation movement targeting the triceps through extension',
        targetMuscles: 'Triceps',
        imageUrl: 'assets/images/workouts/tricep_kickbacks.jpg',
      ),
      Exercise(
        id: 'zottman_curl',
        name: 'Zottman Curl',
        description: 'A comprehensive bicep and forearm exercise.',
        targetMuscles: 'Biceps, Forearms',
        imageUrl: 'assets/images/workouts/zottman_curl.jpg',
      ),
    ],
    'Cardio': [
      Exercise(
        id: 'jumpingJacks',
        name: 'Jumping Jacks',
        description: 'A full-body cardio exercise that raises heart rate',
        targetMuscles: 'Full Body',
        imageUrl: 'assets/images/workouts/jumpingjacks.jpg',
      ),
      Exercise(
        id: 'mountainClimbers',
        name: 'Mountain Climbers',
        description: 'A dynamic exercise combining cardio and core engagement',
        targetMuscles: 'Core, Cardio',
        imageUrl: 'assets/images/workouts/mountainclimbers.jpg',
      ),
      Exercise(
        id: 'burpees',
        name: 'Burpees',
        description: 'A high-intensity full body exercise',
        targetMuscles: 'Full Body',
        imageUrl: 'assets/images/workouts/burpees.jpg',
      ),
    ],
    'Compound Exercises': [
      Exercise(
        id: 'deadlift',
        name: 'Deadlift',
        description: 'A fundamental compound exercise for total body strength',
        targetMuscles: 'Back, Legs, Core',
        imageUrl: 'assets/images/workouts/deadlift.jpg',
      ),
      Exercise(
        id: 'power_clean',
        name: 'Power Clean',
        description: 'An explosive Olympic lifting movement',
        targetMuscles: 'Full Body',
        imageUrl: 'assets/images/workouts/power_clean.jpg',
      ),
      Exercise(
        id: 'front_squat',
        name: 'Front Squat',
        description: 'A compound leg exercise with emphasis on quad development',
        targetMuscles: 'Legs, Core',
        imageUrl: 'assets/images/workouts/front_squat.jpg',
      ),
      Exercise(
        id: 'clean_and_press',
        name: 'Clean and Press',
        description: 'A compound Olympic lifting movement',
        targetMuscles: 'Full Body',
        imageUrl: 'assets/images/workouts/clean_and_press.jpg',
      ),
      Exercise(
        id: 'barbell_row',
        name: 'Barbell Row',
        description: 'A compound back exercise',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/barbell_row.jpg',
      ),
    ],
  };

  static List<Exercise> getAllExercises() {
    return _exercises.values.expand((e) => e).toList();
  }

  static List<Exercise> getExercisesByMuscleGroup(String muscleGroup) {
    return _exercises[muscleGroup] ?? [];
  }

  static List<String> getMuscleGroups() {
    return _exercises.keys.toList();
  }
  static List<WorkoutExercise> getDefaultWorkoutExercises(String workoutType) {
    final defaultConfig = ExerciseConfig(sets: 3, reps: 12, calories: 50);
    final cardioConfig = ExerciseConfig(sets: 3, reps: 30, calories: 100);

    switch (workoutType) {
      case 'Full Body':
        return [
          _exercises['Chest']![0], // Push-ups
          _exercises['Legs']![0], // Squats
          _exercises['Back']![1], // Rows
          _exercises['Core']![0], // Plank
          _exercises['Shoulders']![0], // Shoulder Press
          _exercises['Cardio']![0], // Jumping Jacks
        ].map((e) => WorkoutExercise(
          exercise: e, 
          config: e.targetMuscles.contains('Cardio') ? cardioConfig : defaultConfig
        )).toList();
      
      case 'Upper Body':
        return [
          _exercises['Chest']![0], // Push-ups
          _exercises['Back']![0], // Pull-ups
          _exercises['Shoulders']![0], // Shoulder Press
          _exercises['Arms']![0], // Bicep Curls
          _exercises['Arms']![1], // Tricep Extensions
        ].map((e) => WorkoutExercise(exercise: e, config: defaultConfig)).toList();
      
      case 'Lower Body':
        return [
          _exercises['Legs']![0], // Squats
          _exercises['Legs']![1], // Lunges
          _exercises['Legs']![2], // Calf Raises
          _exercises['Core']![0], // Plank
          _exercises['Cardio']![0], // Jumping Jacks
        ].map((e) => WorkoutExercise(
          exercise: e,
          config: e.targetMuscles.contains('Cardio') ? cardioConfig : defaultConfig
        )).toList();
      
      case 'Core':
        return [
          _exercises['Core']![0], // Plank 
          _exercises['Core']![1], // Crunches
          _exercises['Core']![2], // Russian Twists
          _exercises['Cardio']![1], // Mountain Climbers
        ].map((e) => WorkoutExercise(
          exercise: e,
          config: e.targetMuscles.contains('Cardio') ? cardioConfig : defaultConfig
        )).toList();
      
      default:
        return [];
    }
  }
}
