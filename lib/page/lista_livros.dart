import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';
import 'package:lista_leitura/controller/utils.dart'; // Importe o arquivo utils.dart aqui

class ListaLivrosPage extends StatefulWidget {
  final void Function(BuildContext, Book) adicionarLivroListaLeitura;

  const ListaLivrosPage({super.key, required this.adicionarLivroListaLeitura});

  @override
  _ListaLivrosPageState createState() => _ListaLivrosPageState();
}

class _ListaLivrosPageState extends State<ListaLivrosPage> {
  late Future<List<Book>> _books;

  @override
  void initState() {
    super.initState();
    _books = fetchBooks();
  }

  Future<List<Book>> fetchBooks() async {
    final List<Book> books = await const GoogleBooksApi().searchBooks(
      'book',
      maxResults: 20,
      printType: PrintType.books,
      orderBy: OrderBy.relevance,
    );
    return books;
  }

  void _showAddToListDialog(Book book) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adicionar à lista de leitura'),
          content: Text('Deseja adicionar o livro "${book.volumeInfo.title}" à sua lista de leitura?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Usando a função adicionarLivroListaLeitura passando o contexto
                adicionarLivroListaLeitura(context, book);
                Navigator.of(context).pop();
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lista de Livros',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.purple],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Book>>(
        future: _books,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os livros'));
          } else {
            List<Book> books = snapshot.data!;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                Book book = books[index];
                return GestureDetector(
                  onTap: () {
                    _showAddToListDialog(book);
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Livro: ${book.volumeInfo.title}'),
                          const SizedBox(height: 5),
                          Text('Autor: ${book.volumeInfo.authors.join(", ")}'),
                          const SizedBox(height: 5),
                          Text('Gênero: ${book.volumeInfo.categories.join(", ")}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
