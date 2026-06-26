import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ville_viewmodel.dart';
import 'ecran_liste_villes.dart';

class EcranAccueil extends StatelessWidget {
  const EcranAccueil({super.key});

  // Icône de la météo actuelle
  IconData _iconeMeteo(String condition) {
    switch (condition) {
      case 'Ensoleille':
        return Icons.wb_sunny;
      case 'Orageux':
        return Icons.thunderstorm;
      case 'Ventueux':
        return Icons.air;
      case 'Nuageux':
        return Icons.cloud;
      case 'Pluvieux':
        return Icons.umbrella;
      default:
        return Icons.wb_cloudy;
    }
  }

  // Couleur de fond selon la météo
  Color _couleurFond(String condition) {
    switch (condition) {
      case 'Ensoleille':
        return Colors.orange.shade100;
      case 'Nuageux':
        return Colors.grey.shade200;
      case 'Pluvieux':
        return Colors.blue.shade100;
      default:
        return Colors.white;
    }
  }

  // Icône des prévisions
  IconData _iconePrevision(int weatherCode) {
    if (weatherCode == 0) {
      return Icons.wb_sunny;
    } else if (weatherCode <= 3) {
      return Icons.cloud;
    } else if ((weatherCode >= 51 && weatherCode <= 67) ||
        (weatherCode >= 80 && weatherCode <= 82)) {
      return Icons.umbrella;
    } else if (weatherCode >= 95) {
      return Icons.thunderstorm;
    }

    return Icons.wb_cloudy;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<VilleViewModel>();
    final ville = vm.villeSelectionnee;

    return Scaffold(
      appBar: AppBar(
        title: const Text("AppMeteo"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: ville == null
          ? const Center(child: CircularProgressIndicator())
          : Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: _couleurFond(ville.condition),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      Icon(
                        _iconeMeteo(ville.condition),
                        size: 100,
                        color: Colors.orange,
                      ),

                      const SizedBox(height: 15),

                      Consumer<VilleViewModel>(
                        builder: (context, vm, _) {
                          if (vm.chargement) {
                            return const CircularProgressIndicator();
                          }

                          if (vm.erreur != null) {
                            return Column(
                              children: [
                                const Icon(
                                  Icons.email,
                                  size: 60,
                                  color: Colors.red,
                                ),
                                 const Image(  image: AssetImage('assets/image1.png'),),
                                const SizedBox(height: 10),
                                Text(
                                  vm.erreur!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    vm.selectionnerVille(vm.villeSelectionnee!);
                                  },
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          }

                          final meteo = vm.meteoActuelle;

                          if (meteo == null) {
                            return const Text("Chargement...");
                          }

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
                              Text(
                                "${meteo.temperature.toStringAsFixed(1)} °C",
                                style: const TextStyle(
                                  fontSize: 55,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                texteDate,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
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
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Prévisions sur 3 jours",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: Container(
                                width: 120,
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "${p.date.day.toString().padLeft(2, '0')}/${p.date.month.toString().padLeft(2, '0')}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      _iconePrevision(p.weatherCode),
                                      size: 35,
                                      color: Colors.blue,
                                    ),
                                    Text(
                                      "Max : ${p.tempMax.toStringAsFixed(1)}°C",
                                    ),
                                    Text(
                                      "Min : ${p.tempMin.toStringAsFixed(1)}°C",
                                    ),
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
                            MaterialPageRoute(
                              builder: (_) => const EcranListeVilles(),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}