import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../active_workout_page.dart';
import '../models/workout.dart';

class WorkoutInstructionsService {
  static Future<bool> shouldShowInstructions() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return true;

    final snapshot = await FirebaseDatabase.instance
        .ref('userPreferences/${user.uid}/showWorkoutInstructions')
        .get();

    return snapshot.value == null || snapshot.value == true;
  }

  static Future<void> saveInstructionsPreference(bool show) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseDatabase.instance
        .ref('userPreferences/${user.uid}')
        .update({'showWorkoutInstructions': show});
  }

  static Future<void> showInstructionsDialog({
    required BuildContext context,
    required Workout workout,
  }) async {
    bool showAgain = true;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Workout Instructions'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Click each set one by one and then after completing the exercise click "Complete Exercise" to move to next exercise.\n\nNote: You can click all sets at once after completing the exercise and then click "Complete Exercise".',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Checkbox(
                        value: !showAgain,
                        onChanged: (bool? value) {
                          setState(() {
                            showAgain = !(value ?? false);
                          });
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Don\'t show this message again',
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await saveInstructionsPreference(showAgain);
                if (context.mounted) {
                  Navigator.pop(context); // Close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ActiveWorkoutPage(workout: workout),
                    ),
                  );
                }
              },
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }
}
