import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

void main() => runApp(
      MaterialApp(
        title: 'Consulta CEP',
        home: Home(),
      ),
    );

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  String cep = '';
  String logradouro = '';
  String complemento = '';
  String bairro = '';
  String localidade = '';
  String uf = '';
  TextEditingController cepController = TextEditingController();
  Future buscarDadosViaCep() async {
    String url = 'https://viacep.com.br/ws/' + cepController.text + '/json/';
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Erro ao recuperar dados associados ao CEP informado.');
    }
  }

  void lerJson(http.Response resp) {
    Map<String, dynamic> objeto = jsonDecode(resp.body);
    cep = objeto['cep'];
    logradouro = objeto['logradouro'];
    complemento = objeto['complemento'];
    bairro = objeto['bairro'];
    localidade = objeto['localidade'];
    uf = objeto['uf'];
  }

  void mensagemErro() {
    setState(
      () {
        cep = 'informado incorretamente';
        logradouro = '';
        complemento = '';
        bairro = '';
        localidade = '';
        uf = '';
      },
    );
    final snackBar = SnackBar(
      content: const Text('CEP incorreto!'),
      action: SnackBarAction(
        label: 'Fechar',
        onPressed: () {
          setState(() => cep = '');
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void buscar() {
    buscarDadosViaCep()
        .then((resposta) => setState(() => lerJson(resposta)))
        .onError((error, stackTrace) => mensagemErro());
  }

  Widget getInput() {
    return TextField(
      controller: cepController,
      keyboardType: TextInputType.number,
      maxLength: 8,
      textAlign: TextAlign.right,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () => cepController.clear(),
          icon: Icon(Icons.clear),
        ),
        border: OutlineInputBorder(),
        labelText: 'CEP',
      ),
    );
  }

  Widget getBotao() {
    return ElevatedButton(
      child: Text('Consultar CEP'),
      onPressed: buscar,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(25),
      ),
    );
  }

  Widget getResposta(String resp) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Text(
        resp,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta CEP'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Column(
              children: [
                getInput(),
                getBotao(),
              ],
            ),
            Divider(
              height: 60,
              thickness: 5,
              indent: 20,
              endIndent: 20,
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  getResposta('CEP: $cep'),
                  getResposta('Logradouro: $logradouro'),
                  getResposta('Complemento: $complemento'),
                  getResposta('Bairro: $bairro'),
                  getResposta('Localidade: $localidade'),
                  getResposta('UF: $uf'),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: buscar,
        tooltip: 'Consultar CEP',
        child: Icon(Icons.search),
      ),
    );
  }
}
