import 'package:flutter/foundation.dart';
 import '../models/ville.dart';

 class VilleViewModel extends ChangeNotifier {

 // La liste des villes disponibles
 List <Ville> _villes = [];


 // La ville actuellement selectionnee
 Ville? _villeSelectionnee ;

 // Getters ( la View lit ces proprietes )
 List<Ville> get villes => _villes ;
 Ville? get villeSelectionnee => _villeSelectionnee ;

 // Constructeur : charger des donnees au demarrage
 VilleViewModel () {
 _initialiser () ;
 }

 void _initialiser () {
 _villes = [
 Ville ( nom : ' Cotonou ' , pays : ' Benin ' , temperature :29 ,
condition : ' Ensoleille ' , humidite :75) ,
 Ville ( nom : ' Parakou ' , pays : ' Benin ' , temperature :32 ,
condition : ' Ensoleille ' , humidite :60) ,
 Ville ( nom : ' Lagos ' , pays : ' Nigeria ' , temperature :31 ,
condition : ' Nuageux ' , humidite :80) ,
 Ville ( nom : ' Abidjan ' , pays : ' CI ' , temperature :27 ,
condition : ' Pluvieux ' , humidite :85) ,
 Ville ( nom : ' Porto-Novo ' , pays : 'Benin' , temperature :36,
condition : ' Orageux ' , humidite :10) ,
 Ville ( nom : 'Tokyo' , pays : ' Japon' , temperature :27 ,
condition : ' Ventueux ' , humidite :70) ,
 ];
 _villeSelectionnee = _villes . first ;
 notifyListeners () ; // prevenir les widgets
 }

 // Changer la ville affichee
 void selectionnerVille ( Ville ville ) {
 _villeSelectionnee = ville ;
 notifyListeners () ;
 } 
  // NOUVEAU — Ajoute une ville à la liste et notifie les widgets
  void ajouterVille(Ville ville) {
    _villes.add(ville);   // on insère la ville dans la liste privée
    notifyListeners();    // tous les widgets abonnés se reconstruisent
  }
 }