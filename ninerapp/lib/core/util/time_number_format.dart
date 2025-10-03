class TimeNumberFormat {
  static String formatTwoDigits(int number) {
    return number.toString().length == 1 ? '0$number' : '$number';
  }

  static String getMonthName(int month) {
    const monthNames = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    if (month < 1 || month > 12) {
      throw ArgumentError('El mes dado debe ser desde el 1 al 12');
    }
    return monthNames[month - 1];
  }
}