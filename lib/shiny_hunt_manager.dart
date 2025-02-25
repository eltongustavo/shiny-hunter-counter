import 'package:flutter/material.dart';
import 'database_helper.dart';

class ShinyHuntManager extends ChangeNotifier {
  List<int> _huntIds = [];
  Map<int, int> _huntEncounters = {};
  Map<int, int> _huntPokemons = {};
  bool _isLoading = true;

  List<int> get huntIds => _huntIds;
  Map<int, int> get huntEncounters => _huntEncounters;
  Map<int, int> get huntPokemons => _huntPokemons;
  bool get isLoading => _isLoading;

  final dbHelper = DatabaseHelper();

  ShinyHuntManager() {
    _loadHunts();
  }

  Future<void> _loadHunts() async {
    final hunts = await dbHelper.getAllShinyHunts();
    _huntIds = hunts.map((hunt) => hunt['hunt_id'] as int).toList();
    _huntEncounters = {
      for (var hunt in hunts) hunt['hunt_id'] as int: hunt['encounters'] as int
    };
    _huntPokemons = {
      for (var hunt in hunts) hunt['hunt_id'] as int: hunt['index_pokemon'] as int
    };
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createNewHunt() async {
    int newHuntId = _huntIds.isEmpty ? 1 : (_huntIds.last + 1);
    await dbHelper.insertShinyHunt(newHuntId);
    _huntIds.add(newHuntId);
    _huntEncounters[newHuntId] = 0;
    _huntPokemons[newHuntId] = 1;
    notifyListeners();
  }

  Future<void> updateHunt(int huntId, int encounters, int pokemonIndex) async {
    await dbHelper.updateShinyHunt(huntId, encounters, pokemonIndex);
    _huntEncounters[huntId] = encounters;
    _huntPokemons[huntId] = pokemonIndex;
    notifyListeners();
  }

  Future<void> deleteHunt(int huntId) async {
    await dbHelper.deleteShinyHunt(huntId);
    _huntIds.remove(huntId);
    _huntEncounters.remove(huntId);
    _huntPokemons.remove(huntId);
    notifyListeners();
  }
}
