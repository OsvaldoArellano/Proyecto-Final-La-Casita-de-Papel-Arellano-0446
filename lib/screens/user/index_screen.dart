import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import 'novedades_screen.dart';
import 'index2_screen.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  @override
  Widget build(BuildContext context) {
  // Usamos ThemeProvider para controlar el modo y AppAuthProvider para logout
  final themeProvider = Provider.of<ThemeProvider>(context);
  final auth = Provider.of<AppAuthProvider>(context, listen: false);
  final theme = Theme.of(context);
    final primaryColor = const Color(0xFFE50914);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),

          // 1. PANEL DE CONTROL DE CONFIGURACIÓN (Logout y Tema)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Botón de Alternar Tema (Claro/Oscuro)
              IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.blue,
                ),
                tooltip: 'Cambiar Modo de Pantalla',
                onPressed: () {
                  themeProvider.toggleTheme();
                },
              ),
              const SizedBox(width: 10),
              
              // Botón de Cerrar Sesión
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                tooltip: 'Cerrar Sesión',
                onPressed: () {
                  // Llama al método de logout de tu Provider
                  auth.logout();

                  // Redirigir al login
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Contenedor del Logo
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: primaryColor, width: 3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.network(
              'https://raw.githubusercontent.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/refs/heads/main/logo-removebg-preview.png',
              height: 160,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.store, size: 160, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),

          // Sección Novedades
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NovedadesScreen())),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Novedades',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold) ??
                        const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 15),
                  Container(
                    height: 45,
                    width: 45,
                    decoration: BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                    child: const Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 35),

          // Eslogan
          const Text(
            '¡Tu Papelería de\nConfianza!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, height: 1.2),
          ),
          const SizedBox(height: 25),

          // Botón de Estadísticas Rápidas
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const Index2Screen())),
            child: const Text('Ver Estadísticas rápidas', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}