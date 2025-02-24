import 'package:flutter/material.dart';
import 'database_helper.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<String> _shinies = [];

  @override
  void initState() {
    super.initState();
    _loadShinies();
  }

  // Carregar os Shinies do banco de dados
  void _loadShinies() async {
    final shinies = await _databaseHelper.getShinies();
    setState(() {
      _shinies = shinies.map((shiny) => shiny['name'] as String).toList();
    });
  }

  // Adicionar um novo Shiny
  void _addShiny(String shiny) async {
    if (shiny.isNotEmpty) {
      await _databaseHelper.insertShiny(shiny);
      _loadShinies(); // Recarregar a lista após adicionar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Biblioteca de Shinies')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _shinies.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_shinies[index]),
                  leading: const Icon(Icons.star, color: Colors.yellow),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Adicionar novo Shiny
                showDialog(
                  context: context,
                  builder: (context) {
                    String newShiny = '';
                    return AlertDialog(
                      title: const Text('Adicionar Novo Shiny'),
                      content: TextField(
                        onChanged: (value) {
                          newShiny = value;
                        },
                        decoration: const InputDecoration(hintText: 'Nome do Pokémon'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            _addShiny(newShiny);
                            Navigator.of(context).pop();
                          },
                          child: const Text('Adicionar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Adicionar Shiny'),
            ),
          ),
        ],
      ),
    );
  }
}
