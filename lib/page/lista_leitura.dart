import 'package:flutter/material.dart';
import 'package:google_books_api/google_books_api.dart';

class ListaLeituraPage extends StatefulWidget {
  const ListaLeituraPage({super.key});

  @override
  _ListaLeituraPageState createState() => _ListaLeituraPageState();
}

class _ListaLeituraPageState extends State<ListaLeituraPage> {
  final List<Book> _listaLeitura = [];

  void adicionarLivroListaLeitura(Book livro) {
    setState(() {
      _listaLeitura.add(livro);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Lista de Leitura',
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
      body: ListView.builder(
        itemCount: _listaLeitura.length,
        itemBuilder: (context, index) {
          Book livro = _listaLeitura[index];
          return Card(
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Livro: ${livro.volumeInfo.title}'),
                  const SizedBox(height: 5),
                  Text('Autor: ${livro.volumeInfo.authors.join(", ")}'),
                  const SizedBox(height: 5),
                  Text('Gênero: ${livro.volumeInfo.categories.join(", ")}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}




