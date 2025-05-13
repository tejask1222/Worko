import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'models/workout.dart';
import 'workout_detail_page.dart';
import 'models/workout_templates.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'pages/single_muscle_selection_page.dart';
import 'pages/workouts/full_body_workout_page.dart';
import 'pages/workouts/upper_body_workout_page.dart';
import 'pages/workouts/lower_body_workout_page.dart';
import 'pages/workouts/core_workout_page.dart';
import 'pages/workouts/single_muscle_split_page.dart';
import 'pages/ppl_day_selection_page.dart';

class WorkoutPage extends StatefulWidget {
  static const String routeName = '/workout';

  const WorkoutPage({Key? key}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<String> _categories = [
    'All',
    'Strength',
    'Cardio',
    'Core',
    'Flexibility'
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Workout> get filteredWorkouts {
    var workouts = WorkoutTemplates.allWorkouts;

    return workouts.where((workout) {
      final matchesSearch = workout.title.toLowerCase().contains(_searchQuery) ||
          workout.description.toLowerCase().contains(_searchQuery);
      final matchesCategory = _selectedCategory == 'All' || 
          workout.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Workouts',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _categories.map((category) => 
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(category),
                            selected: _selectedCategory == category,
                            onSelected: (selected) {
                              setState(() {
                                _selectedCategory = category;
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: const Color(0xFF4285F4),
                            labelStyle: TextStyle(
                              color: _selectedCategory == category 
                                ? Colors.white 
                                : Colors.black87,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: filteredWorkouts.isEmpty
                ? Center(
                    child: Text(
                      'No match found',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredWorkouts.length,
                    itemBuilder: (context, index) {
                      final workout = filteredWorkouts[index];
                      return WorkoutCard(workout: workout);
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class WorkoutCard extends StatelessWidget {
  final Workout workout;

  const WorkoutCard({
    Key? key,
    required this.workout,
  }) : super(key: key);

  // Get duration from workout's customDuration or calculate from exercises
  int get estimatedDuration {
    return workout.duration;  // This will use the Workout class's duration getter which handles customDuration
  }

  // Get calories, either custom value or calculated from exercises
  int get totalCalories {
    return workout.calories;  // This will use the Workout class's calories getter which handles customCalories
  }

  Future<File> _getImageFile(String assetPath) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/${assetPath.split('/').last}');

    if (!await file.exists()) {
      // If file doesn't exist in cache, copy it from assets
      final byteData = await rootBundle.load(assetPath);
      final buffer = byteData.buffer;
      await file.writeAsBytes(
        buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes)
      );
    }
    return file;
  }

  void _addToHomepage(BuildContext context) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      debugPrint('No user logged in');
      return;
    }

    final userHomepageRef = FirebaseDatabase.instance.ref('userHomepage/$userId');
    final snapshot = await userHomepageRef.child(workout.id).get();
    
    if (!snapshot.exists) {
      debugPrint('Adding workout to homepage: ${workout.id}');
      // Store workout data
      await userHomepageRef.push().set({
        'workoutId': workout.id,
        'addedAt': DateTime.now().toIso8601String(),
        'title': workout.title,
        'category': workout.category
      });
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${workout.title} added to homepage'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${workout.title} is already on homepage'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSingleMuscleWorkout = workout.id.startsWith('5') || workout.id.startsWith('6') || workout.id.startsWith('7');
    bool isPPLWorkout = workout.id.startsWith('8') || workout.id.startsWith('9') || workout.id.startsWith('10');
    
    return GestureDetector(
      onTap: () {
        switch (workout.id) {
          case '1': // Full Body Workout
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FullBodyWorkoutPage(
                  difficulty: workout.difficulty,
                ),
              ),
            );
            break;
          case '2': // Upper Body Workout
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpperBodyWorkoutPage(
                  difficulty: workout.difficulty,
                ),
              ),
            );
            break;
          case '3': // Lower Body Workout
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LowerBodyWorkoutPage(
                  difficulty: workout.difficulty,
                ),
              ),
            );
            break;
          case '4': // Core Workout
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoreWorkoutPage(
                  difficulty: workout.difficulty,
                ),
              ),
            );
            break;
          case '5': // Beginner Single Muscle
          case '6': // Intermediate Single Muscle
          case '7': // Advanced Single Muscle
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SingleMuscleSelectionPage(
                  difficulty: workout.difficulty,
                ),
              ),
            );
            break;
          case '8': // Beginner PPL
          case '9': // Intermediate PPL
          case '10': // Advanced PPL
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PPLDaySelectionPage(
                  difficulty: workout.difficulty,
                ),
              ),
            );
            break;
          default:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WorkoutDetailPage(workout: workout),
              ),
            );
        }
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: FutureBuilder<File>(
                      future: _getImageFile(workout.imageUrl),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError || !snapshot.hasData) {
                          return Image.asset(
                            workout.imageUrl,
                            fit: BoxFit.cover,
                          );
                        }
                        return Image.file(
                          snapshot.data!,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () => _addToHomepage(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.home_outlined,
                          size: 20,
                          color: Colors.blue[600],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    workout.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${workout.exercises.length} exercises',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 16, color: Colors.blue[600]),
                      const SizedBox(width: 4),
                      Text(
                        (isSingleMuscleWorkout || isPPLWorkout)
                          ? '${workout.duration} min'
                          : '$estimatedDuration min',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.local_fire_department_outlined, 
                           size: 16, 
                           color: Colors.orange[600]),
                      const SizedBox(width: 4),
                      Text(
                        '$totalCalories cal',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          workout.difficulty,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (isSingleMuscleWorkout || isPPLWorkout) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => isPPLWorkout
                                ? PPLDaySelectionPage(difficulty: workout.difficulty)
                                : SingleMuscleSelectionPage(difficulty: workout.difficulty),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WorkoutDetailPage(workout: workout),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4285F4),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text((isSingleMuscleWorkout || isPPLWorkout) ? 'Choose Day' : 'Start Workout'),
                  ),
                ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}