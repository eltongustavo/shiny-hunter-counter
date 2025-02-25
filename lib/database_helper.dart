import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'pokemon.dart';

class DatabaseHelper {
  static const _databaseName = 'shiny_counter.db';
  static const _databaseVersion = 5; // Atualização da versão

  // Tabelas e colunas
  static const tablePokemon = 'pokemon';
  static const columnId = 'id';
  static const columnName = 'pokemon_name';
  static const columnSprite = 'sprite_url';
  static const columnGame = 'game';
  static const columnDate = 'capture_date';
  static const columnEncounters = 'encounters';
  static const columnMethod = 'method';  // Novo campo para 'method'

  static const tableShinyHunts = 'shiny_hunts'; // Tabela para as hunts
  static const columnHuntId = 'hunt_id'; // Identificador único da hunt
  static const columnIndexPokemon = 'index_pokemon'; // Índice do Pokémon
  static const columnHuntEncounters = 'encounters'; // Número de encontros

  // Banco de dados inicializado
  Database? _database;

  // Abre o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Criação do banco de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Função para excluir e recriar o banco de dados
  Future<void> deleteDatabaseAndRecreate() async {
    final path = join(await getDatabasesPath(), _databaseName);
    await deleteDatabase(path);  // Exclui o banco de dados
    _database = await _initDatabase();  // Recria o banco de dados
  }

  // Criação das tabelas
  Future<void> _onCreate(Database db, int version) async {
    // Criar tabela de Pokémon
    await db.execute(''' 
      CREATE TABLE $tablePokemon (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnSprite TEXT NOT NULL,
        $columnGame TEXT NOT NULL,
        $columnDate TEXT NOT NULL,
        $columnEncounters INTEGER NOT NULL,
        $columnMethod TEXT NOT NULL
      )
    ''');

    // Criar tabela de Shiny Hunts
    await db.execute(''' 
      CREATE TABLE $tableShinyHunts (
        $columnHuntId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnIndexPokemon INTEGER NOT NULL,
        $columnHuntEncounters INTEGER NOT NULL
      )
    ''');

  }

  // Método para apagar e recriar o banco de dados
  Future<void> dropAndRecreateDatabase() async {
    final db = await database;

    // Remove as tabelas existentes
    await db.execute('DROP TABLE IF EXISTS $tablePokemon');
    await db.execute('DROP TABLE IF EXISTS $tableShinyHunts');

    // Recria as tabelas
    await _onCreate(db, _databaseVersion);
  }

  // Função de inserir um novo Pokémon
  Future<void> insertPokemon(Pokemon pokemon) async {
    final db = await database;

    // Verifica se algum campo está vazio ou inválido
    if (pokemon.pokemonName.isEmpty ||
        pokemon.spriteUrl.isEmpty ||
        pokemon.game.isEmpty ||
        pokemon.captureDate.isEmpty ||
        pokemon.method.isEmpty) {
      print('Erro: um dos campos necessários está vazio.');
      return;
    }

    // Exibe os dados antes de tentar inserir para depuração
    print('Inserindo Pokémon: ${pokemon.toMap()}');

    try {
      // Inserir no banco de dados
      await db.insert(
        tablePokemon,
        pokemon.toMap(),  // Usando o método toMap() para passar os dados
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Erro ao inserir Pokémon: $e');
    }
  }

  // Função para deletar um Pokémon baseado no ID
  Future<void> deletePokemon(int pokemonId) async {
    final db = await database;
    await db.delete(
      tablePokemon,
      where: '$columnId = ?',
      whereArgs: [pokemonId],
    );
  }

  // Obter todos os Pokémons da biblioteca
  Future<List<Map<String, dynamic>>> getAllPokemon() async {
    final db = await database;
    var result = await db.query(tablePokemon);

    return result.map((pokemon) {
      return {
        columnId: pokemon[columnId] ?? -1,  // Garantir que o id seja atribuído ou -1 em caso de erro
        columnName: pokemon[columnName] ?? 'Nome desconhecido',
        columnSprite: pokemon[columnSprite] ?? '',
        columnGame: pokemon[columnGame] ?? 'Jogo desconhecido',
        columnDate: pokemon[columnDate] ?? 'Data desconhecida',
        columnEncounters: pokemon[columnEncounters] ?? 0,
        columnMethod: pokemon[columnMethod] ?? 'Método desconhecido',
      };
    }).toList();
  }

  // Função para obter um Pokémon específico pelo ID
  Future<Map<String, dynamic>?> getPokemonById(int id) async {
    final db = await database;
    var result = await db.query(
      tablePokemon,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;  // Se não encontrar, retorna null
    }
  }

  // Função para inserir uma nova shiny hunt
  Future<void> insertShinyHunt(int indexPokemon) async {
    final db = await database;

    // Insere uma nova hunt com um número inicial de encontros (0)
    await db.insert(
      tableShinyHunts,
      {
        columnIndexPokemon: indexPokemon, // Armazena o índice do Pokémon
        columnHuntEncounters: 0, // Inicia com 0 encontros
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Função para obter todas as hunts em andamento
  Future<List<Map<String, dynamic>>> getAllShinyHunts() async {
    final db = await database;
    var result = await db.query(tableShinyHunts);

    return result.map((hunt) {
      return {
        columnHuntId: hunt[columnHuntId],
        columnIndexPokemon: hunt[columnIndexPokemon], // Garantir que estamos pegando o índice do Pokémon
        columnEncounters: hunt[columnHuntEncounters],
      };
    }).toList();
  }

  Future<void> updateShinyHunt(int huntId, int encounters, int pokemonIndex) async {
    final db = await database;

    await db.update(
      'shiny_hunts',
      {
        'encounters': encounters,  // Atualizando os encontros
        'index_pokemon': pokemonIndex,  // Atualizando o índice do Pokémon
      },
      where: 'hunt_id = ?',
      whereArgs: [huntId],
    );
  }


  // Função para deletar uma hunt
  Future<void> deleteShinyHunt(int huntId) async {
    final db = await database;
    await db.delete(
      tableShinyHunts,
      where: '$columnHuntId = ?',
      whereArgs: [huntId],
    );
  }
}
