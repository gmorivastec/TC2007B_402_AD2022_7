import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  // lo único que hace es ejecutar run app
  // run app recibe un widget
  runApp(const MyApp());
}

// widget es un elemento de UI
// TODA la UI está construida por widgets

// 2 tipos de widgets:
// 1. stateless - UI no cambia (aunque sus datos pueden)
// 2. stateful - toda la UI puede ser cambiada


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListaWidget(),
    );
  }
}

class ListaWidget extends StatefulWidget {

  @override
  _ListaWidgetState createState() => _ListaWidgetState();
}

class _ListaWidgetState extends State<ListaWidget>{

  List<String> _contenido = ["a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c", "a", "b", "c"];
  TextStyle _estilito = const TextStyle(fontSize: 15.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("UNA APLICACIÓN CHIDA"),
      ),
      body: _construyeLista(),
    );
  }

  Widget _construyeLista() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: _contenido.length,
      itemBuilder: (context, i) {
        return _construyeRow(_contenido[i]);
      },
    );
  }

  Widget _construyeRow(String valor){
    return ListTile(
      title: Text(
        valor,
        style: _estilito,
      ),
      onTap: () {
        Fluttertoast.showToast(
            msg: "presionaste: " + valor,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2
        );

        // navigator es el manejador del stack de widgets
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VistaDetalle()
          ),
        );
      },
    );
  }
}

class VistaDetalle extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AQUÍ VA EL DETALLE"),
      ),
      body: const Center(
        child: Text("INFO ESPECÍFICA DE DETALLE")
      ),
    );
  }
}

// 1. hacer request
// 2. parsear el JSON de llegada

// https://bitbucket.org/itesmguillermorivas/partial2/raw/45f22905941b70964102fce8caf882b51e988d23/carros.json

// crear clase para contener datos de carros
class Carro {

  final String marca;
  final String modelo;
  final int anio;

  Carro({required this.marca, required this.modelo, required this.anio});

  factory Carro.fromJson(Map<String, dynamic> json){
    return Carro(
      marca: json['marca'],
      modelo: json['modelo'],
      anio: json['anio']
    );
  }
}

// método para request (y ya los dejo en paz)
Future<List<Carro>> obtenerInfo() async {

  final response = await http.get(
    Uri.parse(
      "https://bitbucket.org/itesmguillermorivas/partial2/raw/45f22905941b70964102fce8caf882b51e988d23/carros.json"
    )
  );

  if(response.statusCode == 200){

    List<dynamic> list = jsonDecode(response.body);
    List<Carro> result = [];

    for(var actual in list) {

      Carro carroActual = Carro.fromJson(actual);
      result.add(carroActual);
    }

    return result;
  } else {
    throw Exception("ERROR EN REQUEST");
  }
}