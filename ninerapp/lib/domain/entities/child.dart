import 'package:ninerapp/domain/entities/person.dart';

class Child extends Person {
  final bool disabilityFisica;
  final bool disabilityAuditiva;
  final bool disabilityVisual;
  final String? otherDisabilities;

  Child({
    super.id,
    required super.name,
    required super.lastName,
    required super.birthdate,
    required super.isFemale,
    required this.disabilityFisica,
    required this.disabilityAuditiva,
    required this.disabilityVisual,
    this.otherDisabilities,
  });

  static Child fromMap(Map<String, dynamic> map) {
    return Child(
      id: map['id'] as int,
      name: map['name'] as String,
      lastName: map['last_name'] as String,
      birthdate: DateTime.parse(map['birthdate'] as String),
      isFemale: map['is_female'] as bool,
      disabilityFisica: map['phisical_disability'] as bool,
      disabilityAuditiva: map['hearing_disability'] as bool,
      disabilityVisual: map['visual_disability'] as bool,
      otherDisabilities: map['other_disability'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()..addAll({
      'phisical_disability': disabilityFisica,
      'hearing_disability': disabilityAuditiva,
      'visual_disability': disabilityVisual,
      'other_disabilities': otherDisabilities,
    });
  }

  @override
  int getAge() {
    int age = super.getAge();
    if (age == 0) {
      final currentDate = DateTime.now();
      int age = currentDate.month - birthdate.month;
      if (currentDate.day < birthdate.day) {
        age--;
      }
      return age * -1;
    }
    return age;
  }
}