import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
// restored original layout: no CustomAppBar
import '../user/main_navigation_container.dart';
import 'carga_screen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final bool _obscure = true;

  void _handleRegister() async {
    final auth = Provider.of<AppAuthProvider>(context, listen: false);
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CargaScreen()));
  bool success = await auth.register(_nameCtrl.text.trim(), _emailCtrl.text.trim(), _passCtrl.text.trim());
  if (!mounted) return;
  Navigator.pop(context);

    if (success) {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const MainNavigationContainer()), (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error al crear la cuenta.')));
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
              const Text('BIENVENIDO!', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              Image.network('https://raw.githubusercontent.com/OsvaldoArellano/Imagenes-para-flutter-6-J-11-febrero-2026/refs/heads/main/logo.png', height: 100),
              const SizedBox(height: 15),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFFC4A45A), borderRadius: BorderRadius.circular(20)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: Text('Regístrate', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 10),
                    const Text('Usuario', style: TextStyle(color: Colors.white)),
                    TextField(controller: _nameCtrl, decoration: InputDecoration(filled: true, fillColor: const Color(0xFFE50914), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)), style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 10),
                    const Text('Correo', style: TextStyle(color: Colors.white)),
                    TextField(controller: _emailCtrl, decoration: InputDecoration(filled: true, fillColor: const Color(0xFFE50914), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)), style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 10),
                    const Text('Contraseña', style: TextStyle(color: Colors.white)),
                    TextField(controller: _passCtrl, obscureText: _obscure, decoration: InputDecoration(filled: true, fillColor: const Color(0xFFE50914), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none)), style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 15),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914)),
                        onPressed: _handleRegister,
                        child: const Text('Registrar', style: TextStyle(color: Colors.white)),
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