import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  // Criação do banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  // Inicializando o banco de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'shiny_hunt_tracker.db');
    return openDatabase(path, onCreate: (db, version) {
      // Tabela para armazenar os Shinies
      db.execute('''
        CREATE TABLE shinies(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT
        )
      ''');

      // Tabela para armazenar o contador de encontros
      db.execute('''
        CREATE TABLE counter(
          id INTEGER PRIMARY KEY,
          count INTEGER
        )
      ''');
    }, version: 1);
  }

  // Função para inserir Shinies
  Future<void> insertShiny(String name) async {
    final db = await database;
    await db.insert(
      'shinies',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Função para obter todos os Shinies
  Future<List<Map<String, dynamic>>> getShinies() async {
    final db = await database;
    return db.query('shinies');
  }

  // Função para inserir ou atualizar o contador
  Future<void> updateCounter(int count) async {
    final db = await database;
    var result = await db.query('counter', where: 'id = 1');
    if (result.isEmpty) {
      // Inserir contador se não existir
      await db.insert('counter', {'id': 1, 'count': count});
    } else {
      // Atualizar contador existente
      await db.update('counter', {'count': count}, where: 'id = 1');
    }
  }

  // Função para obter o contador
  Future<int> getCounter() async {
    final db = await database;
    var result = await db.query('counter', where: 'id = 1');
    if (result.isEmpty) {
      return 0; // Se não houver contador, retornar 0
    } else {
      return result.first['count'] as int;
    }
  }
}
