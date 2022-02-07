import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Home()));

class Album {
  final int idUsuario;
  final int id;
  final String titulo;
  Album({
    required this.idUsuario,
    required this.id,
    required this.titulo,
  });
  factory Album.lerJSON(Map<String, dynamic> json) {
    return Album(
      idUsuario: json['userId'],
      id: json['id'],
      titulo: json['title'],
    );
  }
}

Future<List> buscarAlbuns() async {
  Uri url = Uri.parse('https://jsonplaceholder.typicode.com/albums/');
  final resposta = await http.get(url);
  if (resposta.statusCode == 200) {
    List lista = json
        .decode(resposta.body)
        .map((albumJSON) => Album.lerJSON(albumJSON))
        .toList();
    return lista;
  } else {
    throw Exception('Erro ao carregar album');
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  late Future<List> listaFuturaAlbuns;
  @override
  void initState() {
    super.initState();
    listaFuturaAlbuns = buscarAlbuns();
  }

  Widget getCorpo() {
    return Center(
      child: FutureBuilder<List>(
        future: listaFuturaAlbuns,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Text id = Text(
                    snapshot.data![index].id.toString(),
                    style: TextStyle(
                      color: index % 2 == 0 ? Colors.blue : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                  Text usuario =
                      Text(snapshot.data![index].idUsuario.toString());
                  Text titulo = Text(snapshot.data![index].titulo);
                  return Card(
                    child: ListTile(
                      leading: id,
                      title: titulo,
                      subtitle: usuario,
                    ),
                    color: index % 2 == 0 ? Colors.amber[100] : Colors.red[100],
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Text(
              '${snapshot.error}',
              style: TextStyle(
                color: Colors.green,
              ),
            );
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Albuns'),
      ),
      body: getCorpo(),
    );
  }
}
