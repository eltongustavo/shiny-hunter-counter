import 'package:flutter/material.dart';
import 'package:shiny_counter/database_helper.dart';
import 'pokemon_list_item.dart';  // Importa a classe que criamos para os itens
import 'add_new_pokemon.dart';  // Importa a classe do formulário
import 'pokemon.dart';

class LibraryScreen extends StatefulWidget {
  final String? successMessage;  // Adiciona o parâmetro para mensagem de sucesso

  const LibraryScreen({Key? key, this.successMessage}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Map<String, dynamic>>> _pokemonList;

  List<String> pokemonsList = Pokemon.getPokemonList();
  List<String> gamesList = Pokemon.getGamesList();
  List<String> methodsList = Pokemon.getMethodsList();

  @override
  void initState() {
    super.initState();
    _pokemonList = _loadPokemonList();
  }

  Future<List<Map<String, dynamic>>> _loadPokemonList() async {
    return await DatabaseHelper().getAllPokemon();
  }

  void _updatePokemonList() {
    setState(() {
      _pokemonList = _loadPokemonList();
    });
  }

  void _confirmDeletePokemon(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content: const Text('Tem certeza que deseja excluir este Pokémon?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                await DatabaseHelper().deletePokemon(id);
                _updatePokemonList();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca de Pokémon')),
      body: Column(
        children: [
          if (widget.successMessage != null)
            Container(
              padding: EdgeInsets.all(10),
              color: Colors.green,
              child: Text(
                widget.successMessage!,
                style: TextStyle(color: Colors.white),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(  // Carrega a lista de Pokémon
              future: _pokemonList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Erro ao carregar os dados.'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhum Pokémon encontrado.'));
                } else {
                  final pokemonList = snapshot.data!;
                  return ListView.builder(
                    itemCount: pokemonList.length,
                    itemBuilder: (context, index) {
                      final pokemon = pokemonList[index];
                      return PokemonListItem(
                        pokemon: pokemon,
                        onDelete: (int id) {
                          _confirmDeletePokemon(id);
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Scaffold(
                appBar: AppBar(title: const Text('Adicionar Pokémon')),
                body: AddNewPokemon(
                    updatePokemonList: _updatePokemonList,
                    pokemonListData: pokemonsList,
                    gameListData: gamesList
                ),
              ),
            ),
          );
        },
        tooltip: 'Adicionar Pokémon',
        child: const Icon(Icons.add),
      ),
    );
  }
}
