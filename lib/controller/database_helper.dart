import 'package:google_books_api/google_books_api.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lista_leitura/model/livro_model.dart';

class DatabaseHelper {
  static Database? _database;

  static const String listaLeitura = 'books';
  static const String id = 'id';
  static const String titulo = 'titulo';
  static const String autores = 'autores';
  static const String categorias = 'categorias';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final String path = join(await getDatabasesPath(), 'books_database.db');
      final database = await openDatabase(path, version: 1, onCreate: _createDatabase);
      print("Banco de dados carregado com sucesso em: $path");
      return database;
    } catch (e) {
      print("Erro ao carregar o banco de dados: $e");
      rethrow; // Reenvia a exceção para tratar em um nível superior, se necessário
    }
  }

  Future<void> _createDatabase(Database db, int version) async {
    print("Criando o banco de dados...");
    await db.execute('''
    CREATE TABLE $listaLeitura (
      $id TEXT PRIMARY KEY,
      $titulo TEXT,
      $autores TEXT,
      $categorias TEXT
    )
  ''');
    print("Banco de dados criado com sucesso!");
  }

  Future<int> insertLivro(Livro livro) async {
    final Database db = await database;
    return db.insert(listaLeitura, livro.toMap());
  }

  Future<void> removerLivro(String id) async {
    final db = await database;
    await db.delete(
      'books', // Nome da tabela
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<bool> livroExiste(String id) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      listaLeitura,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty;
  }

  Future<List<Livro>> getLivros() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(listaLeitura);
    return List.generate(maps.length, (i) {
      return Livro(
        id: maps[i]['id'],
        titulo: maps[i]['titulo'],
        autores: maps[i]['autores'],
        categorias: maps[i]['categorias'],
      );
    });
  }
}
