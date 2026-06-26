import 'package:flutter_test/flutter_test.dart';
import 'package:app_meteo/viewmodels/ville_viewmodel.dart';
import 'package:app_meteo/models/ville.dart';

void main() {

  late VilleViewModel vm;

  setUp(() {
    // Créer un ViewModel frais avant chaque test
    vm = VilleViewModel();
  });

  group('VilleViewModel', () {

    // Test 1 : liste initiale contient au moins 4 villes
    test('la liste initiale contient au moins 4 villes', () {
      expect(vm.villes.length, greaterThanOrEqualTo(4));
    });

    // Test 2 : Cotonou est dans la liste
    test('Cotonou est dans la liste initiale', () {
      final contientCotonou = vm.villes.any((v) => v.nom == 'Cotonou');
      expect(contientCotonou, isTrue);
    });

    // Test 3 : selectionnerVille met à jour villeSelectionnee
    test('selectionnerVille met a jour villeSelectionnee', () {
      // ARRANGE : trouver Lagos dans la liste
      final lagos = vm.villes.firstWhere((v) => v.nom == 'Lagos');

      // ACT
      vm.selectionnerVille(lagos);

      // ASSERT
      expect(vm.villeSelectionnee?.nom, equals('Lagos'));
    });

    // Test 4 : complété — ajouterVille augmente la liste de 1
    test('ajouterVille augmente la liste de 1', () {
      // ARRANGE
      final nbAvant = vm.villes.length;
      final nouvelleVille = Ville(
        nom:         'Natitingou',
        pays:        'Benin',
        temperature: 28,
        condition:   'Ensoleille',
        humidite:    55,
      );

      // ACT
      vm.ajouterVille(nouvelleVille);

      // ASSERT
      expect(vm.villes.length, equals(nbAvant + 1));
    });

    // Test 5 : complété — selectionnerVille notifie les listeners
    test('selectionnerVille notifie les listeners', () {
      // ARRANGE : compteur de notifications
      int compteur = 0;
      vm.addListener(() => compteur++);

      // ACT
      final lagos = vm.villes.firstWhere((v) => v.nom == 'Lagos');
      vm.selectionnerVille(lagos);

      // ASSERT : au moins une notification envoyée
      expect(compteur, greaterThan(0));
    });

    // Test bonus : ajouterVille notifie les listeners
    test('ajouterVille notifie les listeners', () {
      int compteur = 0;
      vm.addListener(() => compteur++);

      vm.ajouterVille(Ville(
        nom: 'TestVille', pays: 'Test',
        temperature: 25, condition: 'Nuageux', humidite: 50,
      ));

      expect(compteur, greaterThan(0));
    });

    // Test bonus : la ville sélectionnée par défaut est la première
    test('la ville selectionnee par defaut est la premiere', () {
      expect(vm.villeSelectionnee?.nom, equals(vm.villes.first.nom));
    });

  });
}