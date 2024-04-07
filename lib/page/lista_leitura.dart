import 'package:flutter/material.dart';
import 'package:lista_leitura/controller/database_helper.dart';
import 'package:lista_leitura/model/livro_model.dart';
import 'package:lista_leitura/controller/utils.dart';

class ListaLeituraPage extends StatefulWidget {
  final void Function(BuildContext, Livro) removerLivroListaLeitura;

  const ListaLeituraPage({Key? key, required this.removerLivroListaLeitura}) : super(key: key);

  @override
  _ListaLeituraPageState createState() => _ListaLeituraPageState();
}

class _ListaLeituraPageState extends State<ListaLeituraPage> {
  late List<Livro> _listaLeitura = [];


  @override
  void initState() {
    super.initState();
    _carregarLivros();
  }

  Future<void> _carregarLivros() async {
    try {
      final livros = await DatabaseHelper().getLivros();
      setState(() {
        _listaLeitura = livros;
      });
    } catch (e) {
      print('Erro ao carregar livros do banco de dados: $e');
    }
  }

  void _mostrarModal(Livro livro) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remover ${livro.titulo} da lista de leitura?'),
          content: Text('Tem certeza de que deseja remover ${livro
              .titulo} da sua lista de leitura?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                widget.removerLivroListaLeitura(context, livro);
                Navigator.of(context).pop();
                _carregarLivros();
              },
              child: Text('Remover'),
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
      body: _listaLeitura != null
          ? ListView.builder(
        itemCount: _listaLeitura.length,
        itemBuilder: (context, index) {
          final livro = _listaLeitura[index];
          return GestureDetector(
            onTap: () {
              _mostrarModal(livro);
            },
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Livro: ${livro.titulo}'),
                    const SizedBox(height: 5),
                    Text('Autor: ${livro.autores}'),
                    const SizedBox(height: 5),
                    Text('Gênero: ${livro.categorias}'),
                  ],
                ),
              ),
            ),
          );
        },
      )
          : Center(
        child: CircularProgressIndicator(), // Indicador de progresso enquanto os livros estão sendo carregados
      ),
    );
  }
}
