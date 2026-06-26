class PrevisionJour {
  final DateTime date;
  final double tempMax;
  final double tempMin;
  final int weatherCode;

  PrevisionJour({
    required this.date,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });

  factory PrevisionJour.fromJson({
    required String date,
    required double tempMax,
    required double tempMin,
    required int weatherCode,
  }) {
    return PrevisionJour(
      date: DateTime.parse(date),
      tempMax: tempMax,
      tempMin: tempMin,
      weatherCode: weatherCode,
    );
  }
}