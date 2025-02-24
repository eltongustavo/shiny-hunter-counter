import 'package:flutter/material.dart';
import 'package:shiny_counter/database_helper.dart';

class LibraryScreen extends StatelessWidget {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biblioteca de Shinies')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _databaseHelper.getAllPokemon(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum Pokémon na biblioteca'));
          }

          List<Map<String, dynamic>> pokemonList = snapshot.data!;

          return ListView.builder(
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              var pokemon = pokemonList[index];
              return ListTile(
                leading: Image.network(pokemon['sprite_url']),
                title: Text(pokemon['pokemon_name']),
                subtitle: Text('Jogo: ${pokemon['game']}, Resets: ${pokemon['resets']}'),
                trailing: Text('Capturado: ${pokemon['date']}'),
              );
            },
          );
        },
      ),
    );
  }
}
