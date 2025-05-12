import 'package:flutter/material.dart';
import '../services/exercise_service.dart';
import '../models/workout.dart';
import '../workout_detail_page.dart';
import '../services/exercise_library_service.dart';

class PPLDaySelectionPage extends StatelessWidget {
  final String difficulty;

  const PPLDaySelectionPage({
    Key? key,
    required this.difficulty,
  }) : super(key: key);

  List<WorkoutExercise> _getExercisesForDay(String day) {
    return ExerciseService.getExercisesForPPLWorkout(day, difficulty);
  }
  @override
  Widget build(BuildContext context) {
    final days = ExerciseService.getPPLDays();

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
          '$difficulty Push Pull Legs',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select Workout Day',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: days.length,
                itemBuilder: (context, index) {
                  final day = days[index];
                  final description = ExerciseService.getPPLDayDescription(day);
                  
                  // Determine the icon based on the day type
                  IconData icon;
                  if (day == 'Monday' || day == 'Thursday') {
                    icon = Icons.fitness_center; // Push
                  } else if (day == 'Tuesday' || day == 'Friday') {
                    icon = Icons.rowing; // Pull
                  } else {
                    icon = Icons.directions_run; // Legs
                  }                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                    child: InkWell(
                      onTap: () {
                        final exercises = _getExercisesForDay(day);
                        final workout = Workout(
                          id: 'ppl_${day.toLowerCase()}_$difficulty',
                          title: '$day - ${description.split(" (")[0]}',
                          description: 'A focused $difficulty workout targeting muscles based on the PPL split',
                          category: 'Strength',
                          difficulty: difficulty,
                          imageUrl: 'assets/images/workouts/ppl_${day.toLowerCase()}.jpg',
                          exercises: exercises,
                          customDuration: ExerciseService.getWorkoutDuration(difficulty),
                          addedAt: DateTime.now(),
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutDetailPage(workout: workout),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue[50],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                icon,
                                color: Colors.blue[600],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    day,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    description,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.grey[400],
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),      ),
    );
  }
}
