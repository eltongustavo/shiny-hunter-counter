import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'pokemon.dart';

class DatabaseHelper {
  static const _databaseName = 'shiny_counter.db';
  static const _databaseVersion = 5;

  // Tabelas e colunas
  static const tablePokemon = 'pokemon';
  static const columnId = 'id';
  static const columnName = 'pokemon_name';
  static const columnSprite = 'sprite_url';
  static const columnGame = 'game';
  static const columnDate = 'capture_date';
  static const columnEncounters = 'encounters';
  static const columnMethod = 'method';

  static const tableShinyHunts = 'shiny_hunts';
  static const columnHuntId = 'hunt_id';
  static const columnIndexPokemon = 'index_pokemon';
  static const columnHuntEncounters = 'encounters';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Inicializa o suporte FFI para Windows/Linux
    if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    String path = await _getDatabasePath(_databaseName);
    print("Database path: $path");

    // Verifica se o banco de dados existe. Se não, cria.
    if (!await File(path).exists()) {
      print("Banco de dados não encontrado, criando...");
      await _onCreate(await openDatabase(path), _databaseVersion);
    }

    try {
      return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
    } catch (e) {
      print("Erro ao abrir o banco de dados: $e");
      rethrow;
    }
  }

  Future<String> _getDatabasePath(String dbName) async {
    Directory directory;

    if (Platform.isAndroid || Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isWindows || Platform.isLinux) {
      // Obtém o diretório onde o executável está rodando
      directory = File(Platform.resolvedExecutable).parent;
    } else {
      directory = Directory.current;
    }

    return join(directory.path, dbName);
  }

  Future<void> deleteDatabaseAndRecreate() async {
    final path = await _getDatabasePath(_databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = await _initDatabase();
  }

  Future<void> _onCreate(Database db, int version) async {
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

    await db.execute(''' 
      CREATE TABLE $tableShinyHunts (
        $columnHuntId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnIndexPokemon INTEGER NOT NULL,
        $columnHuntEncounters INTEGER NOT NULL
      )
    ''');

    print("Banco de dados criado com sucesso!");
  }

  Future<void> dropAndRecreateDatabase() async {
    final db = await database;
    await db.execute('DROP TABLE IF EXISTS $tablePokemon');
    await db.execute('DROP TABLE IF EXISTS $tableShinyHunts');
    await _onCreate(db, _databaseVersion);
  }

  Future<void> insertPokemon(Pokemon pokemon) async {
    final db = await database;
    if (pokemon.pokemonName.isEmpty ||
        pokemon.spriteUrl.isEmpty ||
        pokemon.game.isEmpty ||
        pokemon.captureDate.isEmpty ||
        pokemon.method.isEmpty) {
      print('Erro: um dos campos necessários está vazio.');
      return;
    }

    try {
      await db.insert(
        tablePokemon,
        pokemon.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print("Pokémon inserido com sucesso!");
    } catch (e) {
      print('Erro ao inserir Pokémon: $e');
    }
  }

  Future<void> deletePokemon(int pokemonId) async {
    final db = await database;
    await db.delete(
      tablePokemon,
      where: '$columnId = ?',
      whereArgs: [pokemonId],
    );
  }

  Future<List<Map<String, dynamic>>> getAllPokemon() async {
    final db = await database;
    var result = await db.query(tablePokemon);

    return result.map((pokemon) {
      return {
        columnId: pokemon[columnId] ?? -1,
        columnName: pokemon[columnName] ?? 'Nome desconhecido',
        columnSprite: pokemon[columnSprite] ?? '',
        columnGame: pokemon[columnGame] ?? 'Jogo desconhecido',
        columnDate: pokemon[columnDate] ?? 'Data desconhecida',
        columnEncounters: pokemon[columnEncounters] ?? 0,
        columnMethod: pokemon[columnMethod] ?? 'Método desconhecido',
      };
    }).toList();
  }

  Future<Map<String, dynamic>?> getPokemonById(int id) async {
    final db = await database;
    var result = await db.query(
      tablePokemon,
      where: '$columnId = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? result.first : null;
  }

  Future<void> insertShinyHunt(int indexPokemon) async {
    final db = await database;
    await db.insert(
      tableShinyHunts,
      {
        columnIndexPokemon: indexPokemon,
        columnHuntEncounters: 0,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllShinyHunts() async {
    final db = await database;
    var result = await db.query(tableShinyHunts);

    return result.map((hunt) {
      return {
        columnHuntId: hunt[columnHuntId],
        columnIndexPokemon: hunt[columnIndexPokemon],
        columnEncounters: hunt[columnHuntEncounters],
      };
    }).toList();
  }

  Future<void> updateShinyHunt(int huntId, int encounters, int pokemonIndex) async {
    final db = await database;
    await db.update(
      tableShinyHunts,
      {
        columnHuntEncounters: encounters,
        columnIndexPokemon: pokemonIndex,
      },
      where: '$columnHuntId = ?',
      whereArgs: [huntId],
    );
  }

  Future<void> deleteShinyHunt(int huntId) async {
    final db = await database;
    await db.delete(
      tableShinyHunts,
      where: '$columnHuntId = ?',
      whereArgs: [huntId],
    );
  }
}
