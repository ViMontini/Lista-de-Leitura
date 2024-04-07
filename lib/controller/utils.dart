import 'package:flutter/material.dart';
import 'package:lista_leitura/controller/database_helper.dart'; // Importe o DatabaseHelper
import 'package:google_books_api/google_books_api.dart';
import 'package:lista_leitura/model/livro_model.dart';

void adicionarLivroListaLeitura(BuildContext context, Book livro) async {
  if (context == null) {
    print("O contexto fornecido é nulo. Não é possível exibir o SnackBar.");
    return;
  }

  // Verifica se o livro já está no banco de dados
  bool livroJaExiste = await DatabaseHelper().livroExiste(livro.id);

  if (livroJaExiste) {
    // Se o livro já existe, exibe uma mensagem informando ao usuário
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    if (scaffoldMessenger != null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: const Text('Este livro já está na lista de leitura!'),
        ),
      );
    } else {
      print("Não foi possível acessar o ScaffoldMessenger. Não é possível exibir o SnackBar.");
    }
    return;
  }

  // Convertendo o ID do livro para String
  String id = livro.id;

  // Convertendo lista de autores para String
  List<String> autores = livro.volumeInfo.authors ?? [];
  String autoresString = autores.join(", ");

  // Convertendo lista de categorias para String
  List<String> categorias = livro.volumeInfo.categories ?? [];
  String categoriasString = categorias.join(", ");

  // Criando um novo objeto Livro com os dados do livro recebido
  Livro novoLivro = Livro(
    id: id,
    titulo: livro.volumeInfo.title ?? "",
    autores: autoresString,
    categorias: categoriasString,
  );

  // Exibindo informações e tipos de dados antes de inserir no banco de dados
  print('Informações do livro:');
  print('ID: $id');
  print('Título: ${novoLivro.titulo}');
  print('Autores: ${novoLivro.autores}');
  print('Categorias: ${novoLivro.categorias}');
  print('Tipos de dados:');
  print('ID: ${id.runtimeType}');
  print('Título: ${novoLivro.titulo.runtimeType}');
  print('Autores: ${novoLivro.autores.runtimeType}');
  print('Categorias: ${novoLivro.categorias.runtimeType}');

  // Inserindo o livro no banco de dados
  await DatabaseHelper().insertLivro(novoLivro);

  // Exibindo um SnackBar para confirmar a adição do livro
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  if (scaffoldMessenger != null) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: const Text('Livro adicionado com sucesso!'),
      ),
    );
  } else {
    print("Não foi possível acessar o ScaffoldMessenger. Não é possível exibir o SnackBar.");
  }
}

void removerLivroListaLeitura(BuildContext context, Livro livro) async {
  try {
    await DatabaseHelper().removerLivro(livro.id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Livro removido com sucesso!'),
      ),
    );
  } catch (e) {
    print('Erro ao remover livro do banco de dados: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Erro ao remover o livro.'),
      ),
    );
  }
}

