import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart'; // Import necessário para os widgets do Flutter

class DatabaseHelper {
  static const _databaseName = 'shiny_counter.db';
  static const _databaseVersion = 3; // Versão do banco de dados

  // Tabelas e colunas
  static const tablePokemon = 'pokemon';
  static const columnId = 'id';
  static const columnName = 'pokemon_name';
  static const columnSprite = 'sprite_url';
  static const columnGame = 'game';
  static const columnDate = 'capture_date';
  static const columnResets = 'resets';
  static const columnMethod = 'method';  // Novo campo para 'method'

  static const tableCounter = 'counter'; // Tabela para o contador
  static const columnCount = 'count';

  // Banco de dados inicializado
  Database? _database;

  // Abre o banco de dados
  Future<Database> get database async {
    if (_database != null) return _database!;

    // Se o banco de dados não foi inicializado, cria o banco de dados
    _database = await _initDatabase();
    return _database!;
  }

  // Criação do banco de dados
  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);

    // Inicializando o banco de dados
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  // Método para apagar e recriar o banco de dados
  Future<void> dropAndRecreateDatabase() async {
    final db = await database;

    // Remove as tabelas existentes
    await db.execute('DROP TABLE IF EXISTS $tablePokemon');
    await db.execute('DROP TABLE IF EXISTS $tableCounter');

    // Recria as tabelas
    await _onCreate(db, _databaseVersion);
  }

  // Criação das tabelas
  Future<void> _onCreate(Database db, int version) async {
    // Criar tabela de Pokémon
    await db.execute(''' 
      CREATE TABLE $tablePokemon (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT,
        $columnSprite TEXT,
        $columnGame TEXT,
        $columnDate TEXT,
        $columnResets INTEGER,
        $columnMethod TEXT  // Adicionando coluna 'method'
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

  Future<void> insertPokemon({
    required String pokemonName,
    required String spriteUrl,
    required String game,
    required String captureDate,
    required int resets,
    required String method,
  }) async {
    final db = await database;

    // Verifica se algum campo está vazio ou inválido
    if (pokemonName.isEmpty || spriteUrl.isEmpty || game.isEmpty || captureDate.isEmpty || method.isEmpty) {
      print('Erro: um dos campos necessários está vazio.');
      return;
    }

    // Inserir no banco de dados
    await db.insert(
      tablePokemon,
      {
        columnName: pokemonName,
        columnSprite: spriteUrl,
        columnGame: game,
        columnDate: captureDate,
        columnResets: resets,
        columnMethod: method,  // Adicionando 'method' ao inserir Pokémon
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Obter todos os Pokémons da biblioteca
  Future<List<Map<String, dynamic>>> getAllPokemon() async {
    final db = await database;
    var result = await db.query(tablePokemon);

    print('Pokémons no banco de dados: $result'); // Mostra todos os Pokémons com seus IDs

    result = result.map((pokemon) {
      return {
        columnId: pokemon[columnId] ?? -1,  // Garantir que o id seja atribuído ou -1 em caso de erro
        columnName: pokemon[columnName] ?? 'Nome desconhecido',
        columnSprite: pokemon[columnSprite] ?? '',
        columnGame: pokemon[columnGame] ?? 'Jogo desconhecido',
        columnDate: pokemon[columnDate] ?? 'Data desconhecida',
        columnResets: pokemon[columnResets] ?? 0,
        columnMethod: pokemon[columnMethod] ?? 'Método desconhecido',
      };
    }).toList();

    return result;
  }

  // Carregar contador do banco de dados
  Future<int> getCounter() async {
    Database db = await database;
    var result = await db.query(tableCounter, where: 'id = ?', whereArgs: [1]);

    // Tratar caso o valor do contador seja nulo
    return result.isNotEmpty ? (result.first[columnCount] ?? 0) as int : 0;
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

  // Atualizar Pokémon no banco de dados
  Future<int> updatePokemon(int id, String pokemonName, String spriteUrl, String game, String captureDate, int resets, String method) async {
    Database db = await database;

    // Tratar valores nulos antes de atualizar o banco
    pokemonName = pokemonName.isNotEmpty ? pokemonName : 'Nome desconhecido';
    spriteUrl = spriteUrl.isNotEmpty ? spriteUrl : '';
    game = game.isNotEmpty ? game : 'Jogo desconhecido';
    captureDate = captureDate.isNotEmpty ? captureDate : 'Data desconhecida';
    method = method.isNotEmpty ? method : 'Método desconhecido'; // Garantir valor para 'method'

    Map<String, dynamic> updatedPokemon = {
      columnName: pokemonName,
      columnSprite: spriteUrl,
      columnGame: game,
      columnDate: captureDate,
      columnResets: resets,
      columnMethod: method,  // Atualizando 'method'
    };

    return await db.update(
      tablePokemon,
      updatedPokemon,
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  // Método para deletar Pokémon do banco de dados
  Future<void> deletePokemon(int pokemonId) async {
    final db = await database;  // Certifique-se de ter a instância do banco de dados
    await db.delete(
      'pokemon',  // Nome da tabela
      where: 'id = ?',  // Condição para encontrar o Pokémon
      whereArgs: [pokemonId],  // Passa o ID do Pokémon
    );
  }

  // Nova função para adicionar Pokémon com valores fixos
  Future<void> insertNewPokemon(Map<String, dynamic> newPokemon) async {
    final db = await database;

    // Verifica se algum campo está vazio ou inválido
    if (newPokemon['pokemon_name'].isEmpty || newPokemon['sprite_url'].isEmpty || newPokemon['game'].isEmpty || newPokemon['capture_date'].isEmpty || newPokemon['method'].isEmpty) {
      print('Erro: um dos campos necessários está vazio.');
      return;
    }

    // Inserir no banco de dados
    await db.insert(
      tablePokemon,
      {
        columnName: newPokemon['pokemon_name'],
        columnSprite: newPokemon['sprite_url'],
        columnGame: newPokemon['game'],
        columnDate: newPokemon['capture_date'],
        columnResets: newPokemon['resets'],
        columnMethod: newPokemon['method'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

}
