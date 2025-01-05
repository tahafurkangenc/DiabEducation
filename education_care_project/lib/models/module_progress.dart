// models/module_progress.dart

class ModuleProgress {
  final String name;
  final bool completed;
  final int completionPercentage;
  final String topic;

  ModuleProgress({
    required this.name,
    required this.completed,
    required this.completionPercentage,
    required this.topic,
  });

  factory ModuleProgress.fromJson(Map<String, dynamic> json) {
    return ModuleProgress(
      name: json['name'],
      completed: json['completed'],
      completionPercentage: json['completion_percentage'],
      topic: json['topic'] ?? 'Unknown',
    );
  }
}
