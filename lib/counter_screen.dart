import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _count = 0;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  String _selectedPokemon = 'Bulbasaur';
  String _pokemonSprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png";
  String _selectedGame = 'Pokémon Sword';
  String _selectedMethod = 'Random Encounter';
  String _captureDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

  final List<String> _pokemons = [

    //Kanto Pokémon 01-151
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

    //Johto Pokémon 152-251
  ];


  final List<String> _games = [
    'Pokémon Red',
    'Pokémon Blue',
    'Pokémon Green',
    'Pokémon Yellow',
    'Pokémon Gold',
    'Pokémon Silver',
    'Pokémon Crystal',
    'Pokémon Ruby',
    'Pokémon Sapphire',
    'Pokémon Emerald',
    'Pokémon FireRed',
    'Pokémon LeafGreen',
    'Pokémon Diamond',
    'Pokémon Pearl',
    'Pokémon Platinum',
    'Pokémon HeartGold',
    'Pokémon SoulSilver',
    'Pokémon Black',
    'Pokémon White',
    'Pokémon Black 2',
    'Pokémon White 2',
    'Pokémon X',
    'Pokémon Y',
    'Pokémon Omega Ruby',
    'Pokémon Alpha Sapphire',
    'Pokémon Sun',
    'Pokémon Moon',
    'Pokémon Ultra Sun',
    'Pokémon Ultra Moon',
    "Pokémon Let's Go Pikachu",
    "Pokémon Let's Go Eevee",
    'Pokémon Sword',
    'Pokémon Shield',
    'Pokémon Brilliant Diamond',
    'Pokémon Shining Pearl',
    'Pokémon Legends: Arceus',
    'Pokémon Scarlet',
    'Pokémon Violet',

    // Adicione mais jogos aqui
  ];

  final List<String> _methods = [
    'Battle Method',
    'Breeding',
    'Catch Combo',
    'Chain Fishing',
    'DexNav',
    'Dynamax Adventures',
    'Event',
    'Field Research',
    'Fossil Restore',
    'Friend Safari',
    'Horde Hunting',
    'Island Scan',
    'Masuda Method',
    'Mystery Gift',
    'Outbreak Method',
    'Poké Pelago',
    'Pokéradar',
    'Raid Battle',
    'Random Encounter',
    'Run Away',
    'SOS Calling',
    'Soft Resetting',
    'Tera Raid',
    'Trade',
    'Ultra Wormhole',
    'Wonder Trade',
    // Adicione mais métodos de hunt aqui
  ];

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  void _loadCounter() async {
    _count = await _databaseHelper.getCounter();
    setState(() {});
  }

  void _resetCounter() async {
    setState(() {
      _count = 0;
    });
    await _databaseHelper.updateCounter(_count);  // Atualiza o contador no banco de dados
  }

  void _increment() async {
    setState(() {
      _count++;
    });
    await _databaseHelper.updateCounter(_count);
  }

  void _decrement() async {
    if (_count > 0) {
      setState(() {
        _count--;
      });
      await _databaseHelper.updateCounter(_count);
    }
  }

  void _onPokemonChanged(String? pokemon) {
    setState(() {
      _selectedPokemon = pokemon ?? 'Bulbasaur';
      // Zera o contador após adicionar o Pokémon
      _resetCounter();
      _pokemonSprite = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/${_pokemons.indexOf(_selectedPokemon) + 1}.png";
    });
  }

  void _addToLibrary() async {
    // Exibe um diálogo para confirmar o que está sendo adicionado
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Adicionar à Biblioteca"),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        _pokemonSprite,
                        width: 80,
                        height: 80,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _selectedPokemon,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Encontros: $_count',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: _selectedGame,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGame = newValue!;
                      });
                    },
                    items: _games.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  DropdownButton<String>(
                    value: _selectedMethod,
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedMethod = newValue!;
                      });
                    },
                    items: _methods.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Shiny encontrado em:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _captureDate,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  // Verifica se todos os campos estão preenchidos
                  if (_selectedPokemon.isEmpty || _selectedGame.isEmpty || _captureDate.isEmpty || _selectedMethod.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Por favor, preencha todos os campos.')),
                    );
                    Navigator.pop(context);
                    return;
                  }

                  // Log para depuração
                  print('Adicionando Pokémon à biblioteca...');
                  print('Pokémon: $_selectedPokemon');
                  print('Jogo: $_selectedGame');
                  print('Método: $_selectedMethod');
                  print('Data: $_captureDate');
                  print('Encontros: $_count');

                  // Inserir o Pokémon no banco de dados
                  await _databaseHelper.insertPokemon(
                    pokemonName: _selectedPokemon,
                    spriteUrl: _pokemonSprite,
                    game: _selectedGame,
                    captureDate: _captureDate,
                    resets: _count,
                    method: _selectedMethod,  // Método de encontro
                  );

                  // Zera o contador após adicionar o Pokémon
                  _resetCounter();

                  // Exibe uma mensagem confirmando a adição
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pokémon adicionado à biblioteca!')),
                  );

                  // Fecha o diálogo
                  Navigator.pop(context);
                },
                child: const Text("Adicionar"),
              ),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contador de Encontros')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: _selectedPokemon,
                  onChanged: _onPokemonChanged,
                  items: _pokemons.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 20),
                Image.network(
                  _pokemonSprite,
                  width: 100,
                  height: 100,
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text('Encontros:', style: Theme.of(context).textTheme.titleLarge),
            Text('$_count', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 60)),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _decrement,
                  iconSize: 50,
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _increment,
                  iconSize: 50,
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: _addToLibrary,
              child: const Text("Adicionar à Biblioteca"),
            ),
          ],
        ),
      ),
    );
  }
}
