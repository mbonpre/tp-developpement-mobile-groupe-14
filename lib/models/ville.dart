import 'dart:io'; // pour utiliser le type File

class Ville {
  final String nom;
  final String pays;
  final double temperature; // en degrés Celsius
  final String condition;   // "Ensoleille", "Nuageux", "Pluvieux"
  final int humidite;       // en pourcentage (0-100)
  final File? photo;        // photo personnalisée de la ville (optionnelle)

  Ville({
    required this.nom,
    required this.pays,
    required this.temperature,
    required this.condition,
    required this.humidite,
    this.photo, // optionnel : null par défaut si pas de photo
  });

  // Crée une copie de la ville avec une nouvelle photo
  Ville copyWith({File? photo}) {
    return Ville(
      nom: this.nom,
      pays: this.pays,
      temperature: this.temperature,
      condition: this.condition,
      humidite: this.humidite,
      photo: photo ?? this.photo,
    );
  }
}