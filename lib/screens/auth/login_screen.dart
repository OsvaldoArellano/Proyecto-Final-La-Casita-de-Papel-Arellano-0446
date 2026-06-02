import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
// restored original layout: no CustomAppBar
import '../user/main_navigation_container.dart';
import '../admin/admin_dashboard_screen.dart';
import 'carga_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  void _handleLogin() async {
    final auth = Provider.of<AppAuthProvider>(context, listen: false);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CargaScreen()));
    
    bool success = await auth.login(_emailCtrl.text.trim(), _passCtrl.text.trim());
    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      if (auth.currentUser!.isAdmin) {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AdminDashboardScreen()), (route) => false);
      } else {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainNavigationContainer()), (route) => false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error de autenticación.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE50914),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text('BIENVENIDO!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Image.network('https://raw.githubusercontent.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/refs/heads/main/logo.png', height: 110),
              const SizedBox(height: 30),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFFC4A45A), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: Text('INICIAR SESIÓN', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 15),
                    const Text('Correo Electrónico', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    TextField(
                      controller: _emailCtrl,
                      decoration: InputDecoration(filled: true, fillColor: const Color(0xFFE50914), prefixIcon: const Icon(Icons.email, color: Colors.white), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    const Text('Contraseña', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    TextField(
                      controller: _passCtrl,
                      obscureText: _obscure,
                      decoration: InputDecoration(filled: true, fillColor: const Color(0xFFE50914), prefixIcon: const Icon(Icons.lock, color: Colors.white), suffixIcon: IconButton(icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off, color: Colors.white), onPressed: () => setState(() => _obscure = !_obscure)), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914), padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        onPressed: _handleLogin,
                        child: const Text('INICIAR', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}