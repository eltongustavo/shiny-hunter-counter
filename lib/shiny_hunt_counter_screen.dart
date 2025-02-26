import 'package:flutter/material.dart';
import 'package:shiny_counter/database_helper.dart';
import 'package:shiny_counter/shiny_hunt_item.dart';
import 'save_to_library_screen.dart'; // Importar a tela de salvar na biblioteca

class ShinyHuntCounterScreen extends StatefulWidget {
  @override
  _ShinyHuntCounterScreenState createState() => _ShinyHuntCounterScreenState();
}

class _ShinyHuntCounterScreenState extends State<ShinyHuntCounterScreen> {
  List<int> _huntIds = [];
  Map<int, int> _huntEncounters = {};
  Map<int, int?> _huntPokemons = {}; // Ajuste para permitir valores nulos
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
        for (var hunt in hunts) hunt['hunt_id'] as int: hunt['index_pokemon'] as int?
      };
      _isLoading = false;
    });
  }

  Future<void> _createNewHunt() async {
    final dbHelper = DatabaseHelper();
    await dbHelper.insertShinyHunt(1); // Inserir com índice fixo (pode ser alterado)
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
    });
  }

  // Função para atualizar o estado quando a hunt for salva
  void _onHuntSaved() {
    _loadHunts(); // Recarregar a lista de hunts
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
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ShinyHuntItem(
                      huntId: huntId,
                      encounters: _huntEncounters[huntId] ?? 0,
                      pokemonIndex: _huntPokemons[huntId] ?? 1,
                      onUpdateHunt: _updateHunt,
                      onDeleteHunt: () => _deleteHunt(huntId),
                      onHuntSaved: _onHuntSaved, // Passando a função de callback
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
