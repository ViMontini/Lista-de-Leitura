import 'package:flutter/material.dart';
import 'package:lista_leitura/page/home_page.dart';
import 'package:lista_leitura/page/lista_livros.dart';
import 'package:lista_leitura/page/lista_leitura.dart';
import 'package:lista_leitura/controller/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Navegação entre Páginas',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/listaLivros': (context) => const ListaLivrosPage(
          adicionarLivroListaLeitura: adicionarLivroListaLeitura,
        ),
        '/listaLeitura': (context) => const ListaLeituraPage(
            removerLivroListaLeitura: removerLivroListaLeitura),
      },
    );
  }
}
