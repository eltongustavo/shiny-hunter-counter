class Pokemon {
  final String pokemonName;
  final String spriteUrl;
  final String game;
  final String captureDate;
  final int encounters;
  final String method;

  Pokemon({
    required this.pokemonName,
    required this.spriteUrl,
    required this.game,
    required this.captureDate,
    required this.encounters,
    required this.method,
  });

  // Lista de Pokémon
  static final List<String> _pokemons = [
    'Bulbasaur', 'Ivysaur', 'Venusaur', 'Charmander', 'Charmeleon', 'Charizard',
    'Squirtle', 'Wartortle', 'Blastoise', 'Caterpie', 'Metapod', 'Butterfree',
    'Weedle', 'Kakuna', 'Beedrill', 'Pidgey', 'Pidgeotto', 'Pidgeot', 'Rattata',
    'Raticate', 'Spearow', 'Fearow', 'Ekans', 'Arbok', 'Pikachu', 'Raichu',
    'Sandshrew', 'Sandslash', 'Nidoran♀', 'Nidorina', 'Nidoqueen', 'Nidoran♂',
    'Nidorino', 'Nidoking', 'Clefairy', 'Clefable', 'Vulpix', 'Ninetales',
    'Jigglypuff', 'Wigglytuff', 'Zubat', 'Golbat', 'Oddish', 'Gloom', 'Vileplume',
    'Paras', 'Parasect', 'Venonat', 'Venomoth', 'Diglett', 'Dugtrio', 'Meowth',
    'Persian', 'Psyduck', 'Golduck', 'Mankey', 'Primeape', 'Growlithe', 'Arcanine', 'Poliwag'
    ,'Poliwhirl' ,'Poliwhath','Abra','Kadabra','Alakazam', 'Machop', 'Machoke',
    'Machamp', 'Bellsprout', 'Weepinbell', 'Victreebel', 'Tentacool', 'Tentacruel',
    'Geodude', 'Graveler', 'Golem', 'Ponyta', 'Rapidash', 'Slowpoke', 'Slowbro',
    'Magnemite', 'Magneton','Farfetch’d','Doduo','Dodrio','Seel','Dewgong',
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

  // Lista de Jogos
  static final List<String> _games = [
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
  ];

  // Lista de Métodos de captura
  static final List<String> _methods = [
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
  ];

  // Método estático para acessar a lista de Pokémon
  static List<String> getPokemonList() {
    return _pokemons;
  }

  // Método estático para acessar a lista de jogos
  static List<String> getGamesList() {
    return _games;
  }

  // Método estático para acessar a lista de métodos de captura
  static List<String> getMethodsList() {
    return _methods;
  }

  // Método toMap() para transformar o objeto Pokemon em um Map
  Map<String, dynamic> toMap() {
    return {
      'pokemon_name': pokemonName,
      'sprite_url': spriteUrl,
      'game': game,
      'capture_date': captureDate,
      'encounters': encounters,
      'method': method,
    };
  }
}
