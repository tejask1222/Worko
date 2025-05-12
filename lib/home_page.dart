import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'profile_page.dart';
import 'workout_page.dart';
import 'progress_page.dart';
import 'upgrade_page.dart';
import 'settings_page.dart';
import 'workout_detail_page.dart';
import 'providers/avatar_provider.dart';
import 'providers/user_provider.dart';
import 'providers/achievement.dart';
import 'models/workout.dart';
import 'models/workout_templates.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;
  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;
  Map<String, dynamic> _workoutStats = {
    'totalCalories': 0,
    'totalWorkouts': 0,
    'totalDuration': 0,
  };
  Timer? _refreshTimer;
  StreamSubscription? _workoutHistorySubscription;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    
    // Refresh user data when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).refreshUser();
      // Check achievements when loading the home page
      Provider.of<AchievementProvider>(context, listen: false).checkAchievements();
    });
    
    _fetchWorkoutStats();
    _setupAutoRefresh();
    _listenToWorkoutHistory();
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    _workoutHistorySubscription?.cancel();
    super.dispose();
  }

  void _setupAutoRefresh() {
    // Refresh stats every minute
    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      if (mounted) {
        _fetchWorkoutStats();
      }
    });
  }

  void _listenToWorkoutHistory() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      debugPrint('Cannot listen to workout history - no user logged in');
      return;
    }
    
    debugPrint('Setting up workout history listener for user: $userId');
    
    // Cancel any existing subscription
    _workoutHistorySubscription?.cancel();
    
    _workoutHistorySubscription = FirebaseDatabase.instance
        .ref('workoutHistory/$userId')
        .onValue
        .listen((event) async {
      debugPrint('Received Firebase update event');
      if (!mounted) {
        debugPrint('Widget not mounted, ignoring update');
        return;
      }
      
      if (!event.snapshot.exists) {
        debugPrint('No workout data in snapshot');
        return;
      }
      
      debugPrint('Processing Firebase update...');
      _fetchWorkoutStats();
      
      if (mounted) {
        await Provider.of<AchievementProvider>(context, listen: false).checkAchievements();
      }
    }, onError: (error) {
      debugPrint('Error in workout history listener: $error');
    });
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SettingsPage()),
    );
  }

  void _fetchWorkoutStats() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      debugPrint('No user logged in');
      return;
    }

    debugPrint('Fetching workout stats...');
    final workoutHistoryRef = FirebaseDatabase.instance.ref('workoutHistory/$userId');
    final historySnapshot = await workoutHistoryRef.get();

    int totalCalories = 0;
    int totalWorkouts = 0;
    int totalDuration = 0;

    if (historySnapshot.exists && historySnapshot.value != null) {
      final historyData = historySnapshot.value as Map<dynamic, dynamic>;
      
      historyData.forEach((key, value) {
        if (value is Map) {
          // Count each completed workout
          totalWorkouts++;
          
          // Sum up calories burned
          if (value['caloriesBurned'] != null) {
            totalCalories += (value['caloriesBurned'] as int);
          }
          
          // Sum up duration
          if (value['duration'] != null) {
            totalDuration += (value['duration'] as int);
          }
        }
      });
      
      debugPrint('Stats - Workouts: $totalWorkouts, Calories: $totalCalories, Duration: $totalDuration');
      setState(() {
        _workoutStats = {
          'totalCalories': totalCalories,
          'totalWorkouts': totalWorkouts,
          'totalDuration': totalDuration,
        };
      });
    } else {
      debugPrint('No workout history found');
      setState(() {
        _workoutStats = {
          'totalCalories': 0,
          'totalWorkouts': 0,
          'totalDuration': 0,
        };
      });
    }
  }

  List<Widget> _getWidgetOptions() {
    return [
      _buildHomeContent(),
      const WorkoutPage(),
      const ProgressPage(),
      const UpgradePage(),
      const ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final widgetOptions = _getWidgetOptions();
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Workouts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upgrade),
            label: 'Upgrade',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF4285F4),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeHeader(),
          const SizedBox(height: 24),
          _buildWeeklySummary(),
          const SizedBox(height: 24),
          _buildTodaysWorkoutSection(),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    final avatarProvider = Provider.of<AvatarProvider>(context);
    // Use Consumer to listen for changes in the UserProvider
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final user = userProvider.user;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome back,',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF71757F),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.displayName ?? 'User',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2138),
                  ),
                ),
              ],
            ),
          GestureDetector(
              onTap: _navigateToSettings,
              child: CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                backgroundImage: avatarProvider.currentAvatar != null 
                    ? AssetImage(avatarProvider.currentAvatar!)
                    : null,
                child: avatarProvider.currentAvatar == null
                    ? Icon(Icons.person, size: 24, color: Colors.grey[600])
                    : null,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildWeeklySummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A2138),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                icon: Icons.fitness_center,
                iconColor: const Color(0xFF4285F4),
                iconBgColor: const Color(0xFFE8F1FE),
                value: (_workoutStats['totalWorkouts'] ?? 0).toString(),
                label: 'Workouts',
              ),
              _buildStatItem(
                icon: Icons.local_fire_department,
                iconColor: const Color(0xFFF85C5C),
                iconBgColor: const Color(0xFFFEE8E8),
                value: ((_workoutStats['totalCalories'] ?? 0) > 0 
                    ? _workoutStats['totalCalories'].toString() 
                    : '0'),
                label: 'Calories',
              ),
              _buildStatItem(
                icon: Icons.timer,
                iconColor: const Color(0xFF4CD964),
                iconBgColor: const Color(0xFFE8FEF0),
                value: ((_workoutStats['totalDuration'] ?? 0) ~/ 60).toString(),
                label: 'Minutes',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2138),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF71757F),
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysWorkoutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Workouts',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A2138),
          ),
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<Workout>>(
          future: _getHomepageWorkouts(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'No workouts added to homepage yet.\nGo to Workouts tab to add some!',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            }

            return Column(
              key: ValueKey(DateTime.now().toString()), // Force rebuild when data changes
              children: snapshot.data!.map((workout) => _buildWorkoutCard(workout)).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildWorkoutCard(Workout workout) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutDetailPage(workout: workout),
          ),
        );
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
                    child: Image.asset(
                      workout.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () => _removeWorkoutFromHomepage(workout),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: Icon(
                          Icons.remove_circle_outline,
                          color: Colors.red[400],
                          size: 20,
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
                    workout.description,
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
                        '${workout.duration} min',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.local_fire_department_outlined, 
                           size: 16, 
                           color: Colors.orange[600]),
                      const SizedBox(width: 4),
                      Text(
                        '${workout.calories} cal',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
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
                  // Removed the large button
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeWorkoutFromHomepage(Workout workout) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      final userHomepageRef = FirebaseDatabase.instance.ref('userHomepage/$userId');
      final snapshot = await userHomepageRef.get();
      
      if (snapshot.exists && snapshot.value != null) {
        final homepageData = snapshot.value as Map<dynamic, dynamic>;
        
        // Find the key of the entry with matching workoutId
        final entryKey = homepageData.entries.firstWhere(
          (entry) => entry.value is Map && entry.value['workoutId'] == workout.id,
          orElse: () => MapEntry('', {}),
        ).key;
        
        if (entryKey.isNotEmpty) {
          await userHomepageRef.child(entryKey).remove();
          
          // Force UI refresh by triggering setState
          setState(() {});
          
          // Show a confirmation snackbar
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${workout.title} removed from homepage'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to remove workout. Please try again.'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }
  }

  Future<List<Workout>> _getHomepageWorkouts() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      debugPrint('No user logged in');
      return [];
    }

    final userHomepageRef = FirebaseDatabase.instance.ref('userHomepage/$userId');
    final snapshot = await userHomepageRef.get();
    
    debugPrint('Firebase snapshot exists: ${snapshot.exists}');
    debugPrint('Firebase snapshot value: ${snapshot.value}');
    
    if (!snapshot.exists || snapshot.value == null) {
      debugPrint('No homepage workouts found');
      return [];
    }
    
    final Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    List<String> homepageWorkoutIds = [];
    
    data.forEach((key, value) {
      if (value is Map && value['workoutId'] != null) {
        homepageWorkoutIds.add(value['workoutId'].toString());
      } else if (value is Map<dynamic, dynamic>) {
        // Handle nested map structure
        value.forEach((innerKey, innerValue) {
          if (innerValue is Map && innerValue['workoutId'] != null) {
            homepageWorkoutIds.add(innerValue['workoutId'].toString());
          }
        });
      }
    });
    
    debugPrint('Found homepage workout IDs: $homepageWorkoutIds');
    
    final workouts = WorkoutTemplates.allWorkouts.where(
      (workout) => homepageWorkoutIds.contains(workout.id)
    ).toList();
    
    debugPrint('Found workouts: ${workouts.map((w) => w.title).toList()}');
    return workouts;
  }
}