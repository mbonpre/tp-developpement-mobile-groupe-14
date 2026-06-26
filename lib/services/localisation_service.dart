import 'package:geolocator/geolocator.dart';

class LocalisationService {

  // Demander la permission et obtenir la position GPS actuelle
  Future<Position?> getPositionActuelle() async {

    // ÉTAPE 1 : Vérifier si le GPS est activé sur le téléphone
    bool serviceActif = await Geolocator.isLocationServiceEnabled();
    if (!serviceActif) {
      print('GPS désactivé - demandez à l\'utilisateur de l\'activer');
      return null;
    }

    // ÉTAPE 2 : Vérifier si la permission a déjà été accordée
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // La permission n'a pas encore été demandée → on affiche le dialogue système
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // L'utilisateur a refusé définitivement → on ne peut plus demander
      print('Permission refusée définitivement');
      return null;
    }

    // ÉTAPE 3 : Obtenir la position avec une haute précision
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Calculer la distance (en mètres) entre deux points GPS
  double calculerDistance(
    double lat1, double lon1,
    double lat2, double lon2,
  ) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }
}