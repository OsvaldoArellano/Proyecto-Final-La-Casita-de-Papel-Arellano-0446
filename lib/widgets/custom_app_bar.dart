import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../providers/auth_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final String? titleText; // Se mantiene por compatibilidad si se llega a necesitar en alguna pantalla específica

  const CustomAppBar({
    super.key,
    this.showBack = true,
    this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return AppBar(
      elevation: 0,
      // user requested: leave the appbar header color white
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.blue),
      leading: showBack
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.blue),
              onPressed: () => Navigator.maybePop(context),
            )
          : null,
      
      // Reemplazamos el contenedor de texto por la imagen del logotipo oficial
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
              color: Colors.blue,
              strokeWidth: 2,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          // Fallback en caso de que falle la red o la URL cambie, para que la app no rompa
          return const Text(
            'LA CASITA DE PAPEL',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              fontSize: 14,
            ),
          );
        },
      ),
      centerTitle: true,
      actions: [
        // Theme toggle with clear label and blue tint
        IconButton(
          tooltip: themeProvider.isDarkMode ? 'Modo claro' : 'Modo oscuro',
          icon: Icon(
            themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            color: Colors.blue,
          ),
          onPressed: () => themeProvider.toggleTheme(),
        ),
        IconButton(
          tooltip: 'Salir',
          icon: const Icon(Icons.exit_to_app, color: Colors.blue),
          onPressed: () async {
            final auth = Provider.of<AppAuthProvider>(context, listen: false);
            await auth.logout();
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}