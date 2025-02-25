import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'shiny_hunt_item.dart';

class ShinyHuntCounterScreen extends StatefulWidget {
  @override
  _ShinyHuntCounterScreenState createState() => _ShinyHuntCounterScreenState();
}

class _ShinyHuntCounterScreenState extends State<ShinyHuntCounterScreen> {
  List<int> _huntIds = [];
  Map<int, int> _huntEncounters = {};
  Map<int, int> _huntPokemons = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHunts();
  }

  void _loadHunts() async {
    final dbHelper = DatabaseHelper();
    final hunts = await dbHelper.getAllShinyHunts();

    setState(() {
      _huntIds = hunts.map((hunt) => hunt['hunt_id'] as int).toList();
      _huntEncounters = {
        for (var hunt in hunts) hunt['hunt_id'] as int: hunt['encounters'] as int
      };
      _huntPokemons = {
        for (var hunt in hunts) hunt['hunt_id'] as int: hunt['index_pokemon'] as int
      };
      _isLoading = false;
    });
  }

  void _createNewHunt() async {
    final dbHelper = DatabaseHelper();
    int newHuntId = _huntIds.isEmpty ? 1 : (_huntIds.last + 1);
    await dbHelper.insertShinyHunt(newHuntId);
    setState(() {
      _huntIds.add(newHuntId);
      _huntEncounters[newHuntId] = 0;
      _huntPokemons[newHuntId] = 1;
    });
  }

  void _updateHunt(int huntId, int encounters, int pokemonIndex) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.updateShinyHunt(huntId, encounters, pokemonIndex);
    setState(() {
      _huntEncounters[huntId] = encounters;
      _huntPokemons[huntId] = pokemonIndex;
    });
  }

  void _deleteHunt(int huntId) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.deleteShinyHunt(huntId);
    setState(() {
      _huntIds.remove(huntId);
      _huntEncounters.remove(huntId);
      _huntPokemons.remove(huntId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Shiny Hunt Counter'),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _createNewHunt,
            child: Text('Adicionar Nova Hunt'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _huntIds.isEmpty
                ? Center(child: Text('Não há Shiny Hunts', style: TextStyle(color: Colors.white)))
                : ListView.builder(
              itemCount: _huntIds.length,
              itemBuilder: (context, index) {
                final huntId = _huntIds[index];
                return ShinyHuntItem(
                  huntId: huntId,
                  encounters: _huntEncounters[huntId] ?? 0,
                  pokemonIndex: _huntPokemons[huntId] ?? 1,
                  onUpdateHunt: _updateHunt,
                  onDeleteHunt: () => _deleteHunt(huntId),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
