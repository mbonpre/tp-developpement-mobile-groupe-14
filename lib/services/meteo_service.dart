import 'package:dio/dio.dart';

import '../models/meteo_complete.dart';
import '../models/meteo_data.dart';
import '../models/prevision_jour.dart';

class MeteoService {
  // Coordonnées GPS des villes
  static const Map<String, List<double>> _coords = {
    'Cotonou':    [6.3703,  2.3912],
    'Parakou':    [9.3370,  2.6283],
    'Lagos':      [6.4541,  3.3947],
    'Abidjan':    [5.3600, -4.0083],
    'Porto-Novo': [6.4969,  2.6289],  // ✅ ajouté
    'Tokyo':      [35.6762, 139.6503], // ✅ ajouté
  };

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.open-meteo.com/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  MeteoService() {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (msg) => print('[DIO] $msg'),
      ),
    );
  }

  /// Récupère la météo actuelle et les prévisions
  Future<MeteoComplete?> getMeteo(String nomVille) async {
    final coords = _coords[nomVille];

    if (coords == null) {
      print("Ville inconnue : $nomVille");
      return null;
    }

    try {
      final response = await _dio.get(
        '/forecast',
        queryParameters: {
          'latitude':  coords[0],
          'longitude': coords[1],

          // Météo actuelle — 'time' est retourné automatiquement, ne pas le lister
          'current': 'temperature_2m,relative_humidity_2m,weather_code', // ✅ weather_code

          // Prévisions journalières
          'daily': 'temperature_2m_max,temperature_2m_min,weather_code', // ✅ weather_code

          'timezone': 'Africa/Lagos',
        },
      );

      final current = response.data['current'];
      final daily   = response.data['daily'];

      List<PrevisionJour> previsions = [];

      // On récupère les 3 premiers jours
      for (int i = 0; i < 3; i++) {
        previsions.add(
          PrevisionJour.fromJson(
            date:        daily['time'][i],
            tempMax:     (daily['temperature_2m_max'][i] as num).toDouble(),
            tempMin:     (daily['temperature_2m_min'][i] as num).toDouble(),
            weatherCode: (daily['weather_code'][i] as num).toInt(), // ✅ weather_code
          ),
        );
      }

      return MeteoComplete(
        meteo:      MeteoData.fromJson(current),
        previsions: previsions,
      );
    } on DioException catch (e) {
      print("===== ERREUR DIO =====");
      print(e.message);
      print(e.response?.data);
      return null;
    } catch (e, stackTrace) {
      print("===== ERREUR =====");
      print(e);
      print(stackTrace);
      return null;
    }
  }
}
