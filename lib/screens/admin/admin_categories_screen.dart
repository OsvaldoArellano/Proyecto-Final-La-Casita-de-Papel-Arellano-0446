import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/store_provider.dart';

import '../../models/category_model.dart';

import '../../widgets/custom_app_bar.dart';



class AdminCategoriesScreen extends StatelessWidget {

  const AdminCategoriesScreen({super.key});



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

  void _showForm(BuildContext context, [CategoryModel? cat]) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    final nameCtrl = TextEditingController(text: cat?.name ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(cat == null ? 'Nueva Categoría' : 'Editar Categoría'),
        content: TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final name = nameCtrl.text.trim();
              if (name.isEmpty) return;

              try {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(content: Text('Guardando categoría...'), duration: Duration(seconds: 1)),
                  );
                }

                if (cat == null) {
                  await store.addCategory(name, 'star');
                } else {
                  await store.updateCategory(cat.id, name, cat.iconKey);
                }

                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    const SnackBar(backgroundColor: Colors.green, content: Text('¡Categoría guardada con éxito!')),
                  );
                  Navigator.pop(ctx);
                }
              } catch (e) {
                showDialog(
                  context: ctx,
                  builder: (_) => AlertDialog(
                    title: const Text('Error de Firebase'),
                    content: Text(e.toString()),
                    actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK'))],
                  ),
                );
              }
            },
            child: const Text('Guardar'),
          )
        ],
      ),
    );
  }


  @override

  Widget build(BuildContext context) {

    final store = Provider.of<StoreProvider>(context);

    return Scaffold(

      appBar: const CustomAppBar(showBack: true, titleText: 'ADM. CATEGORÍAS'),

      body: ListView.builder(

        itemCount: store.categories.length,

        itemBuilder: (context, idx) {

          final c = store.categories[idx];

          return Card(

            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

            elevation: 1.5,

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

            child: ListTile(

              leading: CircleAvatar(backgroundColor: Colors.blue.shade700, child: Icon(_getIconData(c.iconKey), color: Colors.white)),

              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.bold)),

              trailing: Row(

                mainAxisSize: MainAxisSize.min,

                children: [

                  IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(context, c)),

                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Confirmar eliminación'),
                          content: Text('¿Estás seguro que deseas eliminar la categoría "${c.name}"? Esta acción no se puede deshacer.'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
                            ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        try {
                          await store.deleteCategory(c.id);
                          if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Categoría eliminada')));
                        } catch (e) {
                          if (context.mounted) showDialog(context: context, builder: (_) => AlertDialog(title: const Text('Error'), content: Text(e.toString()), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))]));
                        }
                      }
                    },
                  ),

                ],

              ),

            ),

          );

        },

      ),

      floatingActionButton: FloatingActionButton(

        backgroundColor: const Color(0xFFE50914),

        child: const Icon(Icons.add),

        onPressed: () => _showForm(context),

      ),

    );

  }

}