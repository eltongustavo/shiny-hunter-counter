import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shiny_counter/database_helper.dart';
import 'pokemon.dart';

class AddNewPokemon extends StatefulWidget {
  final Function updatePokemonList;
  final List<String> pokemonListData;
  final List<String> gameListData;

  const AddNewPokemon({required this.updatePokemonList, required this.pokemonListData, required this.gameListData, Key? key}) : super(key: key);

  @override
  _AddNewPokemonState createState() => _AddNewPokemonState();
}

class _AddNewPokemonState extends State<AddNewPokemon> {
  final TextEditingController _captureDateController = TextEditingController();
  final TextEditingController _encountersController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  String? selectedPokemon;
  String? selectedGame;
  String? selectedMethod = 'Random Encounter';
  List<String> methodsList = Pokemon.getMethodsList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Pokémon')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Pokémon'),
                    items: widget.pokemonListData.map((String pokemon) {
                      return DropdownMenuItem<String>(
                        value: pokemon,
                        child: Text(pokemon),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedPokemon = value;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Escolha um Pokémon' : null,
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Jogo'),
                    items: widget.gameListData.map((String game) {
                      return DropdownMenuItem<String>(
                        value: game,
                        child: Text(game),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGame = value;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Escolha um Jogo' : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _captureDateController,
                    decoration: const InputDecoration(labelText: 'Data de Captura (dd/MM/yyyy)'),
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != DateTime.now()) {
                        setState(() {
                          _captureDateController.text = DateFormat('dd/MM/yyyy').format(picked);
                        });
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe a data de captura';
                      }
                      try {
                        DateFormat('dd/MM/yyyy').parseStrict(value);
                        return null;
                      } catch (e) {
                        return 'Data inválida, use o formato dd/MM/yyyy';
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _encountersController,
                    decoration: const InputDecoration(labelText: 'Encontros'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Informe o número de encontros';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Insira um número válido';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Método'),
                    items: methodsList.map((String method) {
                      return DropdownMenuItem<String>(
                        value: method,
                        child: Text(method),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedMethod = value;
                      });
                    },
                    validator: (value) => value == null || value.isEmpty ? 'Escolha um Método' : null,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final captureDate = _captureDateController.text;
                        int encounters = int.parse(_encountersController.text);

                        final pokemonIndex = widget.pokemonListData.indexOf(selectedPokemon!) + 1;
                        final spriteUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/$pokemonIndex.png';

                        final newPokemon = Pokemon(
                          pokemonName: selectedPokemon!,
                          spriteUrl: spriteUrl,
                          game: selectedGame!,
                          captureDate: captureDate,
                          encounters: encounters,
                          method: selectedMethod!,
                        );

                        await DatabaseHelper().insertPokemon(newPokemon);
                        widget.updatePokemonList();
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Adicionar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
