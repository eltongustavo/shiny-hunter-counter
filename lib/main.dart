import 'package:flutter/material.dart';
import 'shiny_hunt_counter_screen.dart';
import 'library_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ShinyCounterApp());
}

class ShinyCounterApp extends StatelessWidget {
  const ShinyCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shiny Hunt Tracker',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: Colors.black87,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shiny Hunt Tracker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Aumenta o botão
                textStyle: const TextStyle(fontSize: 20), // Aumenta o tamanho do texto
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShinyHuntCounterScreen()),
                );
              },
              child: const Text('Iniciar Shiny Hunt'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0), // Aumenta o botão
                textStyle: const TextStyle(fontSize: 20), // Aumenta o tamanho do texto
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LibraryScreen()),
                );
              },
              child: const Text('Minha Biblioteca'),
            ),
          ],
        ),
      ),
    );
  }
}
