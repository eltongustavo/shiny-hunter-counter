import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SaveToLibraryScreen extends StatefulWidget {
  final int pokemonIndex;
  final int encounters;

  SaveToLibraryScreen({required this.pokemonIndex, required this.encounters});

  @override
  _SaveToLibraryScreenState createState() => _SaveToLibraryScreenState();
}

class _SaveToLibraryScreenState extends State<SaveToLibraryScreen> {
  String? selectedGame;
  String? selectedMethod;

  final List<String> games = [
    "Red/Blue",
    "Gold/Silver",
    "Ruby/Sapphire",
    "Diamond/Pearl",
    "Black/White",
    "X/Y",
    "Sun/Moon",
    "Sword/Shield",
    "Scarlet/Violet"
  ];

  final List<String> methods = [
    "Random Encounter",
    "Masuda Method",
    "SOS Battle",
    "PokéRadar",
    "DexNav",
    "Chain Fishing",
    "Dynamax Adventure",
    "Outbreak Hunting",
    "Other"
  ];

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

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
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    // Retorna a imagem local no caso de erro de carregamento
                    return Image.asset(
                      'assets/no-internet.png',
                      width: 80,
                      height: 80,
                    );
                  },
                ),

                SizedBox(width: 20),
                Text(
                  "Pokémon ${widget.pokemonIndex}",
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
              items: games.map((game) => DropdownMenuItem(
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
              items: methods.map((method) => DropdownMenuItem(
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
              onPressed: () {
                // Aqui você pode salvar os dados no banco ou exibir uma confirmação
                Navigator.pop(context);
              },
              child: Text("Salvar"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
