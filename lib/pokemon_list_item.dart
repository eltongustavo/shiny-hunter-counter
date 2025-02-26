import 'package:flutter/material.dart';

class PokemonListItem extends StatelessWidget {
  final Map<String, dynamic> pokemon;
  final Function onDelete;

  const PokemonListItem({Key? key, required this.pokemon, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          ? FittedBox(
        fit: BoxFit.contain,  // Ajusta a imagem para caber no tamanho desejado
        child: Image.network(
          pokemon['sprite_url']!,
          width: 100, // Defina o tamanho máximo desejado
          height: 100,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return const CircularProgressIndicator();
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return Image.asset('assets/no-internet.png', width: 100, height: 100);
          },
        ),
      )

          : const Icon(Icons.image_not_supported),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          onDelete(pokemon['id']);
        },
      ),
    );
  }
}
