import 'package:flutter/foundation.dart';
import '../models/ville.dart';
import '../services/meteo_service.dart';
import '../models/meteo_data.dart';
import '../models/prevision_jour.dart';
import '../models/meteo_complete.dart';

class VilleViewModel extends ChangeNotifier {

  // =========================================================
  // LISTE DES VILLES
  // =========================================================

  List<Ville> _villes = [];
  List<PrevisionJour> _previsions = [];
  Ville? _villeSelectionnee;

  List<Ville> get villes => _villes;
  Ville? get villeSelectionnee => _villeSelectionnee;
  List<PrevisionJour> get previsions => _previsions;

  // =========================================================
  // CACHE  Map<nomVille, (MeteoComplete, DateDuChargement)>
  // =========================================================

  // La Map qui stocke les données déjà chargées
  final Map<String, (MeteoComplete, DateTime)> _cache = {};

  // Vérifie si le cache d'une ville est encore valide (< 30 min)
  bool _estCacheValide(String nomVille) {
    // 1. La ville n'est pas du tout dans le cache → invalide
    if (!_cache.containsKey(nomVille)) return false;

    // 2. On récupère la date du dernier chargement
    final DateTime derniereMAJ = _cache[nomVille]!.$2;

    // 3. On calcule la durée écoulée depuis ce chargement
    final Duration ecoule = DateTime.now().difference(derniereMAJ);

    // 4. Cache valide si moins de 30 minutes se sont écoulées
    return ecoule.inMinutes < 30;
  }

  // =========================================================
  // MÉTÉO ACTUELLE
  // =========================================================

  final MeteoService _meteoService = MeteoService();
  MeteoData? _meteoActuelle;
  bool _chargement = false;
  String? _erreur;

  MeteoData? get meteoActuelle => _meteoActuelle;
  bool get chargement => _chargement;
  String? get erreur => _erreur;

  // =========================================================
  // CONSTRUCTEUR
  // =========================================================

  VilleViewModel() {
    _initialiser();
  }

  void _initialiser() {
    _villes = [
      Ville(nom: 'Cotonou',    pays: 'Benin',   temperature: 29, condition: 'Ensoleille', humidite: 75),
      Ville(nom: 'Parakou',    pays: 'Benin',   temperature: 32, condition: 'Ensoleille', humidite: 60),
      Ville(nom: 'Lagos',      pays: 'Nigeria', temperature: 31, condition: 'Nuageux',    humidite: 80),
      Ville(nom: 'Abidjan',    pays: 'CI',      temperature: 27, condition: 'Pluvieux',   humidite: 85),
      Ville(nom: 'Porto-Novo', pays: 'Benin',   temperature: 36, condition: 'Orageux',    humidite: 10),
      Ville(nom: 'Tokyo',      pays: 'Japon',   temperature: 27, condition: 'Ventueux',   humidite: 70),
    ];
    _villeSelectionnee = _villes.first;

    notifyListeners();

    selectionnerVille(_villeSelectionnee!);
  }

  // =========================================================
  // SÉLECTION D'UNE VILLE (avec logique de cache)
  // =========================================================

  Future<void> selectionnerVille(Ville ville) async {
    _villeSelectionnee = ville;
    _erreur = null;

    // --- CAS 1 : le cache est valide, on l'utilise directement ---
    if (_estCacheValide(ville.nom)) {
      print('[CACHE] Données de ${ville.nom} récupérées depuis le cache');

      // On lit le MeteoComplete stocké dans le cache (.$1 = 1er élément du record)
      final MeteoComplete donneesCachees = _cache[ville.nom]!.$1;

      _meteoActuelle = donneesCachees.meteo;
      _previsions    = donneesCachees.previsions;
      _chargement    = false;

      notifyListeners();
      return; // on s'arrête ici, pas d'appel API
    }

    // --- CAS 2 : pas de cache valide, on appelle l'API ---
    print('[API] Chargement depuis l\'API pour ${ville.nom}');

    _chargement = true;
    notifyListeners();

    final MeteoComplete? resultat = await _meteoService.getMeteo(ville.nom);

    if (resultat != null) {
      _meteoActuelle = resultat.meteo;
      _previsions    = resultat.previsions;

      // On sauvegarde le résultat dans le cache avec l'heure actuelle
      _cache[ville.nom] = (resultat, DateTime.now());

      print('[CACHE] Données de ${ville.nom} mises en cache à ${DateTime.now()}');
    } else {
      _erreur = "Impossible de charger la météo";
    }

    _chargement = false;
    notifyListeners();
  }

  // =========================================================
  // AJOUTER UNE VILLE
  // =========================================================

  void ajouterVille(Ville ville) {
    _villes.add(ville);
    notifyListeners();
  }
}
