import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';

class EditarPerfilScreen extends StatefulWidget {
  const EditarPerfilScreen({super.key});

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _nameCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AppAuthProvider>(context, listen: false);
    _nameCtrl.text = auth.currentUser?.name ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AppAuthProvider>(context);
    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'Editar Perfil'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, backgroundColor: Colors.amber),
            const SizedBox(height: 20),
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Nombre de Usuario')),
            const Spacer(),
            ElevatedButton(
              onPressed: () async {
                await auth.updateUserProfile(_nameCtrl.text.trim(), auth.currentUser?.profileImageUrl);
                if (!context.mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Confirmar Cambios'),
            )
          ],
        ),
      ),
    );
  }
}