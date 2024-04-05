class Livro {
  final int id;
  final String titulo;
  final String autor;
  final String genero;

  Livro({
    required this.id,
    required this.titulo,
    required this.autor,
    required this.genero,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'autor': autor,
      'genero': genero,
    };
  }
}
