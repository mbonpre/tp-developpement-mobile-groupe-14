class MeteoData {
  final double temperature; // température en Celsius
  final int humidite;       // humidité en %
  final int weatherCode;    // code WMO (0=ensoleillé, 61=pluvieux...)
  final String time;        // heure de la mesure

  MeteoData({
    required this.temperature,
    required this.humidite,
    required this.weatherCode,
    required this.time,
  });

  // Créer un MeteoData depuis la réponse JSON de l'API
  factory MeteoData.fromJson(Map<String, dynamic> json) {
    return MeteoData(
      temperature: (json['temperature_2m'] as num).toDouble(),
      humidite:    (json['relative_humidity_2m'] as num).toInt(),
      weatherCode: (json['weather_code'] as num).toInt(),
      time:        json['time'],
    );
  }

  // Convertir le code WMO en texte lisible
  String get conditionTexte {
    if (weatherCode == 0)                           return 'Ensoleille';
    if (weatherCode <= 3)                           return 'Nuageux';
    if (weatherCode >= 51 && weatherCode <= 67)     return 'Pluvieux';
    if (weatherCode >= 80 && weatherCode <= 82)     return 'Averses';
    if (weatherCode >= 95)                          return 'Orageux';
    return 'Variable';
  }

  // Exercice B : retourne true si température > 40°C OU orage (code >= 95)
  bool estDangereux() {
    return temperature > 40 || weatherCode >= 95;
  }
}