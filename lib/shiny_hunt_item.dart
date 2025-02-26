import 'package:flutter/material.dart';
import 'save_to_library_screen.dart';
import 'pokemon.dart';

class ShinyHuntItem extends StatelessWidget {
  final int huntId;
  final int encounters;
  final int pokemonIndex;
  final Function(int, int, int) onUpdateHunt;
  final VoidCallback onDeleteHunt;
  final Function() onHuntSaved;  // Callback para atualização

  List<String> pokemonList = Pokemon.getPokemonList();

  ShinyHuntItem({
    required this.huntId,
    required this.encounters,
    required this.pokemonIndex,
    required this.onUpdateHunt,
    required this.onDeleteHunt,
    required this.onHuntSaved,  // Passando o callback
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7, // Ocupa 70% da largura da tela
      margin: EdgeInsets.symmetric(vertical: 15), // Espaçamento entre os itens
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20), // Aumentando o padding para melhor espaçamento
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/$pokemonIndex.png',
                  width: 80,
                  height: 80,
                  errorBuilder: (context, error, stackTrace) {
                    // Retorna a imagem local no caso de erro de carregamento
                    return Image.asset(
                      'assets/no-internet.png',
                      width: 80,
                      height: 80,
                    );
                  },
                ),
                SizedBox(width: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: DropdownButton<int>(
                    value: pokemonIndex,
                    dropdownColor: Colors.black,
                    style: TextStyle(color: Colors.white),
                    isExpanded: true,
                    items: List.generate(
                      pokemonList.length,
                          (index) => DropdownMenuItem<int>(
                        value: index + 1, // Valor baseado no índice + 1
                        child: Text(pokemonList[index], style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        onUpdateHunt(huntId, encounters, newValue);
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
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
            SizedBox(height: 20), // Espaço entre o contador e os botões
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SaveToLibraryScreen(
                          pokemonIndex: pokemonIndex,
                          encounters: encounters,
                          huntId: huntId,
                          onHuntSaved: () {
                            // Chama a função de callback para atualizar a tela principal
                            onHuntSaved();
                          },
                        ),
                      ),
                    );
                  },
                  child: Text('Salvar na Biblioteca'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50), // Botão grande e ocupando toda a largura
                  ),
                ),
                SizedBox(height: 10), // Espaço entre os botões
                ElevatedButton(
                  onPressed: () async {
                    bool? confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmar Exclusão'),
                          content: Text('Você tem certeza que deseja excluir essa hunt?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text('Confirmar'),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmDelete == true) {
                      onDeleteHunt();
                    }
                  },
                  child: Text('Excluir Hunt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50), // Botão grande e ocupando toda a largura
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
