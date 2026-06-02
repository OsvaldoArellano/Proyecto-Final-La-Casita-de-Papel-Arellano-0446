import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';

class ContactoScreen extends StatelessWidget {
  const ContactoScreen({super.key});

  @override
  Widget build(BuildContext context) {
  // Usamos ThemeProvider para el modo y AppAuthProvider para logout
  final themeProvider = Provider.of<ThemeProvider>(context);
  final auth = Provider.of<AppAuthProvider>(context, listen: false);

    // Retornamos directamente el diseño sin Scaffold propio
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          
          // PANEL DE CONFIGURACIÓN (Tema y Logout) alineado a la derecha
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
                onPressed: () => themeProvider.toggleTheme(),
              ),
              const SizedBox(width: 10),
              
              // Botón de Cerrar Sesión
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.redAccent),
                tooltip: 'Cerrar Sesión',
                onPressed: () {
                  auth.logout();
                  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                },
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Título de la sección
          const Text(
            '¿Cómo podemos\nayudarte?', 
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          
          // Tarjetas de contacto informativas
          _contactCard(Icons.email, "Correo Electronico", "lacasitadepapel@gmail.com"),
          const SizedBox(height: 15),
          _contactCard(Icons.phone, "Teléfono / Whatsapp", "+52 656 166 55 88"),
          
          // Spacer empuja el logo hacia la parte inferior de la pestaña de forma estética
          const Spacer(),
          Image.network(
            'https://raw.githubusercontent.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/refs/heads/main/logo-removebg-preview.png', 
            height: 120,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.store, size: 120, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Componente reutilizable para las opciones de contacto
  Widget _contactCard(IconData icon, String title, String content) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade200, 
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE50914), size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(content, style: const TextStyle(color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }
}