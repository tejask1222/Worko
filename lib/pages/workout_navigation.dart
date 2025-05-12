import 'package:flutter/material.dart';
import '../models/workout.dart';
import 'workouts/full_body_workout_page.dart';
import 'workouts/upper_body_workout_page.dart';
import 'workouts/lower_body_workout_page.dart';
import 'workouts/core_workout_page.dart';
import 'workouts/single_muscle_split_page.dart';
import '../active_workout_page.dart';

class WorkoutNavigation {
  static void startWorkout(BuildContext context, Workout workout) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveWorkoutPage(workout: workout),
      ),
    );
  }

  static void navigateToWorkout(BuildContext context, String workoutId, String difficulty) {
    switch (workoutId) {
      case '1': // Full Body Workout
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullBodyWorkoutPage(difficulty: difficulty),
          ),
        );
        break;
      case '2': // Upper Body Workout
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UpperBodyWorkoutPage(difficulty: difficulty),
          ),
        );
        break;
      case '3': // Lower Body Workout
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LowerBodyWorkoutPage(difficulty: difficulty),
          ),
        );
        break;
      case '4': // Core Workout
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoreWorkoutPage(difficulty: difficulty),
          ),
        );
        break;
    }
  }
}
