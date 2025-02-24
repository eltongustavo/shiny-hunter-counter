import 'package:flutter/material.dart';
import 'database_helper.dart';

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int _count = 0;
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  String _selectedPokemon = 'Bulbasaur'; // Pokémon padrão
  String _pokemonSprite = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png'; // Sprite do Bulbasaur
  String _selectedGame = 'Pokémon Sword'; // Jogo padrão
  String _selectedMethod = 'Masuda Method'; // Método padrão

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

  // Carregar o contador do banco de dados
  void _loadCounter() async {
    _count = await _databaseHelper.getCounter();
    setState(() {});
  }

  // Incrementar contador
  void _increment() async {
    setState(() {
      _count++;
    });
    await _databaseHelper.updateCounter(_count); // Salvar no banco
  }

  // Decrementar contador
  void _decrement() async {
    if (_count > 0) {
      setState(() {
        _count--;
      });
      await _databaseHelper.updateCounter(_count); // Salvar no banco
    }
  }

  // Atualizar o Pokémon escolhido e seu sprite
  void _onPokemonChanged(String? pokemon) {
    setState(() {
      _selectedPokemon = pokemon ?? 'Bulbasaur';
      _pokemonSprite = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${_pokemons.indexOf(_selectedPokemon) + 1}.png';
    });
  }

  // Função para exibir a tela de adicionar à biblioteca
  void _addToLibrary() {
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
                  // Centralizando nome e sprite do Pokémon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(
                        _pokemonSprite,
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _selectedPokemon,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Exibindo a quantidade de resets
                  Text(
                    'Encontros: $_count',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 20),

                  // Dropdown para selecionar o jogo
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

                  // Dropdown para selecionar o método de hunt
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
                ],
              );
            },
          ),
          actions: [
            Center( // Centralizando o botão
              child: ElevatedButton(
                onPressed: () {
                  // Aqui você pode adicionar a lógica para salvar na biblioteca
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pokémon adicionado à biblioteca!')),
                  );
                  Navigator.pop(context); // Fechar a tela
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
            // Dropdown para selecionar o Pokémon
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
                  width: 50,
                  height: 50,
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Contador de encontros
            Text('Encontros:', style: Theme.of(context).textTheme.titleLarge),
            Text('$_count', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 60)), // Tamanho maior do contador

            const SizedBox(height: 40),

            // Botões de incremento e decremento
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

            // Botão de adicionar à biblioteca, agora centralizado
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
