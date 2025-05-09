import '../models/workout.dart';

class ExerciseLibraryService {
  static final Map<String, List<Exercise>> _exercises = {
    'Chest': [
      Exercise(
        name: 'Push-ups',
        description: 'A compound exercise that targets your chest, shoulders, and triceps',
        targetMuscles: 'Chest, Shoulders, Triceps',
        imageUrl: 'assets/images/workouts/pushup.jpg',
      ),
    ],
    'Legs': [
      Exercise(
        name: 'Squats',
        description: 'A foundational lower body exercise that builds strength and stability',
        targetMuscles: 'Quadriceps, Hamstrings, Glutes',
        imageUrl: 'assets/images/workouts/squat.jpg',
      ),
    ],
    'Back': [
      Exercise(
        name: 'Pull-ups',
        description: 'An upper body exercise that targets your back and biceps',
        targetMuscles: 'Back, Biceps',
        imageUrl: 'assets/images/workouts/pullup.jpg',
      ),
    ],
    'Core': [
      Exercise(
        name: 'Plank',
        description: 'An isometric core exercise that builds stability and endurance',
        targetMuscles: 'Core, Shoulders',
        imageUrl: 'assets/images/workouts/plank.jpg',
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
    
    switch (workoutType) {
      case 'Full Body':
        return [
          _exercises['Chest']![0],
          _exercises['Legs']![0],
          _exercises['Back']![0],
          _exercises['Core']![0],
        ].map((e) => WorkoutExercise(exercise: e, config: defaultConfig)).toList();
      
      case 'Upper Body':
        return [
          _exercises['Chest']![0],
          _exercises['Back']![0],
        ].map((e) => WorkoutExercise(exercise: e, config: defaultConfig)).toList();
      
      case 'Lower Body':
        return [
          _exercises['Legs']![0],
          _exercises['Core']![0],
        ].map((e) => WorkoutExercise(exercise: e, config: defaultConfig)).toList();
      
      case 'Core':
        return [
          _exercises['Core']![0],
        ].map((e) => WorkoutExercise(exercise: e, config: defaultConfig)).toList();
      
      default:
        return [];
    }
  }
}
