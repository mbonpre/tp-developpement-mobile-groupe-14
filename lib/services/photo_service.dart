import 'package:image_picker/image_picker.dart';
import 'dart:io'; // pour utiliser le type File

class PhotoService {
  // L'objet qui permet d'accéder à la caméra et la galerie
  final ImagePicker _picker = ImagePicker();

  // Choisir une photo depuis la galerie du téléphone
  Future<File?> choisirDepuisGalerie() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,       // on redimensionne pour économiser la mémoire
      maxHeight: 600,
      imageQuality: 80,    // qualité entre 0 et 100
    );

    if (image == null) return null; // l'utilisateur a annulé
    return File(image.path);        // on retourne un objet File avec le chemin
  }

  // Prendre une photo avec la caméra du téléphone
  Future<File?> prendreSelfie() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.rear, // caméra arrière
    );

    if (image == null) return null;
    return File(image.path);
  }
}