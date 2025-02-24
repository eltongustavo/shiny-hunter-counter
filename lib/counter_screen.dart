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

  final List<String> _pokemons = [
    'Bulbasaur',
    'Charmander',
    'Squirtle',
    'Pikachu',
    'Eevee',
    // Adicione mais Pokémon aqui
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
          ],
        ),
      ),
    );
  }
}
