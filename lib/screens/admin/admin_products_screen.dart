import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/store_provider.dart';

import '../../models/product_model.dart';

// Theme is toggled from CustomAppBar; no local ThemeProvider needed here
import '../../widgets/custom_app_bar.dart';



class AdminProductsScreen extends StatelessWidget {

const AdminProductsScreen({super.key});



void _showForm(BuildContext context, [ProductModel? product]) {

final store = Provider.of<StoreProvider>(context, listen: false);

final nameCtrl = TextEditingController(text: product?.name ?? '');

final descCtrl = TextEditingController(text: product?.description ?? '');

final priceCtrl = TextEditingController(text: product != null ? product.price.toString() : '');

final imageCtrl = TextEditingController(text: product?.imageUrl ?? '');

String selectedCatId = product?.categoryId ?? (store.categories.isNotEmpty ? store.categories.first.id : '');



showModalBottomSheet(

context: context,

isScrollControlled: true,

builder: (ctx) => StatefulBuilder(

builder: (ctx, setState) => Padding(

padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom, top: 20, left: 20, right: 20),

child: SingleChildScrollView(

child: Column(

mainAxisSize: MainAxisSize.min,

children: [

TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre')),

TextField(controller: descCtrl, decoration: const InputDecoration(labelText: 'Descripción')),

TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: 'Precio'), keyboardType: TextInputType.number),

const SizedBox(height: 10),

TextField(controller: imageCtrl, decoration: const InputDecoration(labelText: 'URL de la imagen')),

const SizedBox(height: 10),

DropdownButtonFormField<String>(

initialValue: selectedCatId.isEmpty ? null : selectedCatId,

items: store.categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name))).toList(),

onChanged: (val) => setState(() => selectedCatId = val ?? ''),

decoration: const InputDecoration(labelText: 'Categoría (Desde DB)'),

),

const SizedBox(height: 20),

ElevatedButton(

onPressed: () async {

try {

final store = Provider.of<StoreProvider>(context, listen: false);

final String name = nameCtrl.text.trim();

final String desc = descCtrl.text.trim();

final String image = imageCtrl.text.trim();

final double precio = double.tryParse(priceCtrl.text) ?? 0.0;

if (name.isEmpty) return;



if (product == null) {

await store.addProduct(name, precio, desc, image, selectedCatId);

} else {

await store.updateProduct(product.id, name, precio, desc, image, selectedCatId);

}



if (ctx.mounted) {

ScaffoldMessenger.of(ctx).showSnackBar(

const SnackBar(backgroundColor: Colors.green, content: Text('¡Producto guardado con éxito!')),

);

Navigator.pop(ctx);

}

} catch (e) {

showDialog(

context: ctx,

builder: (_) => AlertDialog(

title: const Text('Error al guardar producto'),

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

),

),

)

);

}



	@override

	Widget build(BuildContext context) {

	final store = Provider.of<StoreProvider>(context);

	return Scaffold(

	appBar: const CustomAppBar(showBack: true, titleText: 'ADM. PRODUCTOS'),

body: ListView.builder(

itemCount: store.products.length,

itemBuilder: (context, idx) {

final p = store.products[idx];

return Card(

margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

elevation: 2,

child: ListTile(

leading: CircleAvatar(backgroundColor: Colors.blue.shade100, child: Image.network(p.imageUrl, width: 32, errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 20))),

title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold)),

subtitle: Text('\$${p.price.toStringAsFixed(2)}'),

trailing: Row(

mainAxisSize: MainAxisSize.min,

children: [

IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(context, p)),

									IconButton(
										icon: const Icon(Icons.delete, color: Colors.red),
										onPressed: () async {
											final confirm = await showDialog<bool>(
												context: context,
												builder: (ctx) => AlertDialog(
													title: const Text('Confirmar eliminación'),
													content: Text('¿Eliminar el producto "${p.name}"? Esta acción es irreversible.'),
													actions: [
														TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancelar')),
														ElevatedButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Eliminar')),
													],
												),
											);

											if (confirm == true) {
												try {
													await store.deleteProduct(p.id);
													if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Producto eliminado')));
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

