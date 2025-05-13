import 'package:workout/services/exercise_service.dart';

class Exercise {
  final String id;
  final String name;
  final String description;
  final String targetMuscles;
  final String imageUrl;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.targetMuscles,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'targetMuscles': targetMuscles,
    'imageUrl': imageUrl,
  };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      targetMuscles: json['targetMuscles'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }
}

class ExerciseConfig {
  final int sets;
  final int reps;
  final int calories;

  const ExerciseConfig({
    required this.sets,
    required this.reps,
    required this.calories,
  });

  Map<String, dynamic> toJson() => {
    'sets': sets,
    'reps': reps,
    'calories': calories,
  };

  factory ExerciseConfig.fromJson(Map<String, dynamic> json) {
    return ExerciseConfig(
      sets: json['sets'] as int,
      reps: json['reps'] as int,
      calories: json['calories'] as int,
    );
  }
}

class WorkoutExercise {
  final Exercise exercise;
  final ExerciseConfig config;

  const WorkoutExercise({
    required this.exercise,
    required this.config,
  });

  String get name => exercise.name;
  String get description => exercise.description;
  String get targetMuscles => exercise.targetMuscles;
  String get imageUrl => exercise.imageUrl;
  int get sets => config.sets;
  int get reps => config.reps;
  int get calories => config.calories;

  Map<String, dynamic> toJson() => {
    'exercise': exercise.toJson(),
    'config': config.toJson(),
  };

  factory WorkoutExercise.fromJson(Map<String, dynamic> json) {
    return WorkoutExercise(
      exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
      config: ExerciseConfig.fromJson(json['config'] as Map<String, dynamic>),
    );
  }
}

class Workout {
  final String id;
  final String title;
  final String description;
  final String category;
  final String imageUrl;
  final String difficulty;
  final List<WorkoutExercise> exercises;
  final DateTime addedAt;
  final int? customDuration;
  final int? customCalories;

  const Workout({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.difficulty,
    required this.exercises,
    required this.addedAt,
    this.customDuration,
    this.customCalories,
  });

  // Get total calories for the workout
  int get calories => customCalories ?? exercises.fold(0, (sum, exercise) => sum + exercise.calories);

  // Get calories per exercise based on customCalories if set
  int getCaloriesPerExercise() {
    if (customCalories != null) {
      return exercises.isEmpty ? 0 : customCalories! ~/ exercises.length;
    }
    return 0;
  }

  // Calculate calories per set for a specific exercise
  int getCaloriesPerSet(int exerciseIndex) {
    if (exerciseIndex < 0 || exerciseIndex >= exercises.length) return 0;
    if (customCalories != null) {
      final caloriesPerExercise = customCalories! ~/ exercises.length;
      return caloriesPerExercise ~/ exercises[exerciseIndex].sets;
    }
    return exercises[exerciseIndex].calories ~/ exercises[exerciseIndex].sets;
  }

  // Use custom duration if provided, otherwise calculate based on sets
  int get duration => customDuration ?? exercises.fold(0, (sum, exercise) => sum + exercise.sets);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'category': category,
    'imageUrl': imageUrl,
    'difficulty': difficulty,
    'exercises': exercises.map((e) => e.toJson()).toList(),
    'addedAt': addedAt.toIso8601String(),
    if (customDuration != null) 'customDuration': customDuration,
    if (customCalories != null) 'customCalories': customCalories,
  };

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String,
      difficulty: json['difficulty'] as String,
      exercises: (json['exercises'] as List)
          .map((e) => WorkoutExercise.fromJson(e as Map<String, dynamic>))
          .toList(),
      addedAt: DateTime.parse(json['addedAt'] as String),
      customDuration: json['customDuration'] as int?,
      customCalories: json['customCalories'] as int?,
    );
  }
}