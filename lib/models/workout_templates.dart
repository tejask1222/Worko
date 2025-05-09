import 'workout.dart';
import '../services/exercise_library_service.dart';

class WorkoutTemplates {
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
    exercises: ExerciseLibraryService.getDefaultWorkoutExercises('Lower Body'),
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

  static final List<Workout> allWorkouts = [
    fullBodyWorkout,
    upperBodyWorkout,
    lowerBodyWorkout,
    coreWorkout,
  ];

  static List<Workout> getWorkoutsByCategory(String category) {
    return allWorkouts.where((workout) => workout.category == category).toList();
  }

  static List<Workout> getWorkoutsByDifficulty(String difficulty) {
    return allWorkouts.where((workout) => workout.difficulty == difficulty).toList();
  }
}