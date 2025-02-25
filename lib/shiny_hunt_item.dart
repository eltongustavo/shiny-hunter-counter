import 'package:flutter/material.dart';

class ShinyHuntItem extends StatelessWidget {
  final int huntId;
  final int encounters;
  final int pokemonIndex;
  final Function(int, int, int) onUpdateHunt;
  final VoidCallback onDeleteHunt;

  ShinyHuntItem({
    required this.huntId,
    required this.encounters,
    required this.pokemonIndex,
    required this.onUpdateHunt,
    required this.onDeleteHunt,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30), // Adiciona margem inferior
      decoration: BoxDecoration(
        color: Colors.grey[900], // Cor de fundo diferenciada
        borderRadius: BorderRadius.circular(30), // Bordas arredondadas
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Centraliza os itens
              children: [
                // Sprite do Pokémon
                Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/$pokemonIndex.png',
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.image_not_supported, color: Colors.white, size: 80),
                ),
                SizedBox(width: 20), // Espaçamento entre sprite e dropdown

                // Dropdown para selecionar Pokémon com largura reduzida
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4, // Reduz largura para 40% da tela
                  child: DropdownButton<int>(
                    value: pokemonIndex,
                    dropdownColor: Colors.black,
                    style: TextStyle(color: Colors.white),
                    isExpanded: true, // Garante que ocupe toda a largura do SizedBox
                    items: List.generate(20, (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text('Pokémon ${index + 1}', style: TextStyle(color: Colors.white)),
                    )),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        onUpdateHunt(huntId, encounters, newValue);
                      }
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 10), // Espaçamento entre dropdown e contador
            Text('$encounters', style: TextStyle(fontSize: 40, color: Colors.white)),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.remove, size: 80, color: Colors.white),
                  onPressed: () {
                    if (encounters > 0) {
                      onUpdateHunt(huntId, encounters - 1, pokemonIndex);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add, size: 80, color: Colors.white),
                  onPressed: () {
                    onUpdateHunt(huntId, encounters + 1, pokemonIndex);
                  },
                ),
              ],
            ),

            ElevatedButton(
              onPressed: () async {
                // Exibe o diálogo de confirmação antes de excluir
                bool? confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirmar Exclusão'),
                      content: Text('Você tem certeza que deseja excluir essa hunt?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false); // Cancelar
                          },
                          child: Text('Cancelar'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true); // Confirmar
                          },
                          child: Text('Confirmar'),
                        ),
                      ],
                    );
                  },
                );

                if (confirmDelete == true) {
                  onDeleteHunt(); // Chama a função de exclusão se confirmado
                }
              },
              child: Text('Excluir Hunt'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
