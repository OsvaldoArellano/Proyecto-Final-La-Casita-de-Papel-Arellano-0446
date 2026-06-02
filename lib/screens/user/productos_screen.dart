import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/auth_provider.dart';
import 'category_products_screen.dart';

class ProductosScreen extends StatelessWidget {
  const ProductosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Escuchamos el StoreProvider donde residen las categorías y los estados globales
    final store = Provider.of<StoreProvider>(context);
    // Theme and auth providers for toggle/logout
    final themeProvider = Provider.of<ThemeProvider>(context);
    final auth = Provider.of<AppAuthProvider>(context, listen: false);
    final categoriasDesdeDB = store.categories;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          // PANEL DE CONFIGURACIÓN (Tema y Logout)
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.blue,
                ),
                tooltip: 'Cambiar Modo de Pantalla',
                onPressed: () => themeProvider.toggleTheme(),
              ),
              const SizedBox(width: 10),
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

          // Título de la pantalla
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Categorías de la Tienda',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
          const SizedBox(height: 15),
          
          // Renderizado condicional según los datos de la DB
          categoriasDesdeDB.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40.0),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: Color(0xFFE50914)),
                        SizedBox(height: 15),
                        Text('Cargando categorías desde la base de datos...', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categoriasDesdeDB.length,
                  // CAMBIO CLAVE AQUÍ: Ajuste dinámico de columnas por tamaño
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 180, // El ancho máximo que tendrá cada cuadro
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.0,   // Mantiene la proporción cuadrada (1:1)
                  ),
                  itemBuilder: (context, index) {
                    final categoria = categoriasDesdeDB[index];
                    
                    final List<Color> paletaColores = [
                      const Color(0xFFE50914), // Rojo Casita de Papel
                      const Color(0xFFC4A45A), // Dorado Base
                      const Color(0xFF1A1A40), // Azul Oscuro complementario
                      Colors.blueGrey,
                      Colors.black87,
                    ];
                    Color tarjetaColor = paletaColores[index % paletaColores.length];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoryProductsScreen(categoryId: categoria.id, categoryName: categoria.name),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: tarjetaColor,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha((0.15 * 255).round()),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _getIconData(categoria.iconKey),
                              size: 45,
                              color: Colors.white,
                            ),
                            const SizedBox(height: 12),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                categoria.name.toUpperCase(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13, // Un punto menos por si el cuadro se encoge levemente
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  // Helper para asignar un icono nativo según el string que guardes en Firebase
  IconData _getIconData(String key) {
    switch (key.toLowerCase()) {
      case 'school':
      case 'utiles':
        return Icons.school;
      case 'architecture':
      case 'geometria':
        return Icons.architecture;
      case 'palette':
      case 'arte':
        return Icons.palette;
      case 'book':
        return Icons.menu_book;
      default:
        return Icons.star_border_purple500_rounded;
    }
  }
}