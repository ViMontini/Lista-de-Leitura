import 'dart:convert';

class Livro {
  final String id;
  final String titulo;
  final String autores;
  final String categorias;

  Livro({
    required this.id,
    required this.titulo,
    required this.autores,
    required this.categorias,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'autores': autores,
      'categorias': categorias,
    };
  }
}