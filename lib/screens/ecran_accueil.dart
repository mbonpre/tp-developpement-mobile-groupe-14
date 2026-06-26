import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import '../services/photo_service.dart';
import '../services/localisation_service.dart';
import '../services/notification_service.dart';
import 'ecran_liste_villes.dart';
import 'ecran_detail_ville.dart';

class EcranAccueil extends StatefulWidget {
  const EcranAccueil({super.key});

  @override
  State<EcranAccueil> createState() => _EcranAccueilState();
}

// ── SingleTickerProviderStateMixin pour l'AnimationController (Exercice C) ──
class _EcranAccueilState extends State<EcranAccueil>
    with SingleTickerProviderStateMixin {

  // ── Services natifs ───────────────────────────────────────────────────
  final PhotoService _photoService        = PhotoService();
  final LocalisationService _locaService  = LocalisationService();
  final NotificationService _notifService = NotificationService();

  // ── État local ────────────────────────────────────────────────────────
  File?   _photoVille;
  String? _coordonnees;

  // ── Étape 1 : AnimatedOpacity ─────────────────────────────────────────
  bool _visible = false;

  // ── Exercice C : AnimationController pour rotation du soleil ──────────
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();

    // Initialiser les notifications
    _notifService.initialiser();

    // Étape 1 : déclencher l'apparition en fondu après 300ms
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _visible = true);
    });

    // Exercice C : rotation continue du soleil
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose(); // libérer le controller
    super.dispose();
  }

  // ── Exercice C : démarrer/arrêter la rotation selon la condition ───────
  void _gererRotation(String condition) {
    if (condition == 'Ensoleille') {
      if (!_rotationController.isAnimating) {
        _rotationController.repeat(); // tourne indéfiniment
      }
    } else {
      _rotationController.stop();
      _rotationController.reset();
    }
  }

  // ── Exercice B : couleur de fond selon la température ─────────────────
  Color _couleurFondTemperature(double? temperature) {
    if (temperature == null) return Colors.white;
    if (temperature < 20)  return Colors.blue.shade100;   // frais
    if (temperature < 30)  return Colors.orange.shade100; // tempéré
    return Colors.red.shade100;                            // chaud
  }

  // ── Photo ─────────────────────────────────────────────────────────────
  Future<void> _choisirPhoto() async {
    final File? photo = await _photoService.choisirDepuisGalerie();
    if (photo != null) setState(() => _photoVille = photo);
  }

  Future<void> _prendrePhoto() async {
    final File? photo = await _photoService.prendreSelfie();
    if (photo != null) setState(() => _photoVille = photo);
  }

  void _afficherChoixPhoto() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Choisir depuis la galerie'),
            onTap: () { Navigator.pop(context); _choisirPhoto(); },
          ),
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Prendre une photo'),
            onTap: () { Navigator.pop(context); _prendrePhoto(); },
          ),
        ],
      ),
    );
  }

  // ── GPS ───────────────────────────────────────────────────────────────
  Future<void> _obtenirPosition() async {
    final position = await _locaService.getPositionActuelle();
    setState(() {
      _coordonnees = position != null
          ? 'Lat: ${position.latitude.toStringAsFixed(4)}, Lon: ${position.longitude.toStringAsFixed(4)}'
          : 'GPS indisponible ou permission refusée';
    });
  }

  // ── Alerte chaleur ────────────────────────────────────────────────────
  Future<void> _verifierAlerte(double temperature, String nomVille) async {
    await _notifService.verifierAlerteTemperature(temperature, nomVille);
  }

  // ── Helpers icônes ────────────────────────────────────────────────────
  IconData _iconeMeteo(String condition) {
    switch (condition) {
      case 'Ensoleille': return Icons.wb_sunny;
      case 'Orageux':    return Icons.thunderstorm;
      case 'Ventueux':   return Icons.air;
      case 'Nuageux':    return Icons.cloud;
      case 'Pluvieux':   return Icons.umbrella;
      default:           return Icons.wb_cloudy;
    }
  }

  IconData _iconePrevision(int weatherCode) {
    if (weatherCode == 0) return Icons.wb_sunny;
    if (weatherCode <= 3) return Icons.cloud;
    if ((weatherCode >= 51 && weatherCode <= 67) ||
        (weatherCode >= 80 && weatherCode <= 82)) return Icons.umbrella;
    if (weatherCode >= 95) return Icons.thunderstorm;
    return Icons.wb_cloudy;
  }

  @override
  Widget build(BuildContext context) {
    final vm    = context.watch<VilleViewModel>();
    final ville = vm.villeSelectionnee;
    final temp  = vm.meteoActuelle?.temperature;

    // Exercice C : gérer la rotation selon la condition de la ville
    if (ville != null) _gererRotation(ville.condition);

    return Scaffold(
      appBar: AppBar(
        title: const Text("AppMeteo"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),

      // ── Étape 1 : AnimatedOpacity sur tout le body ───────────────────
      body: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeIn,
        child: ville == null
            ? const Center(child: CircularProgressIndicator())

            // ── Exercice B : AnimatedContainer pour la couleur de fond ──
            : AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                width: double.infinity,
                height: double.infinity,
                color: _couleurFondTemperature(temp),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        // ── Étape 2 : GestureDetector + Hero ──────────
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EcranDetailVille(
                                  ville: vm.villeSelectionnee!,
                                  meteo: vm.meteoActuelle,
                                ),
                              ),
                            );
                          },
                          child: _photoVille != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _photoVille!,
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  ),
                                )

                              // ── Exercice A : AnimatedContainer sur l'icône ──
                              : AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.elasticOut,
                                  width:  (temp != null && temp > 30) ? 120 : 80,
                                  height: (temp != null && temp > 30) ? 120 : 80,
                                  child: Hero(
                                    tag: 'icone-${vm.villeSelectionnee?.nom ?? "meteo"}',

                                    // ── Exercice C : RotationTransition ──
                                    child: ville.condition == 'Ensoleille'
                                        ? RotationTransition(
                                            turns: _rotationController,
                                            child: Icon(
                                              _iconeMeteo(ville.condition),
                                              size: (temp != null && temp > 30) ? 120 : 80,
                                              color: Colors.orange,
                                            ),
                                          )
                                        : Icon(
                                            _iconeMeteo(ville.condition),
                                            size: (temp != null && temp > 30) ? 120 : 80,
                                            color: Colors.orange,
                                          ),
                                  ),
                                ),
                        ),

                        const SizedBox(height: 12),

                        // ── Boutons Photo et GPS ───────────────────────
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Photo'),
                              onPressed: _afficherChoixPhoto,
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.my_location),
                              label: const Text('Ma position'),
                              onPressed: _obtenirPosition,
                            ),
                          ],
                        ),

                        if (_coordonnees != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _coordonnees!,
                            style: const TextStyle(fontSize: 13, color: Colors.blueGrey),
                          ),
                        ],

                        const SizedBox(height: 15),

                        // ── Météo actuelle (Consumer) ──────────────────
                        Consumer<VilleViewModel>(
                          builder: (context, vm, _) {
                            if (vm.chargement) {
                              return const CircularProgressIndicator();
                            }

                            if (vm.erreur != null) {
                              return Column(
                                children: [
                                  const Icon(Icons.error, size: 60, color: Colors.red),
                                  const Image(image: AssetImage('assets/image1.png')),
                                  const SizedBox(height: 10),
                                  Text(vm.erreur!, style: const TextStyle(color: Colors.red)),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () => vm.selectionnerVille(vm.villeSelectionnee!),
                                    child: const Text("Réessayer"),
                                  ),
                                ],
                              );
                            }

                            final meteo = vm.meteoActuelle;
                            if (meteo == null) return const Text("Chargement...");

                            // Alerte chaleur
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _verifierAlerte(meteo.temperature, ville.nom);
                            });

                            final date = DateTime.parse(meteo.time);
                            final texteDate =
                                "Mesure du "
                                "${date.day.toString().padLeft(2, '0')}/"
                                "${date.month.toString().padLeft(2, '0')}/"
                                "${date.year} à "
                                "${date.hour.toString().padLeft(2, '0')}h"
                                "${date.minute.toString().padLeft(2, '0')}";

                            return Column(
                              children: [
                                // ── Étape 3 : AnimatedSwitcher sur la température ──
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                  child: Text(
                                    "${meteo.temperature.toStringAsFixed(1)} °C",
                                    // ValueKey détecte le changement de ville
                                    key: ValueKey(vm.villeSelectionnee?.nom),
                                    style: const TextStyle(
                                      fontSize: 55,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(texteDate, style: const TextStyle(color: Colors.grey)),
                                const SizedBox(height: 8),
                                Text(
                                  "${meteo.conditionTexte} - ${meteo.humidite}% d'humidité",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 20),

                        Text(
                          ville.nom,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 30),

                        const Text(
                          "Prévisions sur 3 jours",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 15),

                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: vm.previsions.length,
                            itemBuilder: (context, index) {
                              final p = vm.previsions[index];
                              return Card(
                                elevation: 4,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                  width: 120,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "${p.date.day.toString().padLeft(2, '0')}/${p.date.month.toString().padLeft(2, '0')}",
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      Icon(_iconePrevision(p.weatherCode), size: 35, color: Colors.blue),
                                      Text("Max : ${p.tempMax.toStringAsFixed(1)}°C"),
                                      Text("Min : ${p.tempMin.toStringAsFixed(1)}°C"),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 30),

                        ElevatedButton.icon(
                          icon: const Icon(Icons.list),
                          label: const Text("Changer de ville"),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const EcranListeVilles()),
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}