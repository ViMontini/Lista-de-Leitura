// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lista_leitura/model/livro_model.dart';

class DatabaseHelper {
  static const _databaseName = "lista_leitura.db";
  static const _databaseVersion = 1;

  static const table = 'livros';

  static const columnId = 'id';
  static const columnTitulo = 'titulo';
  static const columnAutor = 'autor';
  static const columnGenero = 'genero';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitulo TEXT NOT NULL,
            $columnAutor TEXT NOT NULL,
            $columnGenero TEXT NOT NULL
          )
          ''');
  }

  Future<int> insertLivro(Livro livro) async {
    Database? db = await instance.database;
    if (db == null) {
      // Tratamento para o caso de o banco de dados não estar inicializado
      throw Exception('Não foi possível obter o banco de dados.');
    }
    return await db.insert(table, livro.toMap());
  }

  Future<List<Livro>> getLivros() async {
    Database? db = await instance.database;
    if (db == null) {
      // Tratamento para o caso de o banco de dados não estar inicializado
      throw Exception('Não foi possível obter o banco de dados.');
    }
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Livro(
        id: maps[i]['id'],
        titulo: maps[i]['titulo'],
        autor: maps[i]['autor'],
        genero: maps[i]['genero'],
      );
    });
  }
}
