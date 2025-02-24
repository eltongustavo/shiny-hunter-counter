import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'shiny_counter.db';
  static const _databaseVersion = 1;

  static const tablePokemon = 'pokemon';
  static const columnId = 'id';
  static const columnName = 'pokemon_name';
  static const columnSprite = 'sprite_url';
  static const columnGame = 'game';
  static const columnDate = 'date';
  static const columnResets = 'resets';

  static const tableCounter = 'counter'; // Tabela para o contador
  static const columnCount = 'count';

  late Database _database;

  // Abre o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // Criação do banco de dados
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Criação das tabelas
  Future _onCreate(Database db, int version) async {
    // Criar tabela de Pokémon
    await db.execute(''' 
      CREATE TABLE $tablePokemon (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT,
        $columnSprite TEXT,
        $columnGame TEXT,
        $columnDate TEXT,
        $columnResets TEXT
      )
    ''');

    // Criar tabela de contador
    await db.execute(''' 
      CREATE TABLE $tableCounter (
        id INTEGER PRIMARY KEY,
        $columnCount INTEGER
      )
    ''');

    // Inserir valor inicial na tabela de contador
    await db.insert(tableCounter, {columnCount: 0});
  }

  // Inserir Pokémon na biblioteca
  Future<int> insertPokemon(Map<String, dynamic> pokemon) async {
    Database db = await database;
    return await db.insert(tablePokemon, pokemon);
  }

  // Obter todos os Pokémon da biblioteca
  Future<List<Map<String, dynamic>>> getAllPokemon() async {
    Database db = await database;
    return await db.query(tablePokemon);
  }

  // Carregar contador do banco de dados
  Future<int> getCounter() async {
    Database db = await database;
    var result = await db.query(tableCounter, where: 'id = ?', whereArgs: [1]);
    return result.isNotEmpty ? result.first[columnCount] as int : 0;
  }

  // Atualizar o contador no banco de dados
  Future<void> updateCounter(int count) async {
    Database db = await database;
    await db.update(
      tableCounter,
      {columnCount: count},
      where: 'id = ?',
      whereArgs: [1],
    );
  }
}
