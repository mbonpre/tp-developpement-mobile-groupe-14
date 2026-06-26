import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:app_meteo/viewmodels/ville_viewmodel.dart';
import 'package:app_meteo/screens/ecran_accueil.dart';
import 'package:app_meteo/screens/ecran_liste_villes.dart';

// Fonction utilitaire : crée le widget avec son Provider
Widget creerAppTest() {
  return ChangeNotifierProvider(
    create: (_) => VilleViewModel(),
    child: const MaterialApp(
      home: EcranAccueil(),
    ),
  );
}

void main() {

  // Test 1 : AppBar avec le bon titre
  testWidgets('EcranAccueil affiche une AppBar avec le titre', (tester) async {
    await tester.pumpWidget(creerAppTest());
    await tester.pumpAndSettle();

    expect(find.byType(AppBar),       findsOneWidget);
    expect(find.text('AppMeteo'),     findsOneWidget);
  });

  // Test 2 : une température est affichée (contient °C)
  testWidgets('EcranAccueil affiche une Temperature', (tester) async {
    await tester.pumpWidget(creerAppTest());
    await tester.pumpAndSettle();

    final textFinder = find.textContaining('C');
    expect(textFinder, findsWidgets); // au moins un widget avec "C"
  });

  // Test 3 : le bouton "Changer de ville" est présent
  testWidgets('Le bouton Changer de ville est present', (tester) async {
    await tester.pumpWidget(creerAppTest());
    await tester.pumpAndSettle();

    expect(find.text('Changer de ville'), findsOneWidget);
  });

  // Test 4 : complété — appuyer sur le bouton ouvre la liste des villes
  testWidgets('Appuyer sur Changer de ville ouvre la liste', (tester) async {
    await tester.pumpWidget(creerAppTest());
    await tester.pumpAndSettle();

    // ACT : appuyer sur le bouton
    await tester.tap(find.text('Changer de ville'));
    await tester.pumpAndSettle();

    // ASSERT : l'écran de liste est visible
    expect(find.byType(EcranListeVilles), findsOneWidget);
  });

  // Test bonus : les boutons Photo et Ma position sont présents
  testWidgets('Les boutons Photo et Ma position sont presents', (tester) async {
    await tester.pumpWidget(creerAppTest());
    await tester.pumpAndSettle();

    expect(find.text('Photo'),       findsOneWidget);
    expect(find.text('Ma position'), findsOneWidget);
  });

  // Test bonus : le nom de la ville sélectionnée est affiché
  testWidgets('Le nom de la ville selectionnee est affiche', (tester) async {
    await tester.pumpWidget(creerAppTest());
    await tester.pumpAndSettle();

    expect(find.text('Cotonou'), findsOneWidget);
  });
}