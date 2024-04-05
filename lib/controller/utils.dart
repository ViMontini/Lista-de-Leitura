import 'package:flutter/material.dart';
import 'package:lista_leitura/model/livro_model.dart';
import 'package:lista_leitura/controller/database_helper.dart';
import 'package:google_books_api/google_books_api.dart';

void adicionarLivroListaLeitura(BuildContext context, Book livro) async {
  int id = int.parse(livro.id);
  Livro novoLivro = Livro(
    id: id,
    titulo: livro.volumeInfo.title,
    autor: livro.volumeInfo.authors.join(", ") ?? "",
    genero: livro.volumeInfo.categories.join(", ") ?? "",
  );

  await DatabaseHelper.instance.insertLivro(novoLivro);

  // Exibir o SnackBar
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Livro adicionado com sucesso!'),
    ),
  );
}
