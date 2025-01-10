import 'package:flutter/material.dart';
import '../models/exercise_plan.dart';

class ResultScreen extends StatelessWidget {
  final ExercisePlan plan;

  ResultScreen({required this.plan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Egzersiz Planı'),
      ),
      body: ListView.builder(
        itemCount: plan.exercises.length,
        itemBuilder: (context, index) {
          final exercise = plan.exercises[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text('${exercise.exerciseName}'),
              subtitle: Text(
                'Gün: ${exercise.day}\n'
                    'Süre: ${exercise.durationMinutes} dk\n'
                    'Yoğunluk: ${exercise.intensity}',
              ),
              trailing: Text(
                '${exercise.caloriesBurnedEstimate.toStringAsFixed(0)} kcal',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('${exercise.exerciseName} Detayları'),
                    content: Text(
                      'Kas Grupları: ${exercise.targetMuscleGroups.join(", ")}\n'
                          'Ekipman: ${exercise.equipmentRequired.isNotEmpty ? exercise.equipmentRequired.join(", ") : "Ekipman Gerekmiyor"}\n'
                          'Notlar: ${exercise.notes}',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Kapat'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
