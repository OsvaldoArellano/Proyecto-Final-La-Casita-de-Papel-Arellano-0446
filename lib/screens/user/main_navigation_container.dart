import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/user_navigation_bar.dart';
import '../auth/aou_screen.dart';
import 'index_screen.dart';
import 'productos_screen.dart';
import 'contacto_screen.dart';
import 'wishlist_screen.dart';
import 'cart_screen.dart';
import 'perfil_screen.dart';
import 'historial_screen.dart';
import 'logout_confirm_screen.dart';

class MainNavigationContainer extends StatefulWidget {
  final int initialIndex;

  const MainNavigationContainer({super.key, this.initialIndex = 0});

  @override
  State<MainNavigationContainer> createState() => _MainNavigationContainerState();
}

class _MainNavigationContainerState extends State<MainNavigationContainer> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const IndexScreen(),
    const ProductosScreen(),
    const ContactoScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    // Ensure current index starts from the provided initialIndex when the
    // widget is first built (useful when other screens navigate here with
    // a desired initial tab).
    // If the value was already changed by the user, preserve it.
    if (_currentIndex != widget.initialIndex && mounted && _currentIndex == 0) {
      _currentIndex = widget.initialIndex;
    }
    final auth = Provider.of<AppAuthProvider>(context);
    final isLogged = auth.currentUser != null;

    return Scaffold(
      key: _scaffoldKey,
      // Usamos el AppBar personalizado añadiéndole el botón para abrir el Drawer
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFFE50914), size: 28),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
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
                color: Colors.white,
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
      ),
      drawer: Drawer(
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Color(0xFFE50914)),
                currentAccountPicture: CircleAvatar(
                  backgroundColor: const Color(0xFFC4A45A),
                  backgroundImage: isLogged && auth.currentUser!.profileImageUrl != null
                      ? NetworkImage(auth.currentUser!.profileImageUrl!)
                      : null,
                  child: !isLogged ? const Icon(Icons.person, size: 40, color: Colors.white) : null,
                ),
                accountName: Text(
                  isLogged ? auth.currentUser!.name : 'Invitado',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                accountEmail: Text(isLogged ? auth.currentUser!.email : 'Inicia sesión para comprar'),
              ),
              ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: const Text('Mis Favoritos', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const WishlistScreen()));
                },
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart, color: Color(0xFFE50914)),
                title: const Text('Mi Carrito', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.account_circle, color: Colors.blue),
                title: const Text('Mi Perfil / Editar Info', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  if (isLogged) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const PerfilScreen()));
                  } else {
                    _showLoginWarning(context);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.history, color: Colors.green),
                title: const Text('Mis Pedidos (Historial)', style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.pop(context);
                  if (isLogged) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HistorialScreen()));
                  } else {
                    _showLoginWarning(context);
                  }
                },
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE50914),
                    minimumSize: const Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: Icon(isLogged ? Icons.logout : Icons.login, color: Colors.white),
                  label: Text(
                    isLogged ? 'CERRAR SESIÓN' : 'INICIAR SESIÓN',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    if (isLogged) {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => const LogoutConfirmScreen()));
                    } else {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AoUScreen()), (route) => false);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: UserNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }

  void _showLoginWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Necesitas iniciar sesión para acceder a esta sección.')),
    );
  }
}