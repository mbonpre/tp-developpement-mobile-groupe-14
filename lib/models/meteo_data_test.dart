import 'package:flutter_test/flutter_test.dart';
import 'package:app_meteo/models/meteo_data.dart';

void main() {
  group('MeteoData', () {

    // ── Étape 1 : Tests du cours ────────────────────────────────────────

    // Test 1 : fromJson parse la température correctement
    test('fromJson parse la temperature correctement', () {
      // ARRANGE : un JSON comme celui retourné par l'API
      final json = {
        'temperature_2m':       29.5,
        'relative_humidity_2m': 70,
        'weather_code':         0,
        'time':                 '2026-01-01T12:00',
      };

      // ACT : parser le JSON
      final meteo = MeteoData.fromJson(json);

      // ASSERT : vérifier la valeur
      expect(meteo.temperature, equals(29.5));
    });

    // Test 2 : conditionTexte retourne Ensoleille pour code 0
    test('conditionTexte retourne Ensoleille pour code 0', () {
      final meteo = MeteoData(
        temperature: 30,
        humidite:    60,
        weatherCode: 0,
        time:        '2026-01-01T12:00',
      );
      expect(meteo.conditionTexte, equals('Ensoleille'));
    });

    // Test 3 : complété — conditionTexte retourne Pluvieux pour code 61
    test('conditionTexte retourne Pluvieux pour code 61', () {
      final meteo = MeteoData(
        temperature: 25,
        humidite:    85,
        weatherCode: 61,
        time:        '2026-01-01T12:00',
      );
      expect(meteo.conditionTexte, equals('Pluvieux'));
    });

    // Test 4 : complété — fromJson parse correctement l'humidité
    test('fromJson parse l humidite correctement', () {
      final json = {
        'temperature_2m':       22.0,
        'relative_humidity_2m': 75,
        'weather_code':         0,
        'time':                 '2026-01-01T12:00',
      };
      final meteo = MeteoData.fromJson(json);
      expect(meteo.humidite, equals(75));
    });

    // ── Exercice A : tous les codes WMO ────────────────────────────────

    test('conditionTexte retourne Nuageux pour code 1', () {
      final meteo = MeteoData(temperature: 20, humidite: 60, weatherCode: 1, time: '2026-01-01T12:00');
      expect(meteo.conditionTexte, equals('Nuageux'));
    });

    test('conditionTexte retourne Nuageux pour code 3', () {
      final meteo = MeteoData(temperature: 20, humidite: 60, weatherCode: 3, time: '2026-01-01T12:00');
      expect(meteo.conditionTexte, equals('Nuageux'));
    });

    test('conditionTexte retourne Averses pour code 80', () {
      final meteo = MeteoData(temperature: 18, humidite: 90, weatherCode: 80, time: '2026-01-01T12:00');
      expect(meteo.conditionTexte, equals('Averses'));
    });

    test('conditionTexte retourne Averses pour code 82', () {
      final meteo = MeteoData(temperature: 18, humidite: 90, weatherCode: 82, time: '2026-01-01T12:00');
      expect(meteo.conditionTexte, equals('Averses'));
    });

    test('conditionTexte retourne Orageux pour code 95', () {
      final meteo = MeteoData(temperature: 28, humidite: 95, weatherCode: 95, time: '2026-01-01T12:00');
      expect(meteo.conditionTexte, equals('Orageux'));
    });

    test('conditionTexte retourne Variable pour code inconnu (ex: 10)', () {
      final meteo = MeteoData(temperature: 22, humidite: 65, weatherCode: 10, time: '2026-01-01T12:00');
      expect(meteo.conditionTexte, equals('Variable'));
    });

    // ── Exercice B : estDangereux() — 4 cas ────────────────────────────

    test('estDangereux retourne true si chaud ET orageux', () {
      // T > 40 ET code >= 95
      final meteo = MeteoData(temperature: 42, humidite: 80, weatherCode: 95, time: '2026-01-01T12:00');
      expect(meteo.estDangereux(), isTrue);
    });

    test('estDangereux retourne true si chaud seul (T > 40)', () {
      // T > 40 mais code normal
      final meteo = MeteoData(temperature: 41, humidite: 30, weatherCode: 0, time: '2026-01-01T12:00');
      expect(meteo.estDangereux(), isTrue);
    });

    test('estDangereux retourne true si orageux seul (code >= 95)', () {
      // T normale mais orage
      final meteo = MeteoData(temperature: 28, humidite: 90, weatherCode: 99, time: '2026-01-01T12:00');
      expect(meteo.estDangereux(), isTrue);
    });

    test('estDangereux retourne false si normal', () {
      // T normale et pas d'orage
      final meteo = MeteoData(temperature: 30, humidite: 60, weatherCode: 0, time: '2026-01-01T12:00');
      expect(meteo.estDangereux(), isFalse);
    });

  });
}