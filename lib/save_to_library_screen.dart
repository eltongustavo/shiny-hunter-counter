import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shiny_counter/database_helper.dart';
import 'pokemon.dart';
import 'library_screen.dart';

class SaveToLibraryScreen extends StatefulWidget {
  final int pokemonIndex;
  final int encounters;
  final int huntId;
  final Function onHuntSaved;

  SaveToLibraryScreen({
    required this.pokemonIndex,
    required this.encounters,
    required this.huntId,
    required this.onHuntSaved,
  });

  @override
  _SaveToLibraryScreenState createState() => _SaveToLibraryScreenState();
}

class _SaveToLibraryScreenState extends State<SaveToLibraryScreen> {
  String? selectedGame;
  String? selectedMethod;
  List<String> pokemonsList = Pokemon.getPokemonList();
  List<String> gamesList = Pokemon.getGamesList();
  List<String> methodsList = Pokemon.getMethodsList();

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    String pokemonName = pokemonsList[widget.pokemonIndex - 1];
    return Scaffold(
      appBar: AppBar(title: Text("Salvar na Biblioteca")),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/${widget.pokemonIndex}.png',
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/no-internet.png',
                      width: 80,
                      height: 80,
                    );
                  },
                ),
                SizedBox(width: 20),
                Text(
                  pokemonName,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text("Encontros: ${widget.encounters}", style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 20),
            Text("Data do Encontro: $formattedDate", style: TextStyle(fontSize: 18, color: Colors.white)),
            SizedBox(height: 20),
            DropdownButton<String>(
              hint: Text("Selecione o jogo", style: TextStyle(color: Colors.white)),
              value: selectedGame,
              dropdownColor: Colors.black,
              style: TextStyle(color: Colors.white),
              items: gamesList.map((game) => DropdownMenuItem(
                value: game,
                child: Text(game, style: TextStyle(color: Colors.white)),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedGame = value;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              hint: Text("Selecione o método", style: TextStyle(color: Colors.white)),
              value: selectedMethod,
              dropdownColor: Colors.black,
              style: TextStyle(color: Colors.white),
              items: methodsList.map((method) => DropdownMenuItem(
                value: method,
                child: Text(method, style: TextStyle(color: Colors.white)),
              )).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () async {
                if (selectedGame == null || selectedMethod == null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Erro'),
                      content: const Text('Por favor, preencha todos os campos obrigatórios.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('OK'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  final pokemon = Pokemon(
                    pokemonName: pokemonName,
                    spriteUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/${widget.pokemonIndex}.png',
                    game: selectedGame!,
                    captureDate: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                    encounters: widget.encounters,
                    method: selectedMethod!,
                  );

                  // Salva o Pokémon no banco
                  await DatabaseHelper().insertPokemon(pokemon);

                  // Deleta a hunt do banco usando o huntId
                  await DatabaseHelper().deleteShinyHunt(widget.huntId);

                  // Chama a função de callback para atualizar a tela principal
                  widget.onHuntSaved();

                  // Redireciona para a tela da biblioteca
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LibraryScreen(successMessage: "$pokemonName adicionado com sucesso!"),
                    ),
                  );
                }
              },
              child: Text("Salvar na Biblioteca"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
