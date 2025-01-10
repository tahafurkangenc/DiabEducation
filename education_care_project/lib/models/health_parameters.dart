class HealthParameters {
  String gender;
  int age;
  double weight;
  double height;
  List<String> existingConditions;
  double caloriesBurned;
  String injuryStatus;
  String bloodSugarStatus;
  String tissueDamage;

  HealthParameters({
    required this.gender,
    required this.age,
    required this.weight,
    required this.height,
    required this.existingConditions,
    required this.caloriesBurned,
    required this.injuryStatus,
    required this.bloodSugarStatus,
    required this.tissueDamage,
  });

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'weight': weight,
      'height': height,
      'existing_conditions': existingConditions,
      'calories_burned': caloriesBurned,
      'injury_status': injuryStatus,
      'blood_sugar_status': bloodSugarStatus,
      'tissue_damage': tissueDamage,
    };
  }
}
