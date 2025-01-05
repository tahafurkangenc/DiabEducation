class ExercisePlan {
  final List<Exercise> exercises;

  ExercisePlan({required this.exercises});

  factory ExercisePlan.fromJson(List<dynamic> json) {
    return ExercisePlan(
      exercises: json.map((e) => Exercise.fromJson(e)).toList(),
    );
  }
}

class Exercise {
  final int day;
  final String exerciseName;
  final String exerciseType;
  final int durationMinutes;
  final String intensity;
  final List<String> targetMuscleGroups;
  final List<String> equipmentRequired;
  final double caloriesBurnedEstimate;
  final int? repetitions; // Bazı alanlar `null` olabiliyor
  final int? sets;
  final String notes;

  Exercise({
    required this.day,
    required this.exerciseName,
    required this.exerciseType,
    required this.durationMinutes,
    required this.intensity,
    required this.targetMuscleGroups,
    required this.equipmentRequired,
    required this.caloriesBurnedEstimate,
    this.repetitions,
    this.sets,
    required this.notes,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      day: json['day'] ?? 0,
      exerciseName: json['exercise_name'] ?? '',
      exerciseType: json['exercise_type'] ?? json['type'] ?? '', // Bazı alanlarda `type` kullanılıyor
      durationMinutes: json['duration_minutes'] ?? 0,
      intensity: json['intensity'] ?? '',
      targetMuscleGroups:
      List<String>.from(json['target_muscle_groups'] ?? []),
      equipmentRequired:
      List<String>.from(json['equipment_required'] ?? []),
      caloriesBurnedEstimate:
      (json['calories_burned_estimate'] ?? 0).toDouble(),
      repetitions: json['repetitions'],
      sets: json['sets'],
      notes: json['notes'] ?? '',
    );
  }
}
