import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../auth/aou_screen.dart';
import '../../providers/theme_provider.dart';
import 'admin_users_screen.dart';
import 'admin_products_screen.dart';
import 'admin_categories_screen.dart';
import 'admin_orders_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final auth = Provider.of<AppAuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        iconTheme: const IconThemeData(color: Colors.red),
        // explicitly remove back button
        automaticallyImplyLeading: false,
        title: Image.network(
          'https://raw.githubusercontent.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/refs/heads/main/logo-removebg-preview-down.png',
          height: 45, // Altura ideal para que luzca estilizado en el AppBar
          fit: BoxFit.contain,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            // Mientras carga la imagen de GitHub, muestra un indicador sutil o el espacio reservado
            return const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.red,
                strokeWidth: 2,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            // Fallback en caso de que falle la red o la URL cambie, para que la app no rompa
            return const Text(
              'LA CASITA DE PAPEL',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
                fontSize: 14,
              ),
            );
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode, 
              color: Colors.blue,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () async {
              await auth.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AoUScreen()), (route) => false);
            },
          )
        ],
      ),
      body: Center( // 1. Centra todo el panel
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600), // 2. Limita el ancho máximo
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 15,
              crossAxisSpacing: 15,
              // Evita que el GridView intente ocupar el infinito vertical si está dentro de ciertos layouts
              shrinkWrap: true, 
              children: [
                _adminTile(context, "Usuarios", Icons.people, const AdminUsersScreen()),
                _adminTile(context, "Productos", Icons.shopping_basket, const AdminProductsScreen()),
                _adminTile(context, "Categorías", Icons.category, const AdminCategoriesScreen()),
                _adminTile(context, "Pedidos", Icons.local_shipping, const AdminOrdersScreen()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _adminTile(BuildContext context, String title, IconData icon, Widget targetScreen) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => targetScreen)),
      child: Container(
        decoration: BoxDecoration(color: const Color(0xFFC4A45A), borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}