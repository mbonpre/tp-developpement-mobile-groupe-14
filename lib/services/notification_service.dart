import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  // L'objet principal du package qui gère toutes les notifications
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Initialiser le service au démarrage de l'app
  Future<void> initialiser() async {
    // Configuration pour Android : icône de l'app par défaut
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // On regroupe les settings (ici uniquement Android)
    const InitializationSettings settings =
        InitializationSettings(android: android);

    // On initialise le plugin avec ces settings
    await _plugin.initialize(settings);
  }

  // Envoyer une notification immédiate
  Future<void> envoyerNotification({
    required String titre,
    required String message,
  }) async {
    // Configuration du style de la notification Android
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'canal_meteo',          // ID unique du canal (obligatoire Android 8+)
      'Notifications Meteo',  // Nom du canal visible dans les paramètres
      importance: Importance.high,  // apparaît en haut de l'écran
      priority: Priority.high,
    );

    // On envoie la notification
    await _plugin.show(
      0,               // ID de la notification (0 = une seule à la fois)
      titre,           // titre affiché en gras
      message,         // texte affiché en dessous
      NotificationDetails(android: androidDetails),
    );
  }

  // Envoyer une alerte si la température dépasse 35°C
  Future<void> verifierAlerteTemperature(
      double temperature, String nomVille) async {
    if (temperature > 35) {
      await envoyerNotification(
        titre: 'Alerte chaleur !',
        message:
            'Il fait ${temperature.toStringAsFixed(1)}°C à $nomVille. Hydratez-vous !',
      );
    }
  }
}