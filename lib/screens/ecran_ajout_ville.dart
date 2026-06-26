import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ville.dart';
import '../viewmodels/ville_viewmodel.dart';

class EcranAjoutVille extends StatefulWidget {
  const EcranAjoutVille({super.key});

  @override
  State<EcranAjoutVille> createState() => _EcranAjoutVilleState(); // ✅ _ présent
}

class _EcranAjoutVilleState extends State<EcranAjoutVille> { // ✅ _ présent

  // ✅ Tous les membres privés avec _
  final _nomController         = TextEditingController();
  final _paysController        = TextEditingController();
  final _temperatureController = TextEditingController();
  final _humiditeController    = TextEditingController();

  String _conditionChoisie = 'Ensoleille'; // ✅ _ ajouté

  final List<String> _conditions = [ // ✅ _ ajouté
    'Ensoleille',
    'Nuageux',
    'Pluvieux',
    'Orageux',
    'Ventueux',
  ];

  @override
  void dispose() {
    // ✅ On utilise les noms avec _ partout
    _nomController.dispose();
    _paysController.dispose();
    _temperatureController.dispose();
    _humiditeController.dispose();
    super.dispose();
  }

  void _valider(BuildContext context) {
    final nom  = _nomController.text.trim();
    final pays = _paysController.text.trim();

    if (nom.isEmpty || pays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir le nom et le pays.')),
      );
      return;
    }

    final temperature = double.tryParse(_temperatureController.text) ?? 0.0;
    final humidite    = int.tryParse(_humiditeController.text)        ?? 0;

    final nouvelleVille = Ville(
      nom:         nom,
      pays:        pays,
      temperature: temperature,
      condition:   _conditionChoisie, // ✅ _ ajouté
      humidite:    humidite,
    );

    context.read<VilleViewModel>().ajouterVille(nouvelleVille);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une ville'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: _nomController, // ✅ _
              decoration: InputDecoration(
                labelText: 'Nom de la ville',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            TextField(
              controller: _paysController, // ✅ _
              decoration: InputDecoration(
                labelText: 'Pays',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            TextField(
              controller: _temperatureController, // ✅ _
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Température (°C)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: _conditionChoisie, // ✅ value (pas initialValue) + _
              decoration: InputDecoration(
                labelText: 'Condition météo',
                border: OutlineInputBorder(),
              ),
              items: _conditions.map((condition) { // ✅ _conditions
                return DropdownMenuItem<String>(
                  value: condition,
                  child: Text(condition),
                );
              }).toList(),
              onChanged: (valeur) {
                setState(() {
                  _conditionChoisie = valeur!; // ✅ _
                });
              },
            ),
            SizedBox(height: 12),

            TextField(
              controller: _humiditeController, // ✅ _
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Humidité (%)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: Icon(Icons.check),
                label: Text('Ajouter la ville'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () => _valider(context),
              ),
            ),

          ],
        ),
      ),
    );
  }
}