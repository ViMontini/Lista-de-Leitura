import 'package:flutter/material.dart';
import 'package:lista_leitura/page/home_page.dart';
import 'package:lista_leitura/page/lista_livros.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Navegação entre Páginas',
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/listaLivros': (context) => ListaLivrosPage(),
        '/listaLeitura': (context) => ListaLeituraPage(),

      },
    );
  }
}

