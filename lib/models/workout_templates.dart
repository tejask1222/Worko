import 'workout.dart';
import '../services/exercise_library_service.dart';
import '../services/exercise_service.dart';

class WorkoutTemplates {
  static Exercise _findExercise(String muscleGroup, String exerciseId) {
    final exercises = ExerciseLibraryService.getExercisesByMuscleGroup(muscleGroup);
    return exercises.firstWhere(
      (e) => e.id == exerciseId,
      orElse: () => exercises.first,
    );
  }

  static final Workout fullBodyWorkout = Workout(
    id: '1',
    title: 'Full Body Workout',
    description: 'Complete full body workout targeting all major muscle groups',
    category: 'Strength',
    difficulty: 'Beginner',
    imageUrl: 'assets/images/workouts/full_body.jpg',
    exercises: ExerciseLibraryService.getDefaultWorkoutExercises('Full Body'),
    addedAt: DateTime.now(),
  );

  static final Workout upperBodyWorkout = Workout(
    id: '2',
    title: 'Upper Body Blast',
    description: 'Intense upper body workout focusing on chest, back, and arms',
    category: 'Strength',
    difficulty: 'Intermediate',
    imageUrl: 'assets/images/workouts/upper_body.jpg',
    exercises: ExerciseLibraryService.getDefaultWorkoutExercises('Upper Body'),
    addedAt: DateTime.now(),
  );

  static final Workout lowerBodyWorkout = Workout(
    id: '3',
    title: 'Lower Body Focus',
    description: 'Leg-focused workout to build strength and stability',
    category: 'Strength',
    difficulty: 'Beginner',
    imageUrl: 'assets/images/workouts/lower_body.jpg',
    exercises: [
      _findExercise('Legs', 'squats'),
      _findExercise('Legs', 'front_squat'),
      _findExercise('Legs', 'leg_press'),
      _findExercise('Legs', 'romanian_deadlift'),
      _findExercise('Legs', 'leg_curl'),
      _findExercise('Legs', 'leg_extension'),
    ].map((e) => WorkoutExercise(
      exercise: e,
      config: ExerciseConfig(
        sets: 3,
        reps: 12,
        calories: 50,
      ),
    )).toList(),
    addedAt: DateTime.now(),
  );

  static final Workout coreWorkout = Workout(
    id: '4',
    title: 'Core Crusher',
    description: 'Core-focused workout for a stronger midsection',
    category: 'Core',
    difficulty: 'Intermediate',
    imageUrl: 'assets/images/workouts/core.jpg',
    exercises: ExerciseLibraryService.getDefaultWorkoutExercises('Core'),
    addedAt: DateTime.now(),
  );

  static final Workout beginnerSingleMuscleWorkout = Workout(
    id: '5',
    title: 'Beginner Single Muscle Split',
    description: 'A 6-day split targeting one muscle group per day with basic exercises',
    category: 'Strength',
    difficulty: 'Beginner',
    imageUrl: 'assets/images/workouts/beginner_single_muscle.jpg',
    customDuration: 120, // 120 minutes
    customCalories: 900, // 900 calories
    exercises: ExerciseService.getExercisesForMuscle('Chest', 'Beginner'),
    addedAt: DateTime.now(),
  );

  static final Workout intermediateSingleMuscleWorkout = Workout(
    id: '6',
    title: 'Intermediate Single Muscle Split',
    description: 'A 6-day split with moderate intensity exercises for each muscle group',
    category: 'Strength',
    difficulty: 'Intermediate',
    imageUrl: 'assets/images/workouts/intermediate_single_muscle.jpg',
    customDuration: 180, // 180 minutes
    customCalories: 1680, // 1680 calories
    exercises: ExerciseService.getExercisesForMuscle('Chest', 'Intermediate'),
    addedAt: DateTime.now(),
  );

  static final Workout advancedSingleMuscleWorkout = Workout(
    id: '7',
    title: 'Advanced Single Muscle Split',
    description: 'An intense 6-day split with challenging exercises for each muscle group',
    category: 'Strength',
    difficulty: 'Advanced',
    imageUrl: 'assets/images/workouts/advanced_single_muscle.jpg',
    customDuration: 360, // 360 minutes
    customCalories: 3240, // 3240 calories
    exercises: ExerciseService.getExercisesForMuscle('Chest', 'Advanced'),
    addedAt: DateTime.now(),
  );

  // PPL workouts will use ExerciseService to get their exercises based on muscle groups and difficulty

  static final Workout beginnerPPLWorkout = Workout(
    id: '8',
    title: 'Beginner PPL Split',
    description: 'A 3-day Push Pull Legs split perfect for beginners',
    category: 'Strength',
    difficulty: 'Beginner',
    imageUrl: 'assets/images/workouts/beginner_ppl.jpg',
    customDuration: 160, // 160 minutes
    customCalories: 950, // 950 calories
    exercises: ExerciseService.getPPLExercises('Push', 'Beginner'),
    addedAt: DateTime.now(),
  );

  static final Workout intermediatePPLWorkout = Workout(
    id: '9',
    title: 'Intermediate PPL Split',
    description: 'A comprehensive 3-day Push Pull Legs split with increased volume',
    category: 'Strength',
    difficulty: 'Intermediate',
    imageUrl: 'assets/images/workouts/intermediate_ppl.jpg',
    customDuration: 300, // 300 minutes
    customCalories: 1650, // 1650 calories
    exercises: ExerciseService.getPPLExercises('Push', 'Intermediate'),
    addedAt: DateTime.now(),
  );

  static final Workout advancedPPLWorkout = Workout(
    id: '10',
    title: 'Advanced PPL Split',
    description: 'An intense 3-day Push Pull Legs split with high volume and compound movements',
    category: 'Strength',
    difficulty: 'Advanced',
    imageUrl: 'assets/images/workouts/advanced_ppl.jpg',
    customDuration: 450, // 450 minutes
    customCalories: 2430, // 2430 calories
    exercises: ExerciseService.getPPLExercises('Push', 'Advanced'),
    addedAt: DateTime.now(),
  );

  static final List<Workout> allWorkouts = [
    fullBodyWorkout,
    upperBodyWorkout,
    lowerBodyWorkout,
    coreWorkout,
    beginnerSingleMuscleWorkout,
    intermediateSingleMuscleWorkout,
    advancedSingleMuscleWorkout,
    beginnerPPLWorkout,
    intermediatePPLWorkout,
    advancedPPLWorkout,
  ];

  static List<Workout> getWorkoutsByCategory(String category) {
    return allWorkouts.where((workout) => workout.category == category).toList();
  }

  static List<Workout> getWorkoutsByDifficulty(String difficulty) {
    return allWorkouts.where((workout) => workout.difficulty == difficulty).toList();
  }
}