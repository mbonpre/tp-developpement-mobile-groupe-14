import 'meteo_data.dart';
import 'prevision_jour.dart';

class MeteoComplete {
  final MeteoData meteo;
  final List<PrevisionJour> previsions;

  MeteoComplete({
    required this.meteo,
    required this.previsions,
  });
}