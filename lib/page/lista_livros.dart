import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';

class ListaLivrosPage extends StatefulWidget {
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
    final List<Book> books = await GoogleBooksApi().searchBooks(
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
          title: Text('Adicionar à lista de leitura'),
          content: Text('Deseja adicionar o livro "${book.volumeInfo!.title}" à sua lista de leitura?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Adicione a lógica para adicionar o livro à lista de leitura aqui
                Navigator.of(context).pop();
              },
              child: Text('Adicionar'),
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
        title: Text(
          'Lista de Livros',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os livros'));
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
                          Text('Livro: ${book.volumeInfo!.title}'),
                          SizedBox(height: 5),
                          Text('Autor: ${book.volumeInfo!.authors?.join(", ")}'),
                          SizedBox(height: 5),
                          Text('Gênero: ${book.volumeInfo!.categories?.join(", ")}'),
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
