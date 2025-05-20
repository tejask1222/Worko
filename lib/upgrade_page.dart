import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UpgradePage extends StatelessWidget {
  const UpgradePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Premium Plans',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose a plan to access advanced workout programs',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF71757F),
                  ),
                ),
                const SizedBox(height: 24),
                _buildPlanCard(
                  context: context,
                  title: 'Beginner Plan - Single Muscle',
                  price: 'Free',
                  features: [
                    'Basic single muscle workouts',
                    'Basic exercise library',
                    'Progress tracking',
                  ],
                  isPremium: false,
                ),
                _buildPlanCard(
                  context: context,
                  title: 'Beginner Plan - PPL',
                  price: 'Free',
                  features: [
                    'Basic PPL workout plans',
                    'Basic form guidance',
                    'Progress tracking',
                  ],
                  isPremium: false,
                ),
                _buildPlanCard(
                  context: context,
                  title: 'Intermediate Plan - Single Muscle',
                  price: '₹149',
                  features: [
                    'Intermediate muscle workouts',
                    'Advanced exercise library',
                    'Detailed progress tracking',
                    'Unlock a special achievement card',
                  ],
                  isPremium: true,
                ),
                _buildPlanCard(
                  context: context,
                  title: 'Intermediate Plan - PPL',
                  price: '₹149',
                  features: [
                    'Intermediate PPL workouts',
                    'Form guidance videos',
                    'Detailed progress tracking',
                    'Unlock a special achievement card',
                  ],
                  isPremium: true,
                ),
                _buildPlanCard(
                  context: context,
                  title: 'Advanced Plan - Single Muscle',
                  price: '₹199',
                  features: [
                    'Advanced muscle workouts',
                    'Premium exercise library',
                    'Advanced progress tracking',
                    'Unlock a special achievement card',
                  ],
                  isPremium: true,
                ),
                _buildPlanCard(
                  context: context,
                  title: 'Advanced Plan - PPL',
                  price: '₹199',
                  features: [
                    'Advanced PPL programs',
                    'Advanced progress tracking',
                    'Professional PPL routines',
                    'Unlock a special achievement card',
                  ],
                  isPremium: true,
                ),
                _buildPlanCard(
                  context: context,
                  title: 'Complete Access',
                  price: '₹599',
                  features: [
                    'Access to all workout plans',
                    'Priority support',
                    'Exclusive achievements',
                    'Unlock a special achievement card',
                  ],
                  isPremium: true,
                  isHighlighted: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard({
    required BuildContext context,
    required String title,
    required String price,
    required List<String> features,
    required bool isPremium,
    bool isHighlighted = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFF4285F4) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? Colors.white : const Color(0xFF1A2138),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price + (isPremium ? '/month' : ''),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isHighlighted ? Colors.white : const Color(0xFF4285F4),
              ),
            ),
            const SizedBox(height: 16),
            ...features.map((feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 20,
                    color: isHighlighted ? Colors.white70 : const Color(0xFF4285F4),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    feature,
                    style: TextStyle(
                      fontSize: 14,
                      color: isHighlighted ? Colors.white70 : const Color(0xFF71757F),
                    ),
                  ),
                ],
              ),
            )).toList(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (!isPremium) {
                    final userId = FirebaseAuth.instance.currentUser?.uid;
                    if (userId != null) {

                      // Show confirmation dialog
                      final shouldAdd = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4285F4).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.fitness_center,
                                  color: Color(0xFF4285F4),
                                  size: 32,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                title.contains('Single Muscle') 
                                  ? '6-day split program targeting one muscle group per day'
                                  : '6-day Push, Pull, Legs split program',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Add this workout plan to your workouts?',
                                style: TextStyle(fontSize: 16),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF4285F4),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              ),
                              child: const Text('Add Workout'),
                            ),
                          ],
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                        ),
                      );

                      if (shouldAdd == true) {
                        try {
                          final planKey = title.contains('Single Muscle') ? 'single_muscle' : 'ppl';
                          final workoutId = title.contains('Single Muscle') ? '5' : '8';
                          
                          if (title.contains('Single Muscle')) {
                            final muscleGroups = ['Chest', 'Back', 'Biceps', 'Triceps', 'Shoulders', 'Legs'];
                            final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
                            
                            for (var i = 0; i < muscleGroups.length; i++) {
                              await FirebaseDatabase.instance.ref('userWorkouts/$userId/${planKey}_${days[i].toLowerCase()}').set({
                                'workoutId': workoutId,
                                'day': days[i],
                                'muscle': muscleGroups[i],
                                'addedAt': DateTime.now().toIso8601String(),
                                'title': '$days[i] - ${muscleGroups[i]}',
                                'type': planKey,
                                'difficulty': 'Beginner',
                                'category': 'Strength'
                              });
                            }
                          } else if (title.contains('PPL')) {
                            final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
                            final types = ['Push', 'Pull', 'Legs', 'Push', 'Pull', 'Legs'];
                            
                            for (var i = 0; i < days.length; i++) {
                              await FirebaseDatabase.instance.ref('userWorkouts/$userId/${planKey}_${days[i].toLowerCase()}').set({
                                'workoutId': workoutId,
                                'day': days[i],
                                'type': types[i],
                                'addedAt': DateTime.now().toIso8601String(),
                                'title': '$days[i] - ${types[i]}',
                                'difficulty': 'Beginner',
                                'category': 'Strength'
                              });
                            }
                          }
                          
                          // Show success message and navigate to workout page
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Workout plan added successfully! Check the workout tab to get started.')),
                            );
                            Navigator.pushNamedAndRemoveUntil(
                              context, 
                              '/home', 
                              (route) => false,
                              arguments: 1, // This will open the Workout tab
                            );
                          }
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Error adding workout plan: ${e.toString()}'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please sign in to add workout plans'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Premium plans coming soon!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isHighlighted ? Colors.white : const Color(0xFF4285F4),
                  foregroundColor: isHighlighted ? const Color(0xFF4285F4) : Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(isPremium ? 'Subscribe Now' : 'Get Started'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}