// models/category_progress.dart

import 'module_progress.dart';

class CategoryProgress {
  final String categoryName;
  final List<ModuleProgress> modules;

  CategoryProgress({
    required this.categoryName,
    required this.modules,
  });

  factory CategoryProgress.fromJson(Map<String, dynamic> json) {
    var modulesFromJson = json['modules'] as List;
    List<ModuleProgress> moduleList = modulesFromJson
        .map((moduleJson) => ModuleProgress.fromJson(moduleJson))
        .toList();

    return CategoryProgress(
      categoryName: json['category_name'],
      modules: moduleList,
    );
  }
}
