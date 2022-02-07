import 'dart:convert'; //Converter do formato string para o formato JSON.
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() async {
  runApp(
    MaterialApp(
      home: Home(),
    ),
  );
}

Uri url = Uri.parse("https://jsonplaceholder.typicode.com/posts/1");

class Postagem {
  final int idUsuario;
  final int id;
  final String titulo;
  final String mensagem;
  Postagem({
    required this.idUsuario,
    required this.id,
    required this.titulo,
    required this.mensagem,
  });
  factory Postagem.ler(Map<String, dynamic> registro) {
    return Postagem(
      idUsuario: registro['userId'],
      id: registro['id'],
      titulo: registro['title'],
      mensagem: registro['body'],
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FutureBuilder"),
      ),
      body: getFutureBuilder(),
    );
  }

  getFutureBuilder() {
    return FutureBuilder<Postagem>(
      future: getPostagem(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          default:
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Erro ao carregar: ${snapshot.error}.",
                ),
              );
            } else {
//if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: Text(
                      'id:' + snapshot.data!.id.toString(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: Text(
                      'titulo:' + snapshot.data!.titulo,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    child: Text(
                      'mensagem:' + snapshot.data!.mensagem,
                    ),
                  ),
                ],
              );
            }
        }
      },
    );
  }

  Future<Postagem> getPostagem() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return Postagem.ler(json.decode(response.body));
    } else {
      throw Exception('Falha ao carregar dados...');
    }
  }
}
