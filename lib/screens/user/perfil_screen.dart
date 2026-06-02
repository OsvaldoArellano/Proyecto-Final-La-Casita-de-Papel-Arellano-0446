import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'historial_screen.dart';
import 'editar_perfil_screen.dart';
import 'logout_confirm_screen.dart';
import '../../widgets/custom_app_bar.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AppAuthProvider>(context);
    if (auth.currentUser == null) {
      return const Scaffold(body: Center(child: Text('Por favor, inicia sesión.')));
    }

    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'Perfil'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 60, backgroundColor: Colors.black, child: Icon(Icons.person, size: 70, color: Colors.white)),
            const SizedBox(height: 20),
            Text(auth.currentUser!.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(auth.currentUser!.email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistorialScreen())),
              child: const Text('Historial >'),
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1A1A40), minimumSize: const Size(double.infinity, 45)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EditarPerfilScreen())),
              child: const Text('Editar Perfil', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914), minimumSize: const Size(double.infinity, 45)),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LogoutConfirmScreen())),
              child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}