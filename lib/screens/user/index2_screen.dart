import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../widgets/custom_app_bar.dart';

class Index2Screen extends StatelessWidget {
  const Index2Screen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'Métricas Rápidas'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _metricCard("1", "Usuarios Conectados"),
            const SizedBox(height: 30),
            _metricCard("${store.products.length}", "Productos Registrados"),
          ],
        ),
      ),
    );
  }

  Widget _metricCard(String value, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE50914), width: 3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 55, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 255, 0, 0))),
          Text(title, style: const TextStyle(fontSize: 16, color: Color.fromARGB(199, 79, 15, 15), fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}