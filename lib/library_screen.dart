import 'package:flutter/material.dart';
import 'package:shiny_counter/database_helper.dart';
import 'package:intl/intl.dart';

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
    return await DatabaseHelper().getAllPokemon();
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
                await DatabaseHelper().deletePokemon(id);
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
                      Text('Encontros: ${pokemon['resets'] ?? 0}'),
                      Text('Método: ${pokemon['method'] ?? 'Desconhecido'}'),
                    ],
                  ),
                  leading: pokemon['sprite_url'] != null && pokemon['sprite_url']!.isNotEmpty
                      ? Image.network(pokemon['sprite_url'])
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
  final TextEditingController _resetsController = TextEditingController();

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
    // Johto Pokémon 152-251
  ];

  List<String> _gameList = [
    'Pokémon Red', 'Pokémon Blue', 'Pokémon Green', 'Pokémon Yellow', 'Pokémon Gold',
    'Pokémon Silver', 'Pokémon Crystal', 'Pokémon Ruby', 'Pokémon Sapphire', 'Pokémon Emerald',
    'Pokémon FireRed', 'Pokémon LeafGreen', 'Pokémon Diamond', 'Pokémon Pearl', 'Pokémon Platinum',
    'Pokémon HeartGold', 'Pokémon SoulSilver', 'Pokémon Black', 'Pokémon White', 'Pokémon Black 2',
    'Pokémon White 2', 'Pokémon X', 'Pokémon Y', 'Pokémon Omega Ruby', 'Pokémon Alpha Sapphire',
    'Pokémon Sun', 'Pokémon Moon', 'Pokémon Ultra Sun', 'Pokémon Ultra Moon', "Pokémon Let's Go Pikachu",
    "Pokémon Let's Go Eevee", 'Pokémon Sword', 'Pokémon Shield', 'Pokémon Brilliant Diamond',
    'Pokémon Shining Pearl', 'Pokémon Legends: Arceus', 'Pokémon Scarlet', 'Pokémon Violet',
    // Adicione mais jogos aqui
  ];

  List<String> _methodList = [
    'Battle Method', 'Breeding', 'Catch Combo', 'Chain Fishing', 'DexNav', 'Dynamax Adventures',
    'Event', 'Field Research', 'Fossil Restore', 'Friend Safari', 'Horde Hunting', 'Island Scan',
    'Masuda Method', 'Mystery Gift', 'Outbreak Method', 'Poké Pelago', 'Pokéradar', 'Raid Battle',
    'Random Encounter', 'Run Away', 'SOS Calling', 'Soft Resetting', 'Tera Raid', 'Trade',
    'Ultra Wormhole', 'Wonder Trade',
    // Adicione mais métodos de hunt aqui
  ];

  String? _selectedPokemon;
  String? _selectedGame;
  String? _selectedMethod;

  void _savePokemon() async {
    if (_selectedPokemon == null || _selectedGame == null || _selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, preencha todos os campos!')),
      );
      return;
    }

    // Validação da Data de Captura
    String captureDate = _captureDateController.text;
    try {
      DateFormat("dd/MM/yyyy").parseStrict(captureDate);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira uma data válida no formato dd/MM/yyyy!')),
      );
      return;
    }

    // Obtém o índice do Pokémon na lista
    int spriteIndex = _pokemonList.indexOf(_selectedPokemon!);
    String spriteUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/$spriteIndex.png';  // Modifique a base da URL conforme necessário

    // Verifica se o campo de encontros está vazio ou contém um valor inválido
    print("Valor de Encontros: ${_resetsController.text}");

    int resets = _resetsController.text.isNotEmpty
        ? int.tryParse(_resetsController.text) ?? 0
        : 0;

    // Aqui, o valor de resets agora é um inteiro, e será o valor exato preenchido no campo
    print("Valor de Encontros (resets): $resets");

    final newPokemon = {
      'pokemon_name': _selectedPokemon!,
      'game': _selectedGame!,
      'capture_date': captureDate,
      'resets': resets,  // O valor de resets já foi transformado em inteiro
      'method': _selectedMethod!,
      'sprite_url': spriteUrl,  // Usa a URL gerada automaticamente
    };

    // Adiciona o Pokémon ao banco de dados
    await DatabaseHelper().insertNewPokemon(newPokemon);

    // Atualiza a lista na tela anterior
    widget.updatePokemonList();

    // Volta para a tela anterior
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Novo Pokémon')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Dropdown para selecionar Pokémon
            DropdownButton<String>(
              hint: const Text('Escolha o Pokémon'),
              value: _selectedPokemon,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedPokemon = newValue;
                });
              },
              items: _pokemonList.map<DropdownMenuItem<String>>((String pokemon) {
                return DropdownMenuItem<String>(
                  value: pokemon,
                  child: Text(pokemon),
                );
              }).toList(),
            ),
            // Dropdown para selecionar o jogo
            DropdownButton<String>(
              hint: const Text('Escolha o Jogo'),
              value: _selectedGame,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGame = newValue;
                });
              },
              items: _gameList.map<DropdownMenuItem<String>>((String game) {
                return DropdownMenuItem<String>(
                  value: game,
                  child: Text(game),
                );
              }).toList(),
            ),
            // Dropdown para selecionar o método
            DropdownButton<String>(
              hint: const Text('Escolha o Método'),
              value: _selectedMethod,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedMethod = newValue;
                });
              },
              items: _methodList.map<DropdownMenuItem<String>>((String method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
            ),
            TextField(
              controller: _captureDateController,
              decoration: const InputDecoration(labelText: 'Data de Captura'),
            ),
            TextField(
              controller: _resetsController,
              decoration: const InputDecoration(labelText: 'Resets'),
              keyboardType: TextInputType.number,
            ),
            // O campo de sprite_url será preenchido automaticamente
            // Não é necessário exibir para o usuário
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _savePokemon,  // Salva o Pokémon no banco de dados
              child: const Text('Salvar Pokémon'),
            ),
          ],
        ),
      ),
    );
  }
}
