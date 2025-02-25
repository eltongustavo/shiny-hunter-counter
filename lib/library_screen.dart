import 'package:flutter/material.dart';
import 'package:shiny_counter/database_helper.dart';
import 'package:intl/intl.dart';
import 'pokemon.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<List<Map<String, dynamic>>> _pokemonList;

  @override
  void initState() {
    super.initState();
    _pokemonList = _loadPokemonList();
  }

  // Função para carregar a lista de Pokémon do banco de dados
  Future<List<Map<String, dynamic>>> _loadPokemonList() async {
    return await DatabaseHelper().getAllPokemon(); // Carrega a lista de Pokémon do banco de dados
  }

  // Função para atualizar a lista de Pokémon
  void _updatePokemonList() {
    setState(() {
      _pokemonList = _loadPokemonList(); // Recarrega a lista com o banco atualizado
    });
  }

  // Função para excluir um Pokémon com confirmação
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
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                await DatabaseHelper().deletePokemon(id); // Exclui o Pokémon
                _updatePokemonList(); // Atualiza a lista após a exclusão
                Navigator.of(context).pop(); // Fecha o diálogo
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
      body: FutureBuilder<List<Map<String, dynamic>>>(  // Espera os dados da lista de Pokémon
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
                return ListTile(
                  title: Text(pokemon['pokemon_name'] ?? 'Desconhecido'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jogo: ${pokemon['game'] ?? 'Desconhecido'}'),
                      Text('Data de captura: ${pokemon['capture_date'] ?? 'Desconhecida'}'),
                      Text('Encontros: ${pokemon['encounters'] ?? 0}'),
                      Text('Método: ${pokemon['method'] ?? 'Desconhecido'}'),
                    ],
                  ),
                  leading: pokemon['sprite_url'] != null && pokemon['sprite_url']!.isNotEmpty
                      ? Image.network(
                    pokemon['sprite_url']!,
                    width: 100,  // Ajuste o tamanho conforme necessário
                    height: 100,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;  // Imagem carregada com sucesso
                      } else {
                        return const CircularProgressIndicator();  // Enquanto a imagem carrega
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      // Se falhar ao carregar, exibe a imagem padrão de assets
                      return Image.asset('assets/no-internet.png', width: 100, height: 100);
                    },
                  )
                      : const Icon(Icons.image_not_supported),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      // Exibe a confirmação antes de excluir
                      _confirmDeletePokemon(pokemon['id']);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
      // Botão de "+" para adicionar um novo Pokémon
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navega para a tela de adicionar novo Pokémon
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPokemonScreen(
                updatePokemonList: _updatePokemonList,
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

class AddPokemonScreen extends StatefulWidget {
  final Function updatePokemonList;

  const AddPokemonScreen({required this.updatePokemonList, Key? key}) : super(key: key);

  @override
  _AddPokemonScreenState createState() => _AddPokemonScreenState();
}

class _AddPokemonScreenState extends State<AddPokemonScreen> {
  final TextEditingController _captureDateController = TextEditingController();
  final TextEditingController _encountersController = TextEditingController();

  // Listas para os dropdowns (com alguns exemplos)
  List<String> _pokemonList = [
    'Bulbasaur', 'Ivysaur', 'Venusaur', 'Charmander', 'Charmeleon', 'Charizard',
    'Squirtle', 'Wartortle', 'Blastoise', 'Caterpie', 'Metapod', 'Butterfree',
    'Weedle', 'Kakuna', 'Beedrill', 'Pidgey', 'Pidgeotto', 'Pidgeot', 'Rattata',
    'Raticate', 'Spearow', 'Fearow', 'Ekans', 'Arbok', 'Pikachu', 'Raichu',
    'Sandshrew', 'Sandslash', 'Nidoran♀', 'Nidorina', 'Nidoqueen', 'Nidoran♂',
    'Nidorino', 'Nidoking', 'Clefairy', 'Clefable', 'Vulpix', 'Ninetales',
    'Jigglypuff', 'Wigglytuff', 'Zubat', 'Golbat', 'Oddish', 'Gloom', 'Vileplume',
    'Paras', 'Parasect', 'Venonat', 'Venomoth', 'Diglett', 'Dugtrio', 'Meowth',
    'Persian', 'Psyduck', 'Golduck','Mankey','Primeape','Growlite','Arcanine','Poliwag'
    ,'Poliwhirl' ,'Poliwhath','Abra','Kadabra','Alakazam', 'Machop', 'Machoke',
    'Machamp', 'Bellsprout', 'Weepinbell', 'Victreebel', 'Tentacool', 'Tentacruel',
    'Geodude', 'Graveler', 'Golem', 'Ponyta', 'Rapidash', 'Slowpoke', 'Slowbro',
    'Magnemite', 'Magneton','Farfechtd´d','Doduo','Dodrio','Seel','Dewgong',
    'Grimer','Muk','Shellder','Cloyster','Gastly','Haunter', 'Gengar','Onix','Drowzee',
    'Hypno', 'Krabby', 'Kingler','Voltorb','Electrode','Exeggcute', 'Exeggutor', 'Cubone',
    'Marowak', 'Hitmonlee', 'Hitmonchan', 'Lickitung', 'Koffing', 'Weezing', 'Rhyhorn',
    'Rhydon', 'Chansey', 'Tangela', 'Kangaskhan', 'Horsea', 'Seadra', 'Goldeen',
    'Seaking', 'Staryu', 'Starmie', 'Mr. Mime', 'Scyther','Jynx', 'Electabuzz', 'Magmar',
    'Pinsir', 'Tauros', 'Magikarp', 'Gyarados', 'Lapras', 'Ditto', 'Eevee',
    'Vaporeon', 'Jolteon', 'Flareon', 'Porygon', 'Omanyte', 'Omastar', 'Kabuto',
    'Kabutops', 'Aerodactyl','Snorlax','Articuno','Zapdos','Moltres'
    ,'Dratini','Dragonair','Dragonite', 'Mewtwo', 'Mew',
  ];

  List<String> _gameList = [
    'Pokémon Red', 'Pokémon Blue', 'Pokémon Green', 'Pokémon Yellow', 'Pokémon Gold',
    'Pokémon Silver', 'Pokémon Crystal', 'Pokémon Ruby', 'Pokémon Sapphire', 'Pokémon Emerald',
    'Pokémon FireRed', 'Pokémon LeafGreen', 'Pokémon Diamond', 'Pokémon Pearl', 'Pokémon Platinum',
    'Pokémon HeartGold', 'Pokémon SoulSilver', 'Pokémon Black', 'Pokémon White', 'Pokémon Black 2',
    'Pokémon White 2', 'Pokémon X', 'Pokémon Y', 'Pokémon Omega Ruby', 'Pokémon Alpha Sapphire',
    'Pokémon Sun', 'Pokémon Moon', 'Pokémon Ultra Sun', 'Pokémon Ultra Moon', "Pokémon Let's Go Pikachu",
    "Pokémon Let's Go Eevee", 'Pokémon Sword', 'Pokémon Shield', 'Pokémon Brilliant Diamond',
    'Pokémon Shining Pearl', 'Pokémon Scarlet', 'Pokémon Violet',
  ];

  List<String> _methodList = ['Shiny Charm', 'Masuda Method', 'SOS Method', 'Random Encounter'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Novo Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: <Widget>[
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Pokémon'),
                items: _pokemonList.map((String pokemon) {
                  return DropdownMenuItem<String>(
                    value: pokemon,
                    child: Text(pokemon),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Jogo'),
                items: _gameList.map((String game) {
                  return DropdownMenuItem<String>(
                    value: game,
                    child: Text(game),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              TextFormField(
                controller: _captureDateController,
                decoration: const InputDecoration(labelText: 'Data de Captura'),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (picked != null && picked != DateTime.now()) {
                    setState(() {
                      _captureDateController.text = DateFormat('yyyy-MM-dd').format(picked);
                    });
                  }
                },
              ),
              TextFormField(
                controller: _encountersController,
                decoration: const InputDecoration(labelText: 'Encontros'),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Método'),
                items: _methodList.map((String method) {
                  return DropdownMenuItem<String>(
                    value: method,
                    child: Text(method),
                  );
                }).toList(),
                onChanged: (value) {},
              ),
              ElevatedButton(
                onPressed: () async {
                  // Verifique o nome do Pokémon de maneira correta, assumindo que você queira pegar o primeiro Pokémon da lista
                  final pokemonName = _pokemonList.isNotEmpty ? _pokemonList.first : ''; // Evitar erro caso a lista esteja vazia
                  final game = _gameList.isNotEmpty ? _gameList.first : ''; // Evitar erro caso a lista esteja vazia
                  final captureDate = _captureDateController.text;
                  final method = _methodList.isNotEmpty ? _methodList.first : ''; // Evitar erro caso a lista esteja vazia
                  int encounters = 0;

                  // Verificar se a conversão para inteiro foi bem-sucedida
                  try {
                    encounters = int.parse(_encountersController.text);
                  } catch (e) {
                    print('Erro ao converter o número de encontros: $e');
                    return; // Retorna caso o valor seja inválido
                  }

                  // Gerando o índice do Pokémon com base na lista de nomes
                  final pokemonIndex = _pokemonList.indexOf(pokemonName.toLowerCase()) + 1; // +1 para corresponder ao índice na URL
                  if (pokemonIndex == 0) {
                    // Caso o Pokémon não seja encontrado na lista, use um índice de fallback
                    print('Pokémon não encontrado na lista');
                    return;
                  }

                  // Criando a URL do sprite com base no índice
                  final spriteUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/$pokemonIndex.png';

                  // Criando o objeto para o novo Pokémon com base nos dados
                  final newPokemon = Pokemon(
                    pokemonName: pokemonName,
                    spriteUrl: spriteUrl,
                    game: game,
                    captureDate: captureDate,
                    encounters: encounters,
                    method: method,
                  );

                  // Inserindo o Pokémon no banco de dados
                  await DatabaseHelper().insertPokemon(newPokemon);
                  widget.updatePokemonList(); // Atualiza a lista no widget principal
                  Navigator.pop(context);
                },
                child: const Text('Adicionar'),
              )




            ],
          ),
        ),
      ),
    );
  }
}
