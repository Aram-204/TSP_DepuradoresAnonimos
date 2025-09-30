class Child {
  final int? id;
  final String name;
  final String lastName;
  final DateTime birthdate;
  final bool isFemale;
  final bool disabilityFisica;
  final bool disabilityAuditiva;
  final bool disabilityVisual;
  final String? otherDisability;

  Child({
    this.id,
    required this.name,
    required this.lastName,
    required this.birthdate,
    required this.isFemale,
    required this.disabilityFisica,
    required this.disabilityAuditiva,
    required this.disabilityVisual,
    required this.otherDisability,
  });

  int getAge() {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthdate.year;
    if (currentDate.month < birthdate.month ||
        (currentDate.month == birthdate.month && currentDate.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  static Child fromMap(Map<String, dynamic> json) {
    return Child(
      id: json['id'] as int,
      name: json['name'] as String,
      lastName: json['last_name'] as String,
      birthdate: DateTime.parse(json['birthdate'] as String),
      isFemale: json['is_female'] as bool,
      disabilityFisica: json['disability_fisica'] as bool,
      disabilityAuditiva: json['disability_auditiva'] as bool,
      disabilityVisual: json['disability_visual'] as bool,
      otherDisability: json['other_disability'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'last_name': lastName,
      'birthdate': birthdate.toIso8601String(),
      'is_female': isFemale,
      'disability_fisica': disabilityFisica,
      'disability_auditiva': disabilityAuditiva,
      'disability_visual': disabilityVisual,
      'other_disability': otherDisability,
    };
  }
}