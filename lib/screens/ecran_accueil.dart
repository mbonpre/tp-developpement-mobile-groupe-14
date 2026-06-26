import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_liste_villes.dart';

class EcranAccueil extends StatelessWidget {
  const EcranAccueil({super.key});

  // Retourne une icône selon la condition météo
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

  // ÉTAPE 1 — Nouvelle méthode : retourne une couleur selon la condition
  Color _couleurFond(String condition) {
    switch (condition) {
      case 'Ensoleille': return Colors.orange[100]!; // orange clair
      case 'Nuageux':    return Colors.grey[200]!;   // gris clair
      case 'Pluvieux':   return Colors.blue[100]!;   // bleu clair
      default:           return Colors.white;         // blanc par défaut
    }
  }

  @override
  Widget build(BuildContext context) {
    // On lit les données depuis le ViewModel
    final vm = context.watch<VilleViewModel>();
    final ville = vm.villeSelectionnee;

    return Scaffold(
      appBar: AppBar(
        title: Text('AppMeteo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      // ÉTAPE 2 — Le body choisit entre le loader et le Container
      body: ville == null
        ? Center(child: CircularProgressIndicator())
        : Container(
            // ÉTAPE 3 — BoxDecoration porte la couleur dynamique
            decoration: BoxDecoration(
              color: _couleurFond(ville.condition),
            ),
            // ÉTAPE 4 — On étire le Container sur tout l'écran
            width: double.infinity,
            height: double.infinity,
            // ÉTAPE 5 — La Column devient enfant du Container
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icône météo
                Icon(
                  _iconeMeteo(ville.condition),
                  size: 100,
                  color: Colors.orange,
                ),
                SizedBox(height: 16),
                // Température
                Text(
                  '${ville.temperature.toStringAsFixed(0)}°C',
                  style: TextStyle(
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Nom de la ville
                Text(
                  ville.nom,
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.grey[700],
                  ),
                ),
                // Condition et humidité
                Text(
                  '${ville.condition} - Humidité : ${ville.humidite}%',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 32),
                // Bouton pour voir la liste des villes
                ElevatedButton.icon(
                  icon: Icon(Icons.list),
                  label: Text('Changer de ville'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EcranListeVilles(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}