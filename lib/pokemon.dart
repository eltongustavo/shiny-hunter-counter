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
