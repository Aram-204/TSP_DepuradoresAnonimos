import 'package:ninerapp/domain/entities/person.dart';

class Babysitter extends Person{
  final double pricePerHour;
  final int? workStartYear;
  final bool expPhisicalDisability;
  final bool expHearingDisability;
  final bool expVisualDisability;
  final String? expOtherDisabilities;

  Babysitter({
    super.id,
    required super.name,
    required super.lastName,
    required super.birthdate,
    required super.isFemale,
    required this.pricePerHour,
    required this.workStartYear,
    required this.expPhisicalDisability,
    required this.expHearingDisability,
    required this.expVisualDisability,
    this.expOtherDisabilities,
  });

  static Babysitter fromMap(Map<String, dynamic> map) {
    return Babysitter(
      id: map['id'] as int,
      name: map['name'] as String,
      lastName: map['last_name'] as String,
      birthdate: DateTime.parse(map['birthdate'] as String),
      isFemale: map['is_female'] as bool,

      pricePerHour: (map['price_per_hour'] as num).toDouble(),
      workStartYear: map['work_start_year'] as int?,
      expPhisicalDisability: map['exp_phisical_disability'] as bool,
      expHearingDisability: map['exp_hearing_disability'] as bool,
      expVisualDisability: map['exp_visual_disability'] as bool,
      expOtherDisabilities: map['exp_other_disabilities'] as String?,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()..addAll({
      'price_per_hour': pricePerHour,
      'exp_phisical_disability': expPhisicalDisability,
      'exp_hearing_disability': expHearingDisability,
      'exp_visual_disability': expVisualDisability,
      'exp_other_disabilities': expOtherDisabilities,
    });
  }

  int getExperienceYears() {
    if (workStartYear == null) return 0;
    final currentYear = DateTime.now().year;
    return currentYear - workStartYear!;
  }
}