import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'database_helper.dart';

class ShinyHuntCounterScreen extends StatefulWidget {
  @override
  _ShinyHuntCounterScreenState createState() => _ShinyHuntCounterScreenState();
}

class _ShinyHuntCounterScreenState extends State<ShinyHuntCounterScreen> {
  List<int> _huntIds = [];
  Map<int, int> _huntEncounters = {};
  Map<int, String> _huntPokemons = {};
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
        for (var hunt in hunts) hunt['hunt_id'] as int: '1' // Definir Pokémon padrão
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
      _huntPokemons[newHuntId] = '1'; // Definir o primeiro Pokémon como padrão
    });
  }

  void _updateEncounters(int huntId, int encounters) async {
    final dbHelper = DatabaseHelper();
    await dbHelper.updateEncounters(huntId, encounters);
    setState(() {
      _huntEncounters[huntId] = encounters;
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
      appBar: AppBar(
        title: const Text('Shiny Hunt Counter'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _createNewHunt,
            child: Text('Adicionar Nova Hunt'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
              textStyle: TextStyle(fontSize: 18, color: Colors.white), // Cor da letra branca
              backgroundColor: Colors.black, // Fundo preto para combinar com o app
            ),
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _huntIds.isEmpty
                ? Center(child: Text('Não há Shiny Hunts'))
                : ListView.builder(
              itemCount: _huntIds.length,
              itemBuilder: (context, index) {
                final huntId = _huntIds[index];
                return ShinyHuntItem(
                  huntId: huntId,
                  encounters: _huntEncounters[huntId] ?? 0,
                  pokemonName: _huntPokemons[huntId] ?? '1',
                  onUpdateEncounters: _updateEncounters,
                  onPokemonSelected: (pokemonIndex) {
                    setState(() {
                      _huntPokemons[huntId] = pokemonIndex.toString();
                    });
                  },
                  onAddToLibrary: () {
                    print('Adicionando Hunt $huntId à biblioteca');
                  },
                  onDeleteHunt: () {
                    _showDeleteConfirmationDialog(context, huntId);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int huntId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmar Exclusão"),
          content: Text("Você tem certeza de que deseja excluir esta hunt?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deleteHunt(huntId);
              },
              child: Text("Excluir"),
            ),
          ],
        );
      },
    );
  }
}
class ShinyHuntItem extends StatefulWidget {
  final int huntId;
  final int encounters;
  final String pokemonName;
  final Function(int, int) onUpdateEncounters;
  final Function(int) onPokemonSelected;
  final VoidCallback onAddToLibrary;
  final VoidCallback onDeleteHunt;

  ShinyHuntItem({
    required this.huntId,
    required this.encounters,
    required this.pokemonName,
    required this.onUpdateEncounters,
    required this.onPokemonSelected,
    required this.onAddToLibrary,
    required this.onDeleteHunt,
  });

  @override
  _ShinyHuntItemState createState() => _ShinyHuntItemState();
}

class _ShinyHuntItemState extends State<ShinyHuntItem> {
  late String pokemonName;
  late Future<Widget> _pokemonImage;

  @override
  void initState() {
    super.initState();
    pokemonName = widget.pokemonName; // Armazenando o Pokémon selecionado
    _pokemonImage = _fetchPokemonImage(int.parse(pokemonName));
  }

  Future<Widget> _fetchPokemonImage(int pokemonIndex) async {
    final url = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/$pokemonIndex.png';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return Image.network(url);
      } else {
        return Image.asset('assets/no-internet.png', width: 100, height: 100);
      }
    } catch (e) {
      return Image.asset('assets/no-internet.png', width: 100, height: 100);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pokemonIndex = pokemonName.isNotEmpty ? int.tryParse(pokemonName) ?? 1 : 1;

    return FractionallySizedBox(
      alignment: Alignment.center,
      widthFactor: 0.7,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Exibe a imagem do Pokémon, carregada uma única vez
              FutureBuilder<Widget>(
                future: _pokemonImage,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else {
                    return snapshot.data ?? SizedBox.shrink();
                  }
                },
              ),
              SizedBox(height: 20),
              DropdownButton<int>(
                value: pokemonIndex == 0 ? null : pokemonIndex,
                hint: Text('Escolha um Pokémon'),
                items: List.generate(20, (index) {
                  return DropdownMenuItem<int>(
                    value: index + 1,
                    child: Text('Pokémon ${index + 1}'),
                  );
                }),
                onChanged: (newValue) {
                  if (newValue != null) {
                    setState(() {
                      pokemonName = newValue.toString();
                      // Recarrega a imagem apenas quando o Pokémon for alterado
                      _pokemonImage = _fetchPokemonImage(newValue);
                    });
                    widget.onPokemonSelected(newValue);
                  }
                },
              ),
              SizedBox(height: 20),
              Text(
                '${widget.encounters}',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Texto branco
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.remove, size: 80),
                    onPressed: () {
                      if (widget.encounters > 0) {
                        widget.onUpdateEncounters(widget.huntId, widget.encounters - 1);
                      }
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.add, size: 80),
                    onPressed: () {
                      widget.onUpdateEncounters(widget.huntId, widget.encounters + 1);
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: widget.onAddToLibrary,
                child: Text('Salvar Hunt'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  textStyle: TextStyle(fontSize: 18, color: Colors.white), // Texto branco
                  backgroundColor: Colors.black, // Fundo preto
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: widget.onDeleteHunt,
                child: Text('Excluir Hunt'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  textStyle: TextStyle(fontSize: 18, color: Colors.white), // Texto branco
                  backgroundColor: Colors.red, // Fundo vermelho para o botão Excluir
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


