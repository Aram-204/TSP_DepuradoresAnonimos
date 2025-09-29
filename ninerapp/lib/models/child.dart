class Child {
  final String id;
  final String name;
  final String lastName;
  final DateTime birthdate;
  final bool isFemale;

  Child({
    required this.id,
    required this.name,
    required this.lastName,
    required this.birthdate,
    required this.isFemale,
  });

  int getAge() {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthdate.year;
    if (currentDate.month < birthdate.month || (currentDate.month == birthdate.month && currentDate.day < birthdate.day)) {
      age--;
    }
    return age;
  }
}