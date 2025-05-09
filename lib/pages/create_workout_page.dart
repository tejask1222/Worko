import 'package:flutter/material.dart';
import '../models/workout.dart';
import 'exercise_library_page.dart';

class CreateWorkoutPage extends StatefulWidget {
  const CreateWorkoutPage({super.key});

  @override
  State<CreateWorkoutPage> createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  final List<WorkoutExercise> _selectedExercises = [];

  @override
  void dispose() {
    _titleController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _addExercise() async {
    // Navigate to exercise library and get selected exercise
    final Exercise? selectedExercise = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExerciseLibraryPage()),
    );

    if (selectedExercise != null) {
      // Show dialog to configure sets, reps, and calories
      await showDialog(
        context: context,
        builder: (context) => _ExerciseConfigDialog(
          onSave: (config) {
            setState(() {
              _selectedExercises.add(
                WorkoutExercise(
                  exercise: selectedExercise,
                  config: config,
                ),
              );
            });
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Workout'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              // Save workout logic here
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Workout Title',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(
              labelText: 'Category',
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Exercises',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ..._selectedExercises.map((workoutExercise) => _buildExerciseCard(workoutExercise)).toList(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addExercise,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildExerciseCard(WorkoutExercise workoutExercise) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    workoutExercise.exercise.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () async {
                    // Show dialog to edit configuration
                    await showDialog(
                      context: context,
                      builder: (context) => _ExerciseConfigDialog(
                        initialConfig: workoutExercise.config,
                        onSave: (config) {
                          setState(() {
                            final index = _selectedExercises.indexOf(workoutExercise);
                            _selectedExercises[index] = WorkoutExercise(
                              exercise: workoutExercise.exercise,
                              config: config,
                            );
                          });
                        },
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _selectedExercises.remove(workoutExercise);
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Sets: ${workoutExercise.config.sets}'),
            Text('Reps: ${workoutExercise.config.reps}'),
            Text('Calories: ${workoutExercise.config.calories}'),
          ],
        ),
      ),
    );
  }
}

class _ExerciseConfigDialog extends StatefulWidget {
  final ExerciseConfig? initialConfig;
  final Function(ExerciseConfig) onSave;

  const _ExerciseConfigDialog({
    this.initialConfig,
    required this.onSave,
  });

  @override
  _ExerciseConfigDialogState createState() => _ExerciseConfigDialogState();
}

class _ExerciseConfigDialogState extends State<_ExerciseConfigDialog> {
  late final TextEditingController _setsController;
  late final TextEditingController _repsController;
  late final TextEditingController _caloriesController;

  @override
  void initState() {
    super.initState();
    _setsController = TextEditingController(text: widget.initialConfig?.sets.toString() ?? '3');
    _repsController = TextEditingController(text: widget.initialConfig?.reps.toString() ?? '10');
    _caloriesController = TextEditingController(text: widget.initialConfig?.calories.toString() ?? '50');
  }

  @override
  void dispose() {
    _setsController.dispose();
    _repsController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialConfig == null ? 'Configure Exercise' : 'Edit Configuration'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _setsController,
            decoration: const InputDecoration(labelText: 'Sets'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _repsController,
            decoration: const InputDecoration(labelText: 'Reps'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _caloriesController,
            decoration: const InputDecoration(labelText: 'Calories'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final config = ExerciseConfig(
              sets: int.parse(_setsController.text),
              reps: int.parse(_repsController.text),
              calories: int.parse(_caloriesController.text),
            );
            widget.onSave(config);
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
