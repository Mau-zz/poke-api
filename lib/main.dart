import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(PokemonApp());

class PokemonApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController _pokemonController = TextEditingController();
  Map<String, dynamic>? _pokemonData;

  Future<void> fetchPokemon(String id) async {
    final url = Uri.parse('https://pokeapi.co/api/v2/pokemon/$id/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _pokemonData = json.decode(response.body);
        });
      } else {
        setState(() {
          _pokemonData = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se encontró el Pokémon.')),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error de conexión.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PokeAPI App'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _pokemonController,
              decoration: InputDecoration(
                labelText: 'Nombre o ID del Pokémon',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                final id = _pokemonController.text.trim();
                if (id.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, ingresa un nombre o ID.')),
                  );
                  return;
                }
                fetchPokemon(id);
              },
              child: Text('Buscar Pokémon'),
            ),
            SizedBox(height: 20),
            _pokemonData != null
                ? Column(
                    children: [
                      Text(
                        'Pokémon #${_pokemonData!['id']}: ${_pokemonData!['name']}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Image.network(_pokemonData!['sprites']['front_default']),
                    ],
                  )
                : Text('Busca un Pokémon para ver la información.')
          ],
        ),
      ),
    );
  }
}
