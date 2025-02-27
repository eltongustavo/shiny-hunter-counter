import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shiny_counter/database_helper.dart';
import 'package:shiny_counter/shiny_hunt_item.dart';
import 'save_to_library_screen.dart';

class ShinyHuntCounterScreen extends StatefulWidget {
  @override
  _ShinyHuntCounterScreenState createState() => _ShinyHuntCounterScreenState();
}

class _ShinyHuntCounterScreenState extends State<ShinyHuntCounterScreen> {
  List<int> _huntIds = [];
  Map<int, int> _huntEncounters = {};
  Map<int, int?> _huntPokemons = {};
  bool _isLoading = true;
  int? _activeHuntId;

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
        for (var hunt in hunts) hunt['hunt_id'] as int: hunt['index_pokemon'] as int?
      };
      _isLoading = false;
    });
  }

  Future<void> _createNewHunt() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.insertShinyHunt(1);
    _loadHunts();
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
      if (_activeHuntId == huntId) {
        _activeHuntId = null;
      }
    });
  }

  void _onHuntSaved() {
    _loadHunts();
  }

  void _handleKeyPress(RawKeyEvent event) {
    if (_activeHuntId == null || event is! RawKeyDownEvent) return;
    if (event.logicalKey == LogicalKeyboardKey.space) {
      _updateHunt(_activeHuntId!, (_huntEncounters[_activeHuntId!] ?? 0) + 1, _huntPokemons[_activeHuntId!] ?? 1);
    } else if (event.logicalKey == LogicalKeyboardKey.backspace) {
      if ((_huntEncounters[_activeHuntId!] ?? 0) > 0) {
        _updateHunt(_activeHuntId!, (_huntEncounters[_activeHuntId!] ?? 0) - 1, _huntPokemons[_activeHuntId!] ?? 1);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Shiny Hunt Counter'),
        backgroundColor: Colors.black,
      ),
      body: RawKeyboardListener(
        focusNode: FocusNode(),
        autofocus: true,
        onKey: _handleKeyPress,
        child: Column(
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
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _activeHuntId = huntId;
                      });
                    },
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ShinyHuntItem(
                          huntId: huntId,
                          encounters: _huntEncounters[huntId] ?? 0,
                          pokemonIndex: _huntPokemons[huntId] ?? 1,
                          onUpdateHunt: _updateHunt,
                          onDeleteHunt: () => _deleteHunt(huntId),
                          onHuntSaved: _onHuntSaved,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
