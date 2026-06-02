import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';

class NovedadesScreen extends StatelessWidget {
  const NovedadesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'NOVEDADES'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Destacado', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE50914), width: 2), borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Image.network('https://raw.githubusercontent.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/refs/heads/main/rompecabezas.png', fit: BoxFit.contain, height: 180),
            ),
            const SizedBox(height: 25),
            const Text('Llega Pronto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE50914), width: 2), borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              child: Image.network('https://raw.githubusercontent.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/refs/heads/main/logica.png', fit: BoxFit.contain, height: 180),
            ),
          ],
        ),
      ),
    );
  }
}