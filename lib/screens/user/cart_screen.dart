import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../providers/auth_provider.dart';
import 'formulario_pago_screen.dart';
import '../../widgets/custom_app_bar.dart';
import '../../models/product_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Removed unused processing set; reintroduce if you implement per-item processing state

  Future<void> _showEditQtyDialog(String productId, int currentQty) async {
    final controller = TextEditingController(text: currentQty.toString());
    final store = Provider.of<StoreProvider>(context, listen: false);

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar cantidad'),
        content: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              maxLines: 1,
              decoration: const InputDecoration(hintText: 'Cantidad'),
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              final parsed = int.tryParse(controller.text) ?? currentQty;
              if (parsed <= 0) {
                store.removeFromCartCompletely(productId);
              } else {
                store.updateCartQty(productId, parsed);
              }
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final auth = Provider.of<AppAuthProvider>(context);
    final productIds = store.cart.keys.toList();

    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'Mi Carrito'),
      body: Column(
        children: [
          Expanded(
            child: productIds.isEmpty
                ? const Center(child: Text('Tu carrito está vacío.'))
                : ListView.builder(
                    itemCount: productIds.length,
                    itemBuilder: (context, index) {
                      final productId = productIds[index];
                      final qty = store.cart[productId] ?? 0;
                      final prod = store.products.firstWhere(
                        (p) => p.id == productId,
                        orElse: () => ProductModel(id: '', name: 'Producto no disponible', price: 0.0, description: '', imageUrl: 'https://via.placeholder.com/50', categoryId: ''),
                      );

                      return ListTile(
                        key: ValueKey(productId),
                        leading: prod.id.isNotEmpty
                            ? Image.network(prod.imageUrl, width: 50, errorBuilder: (c, e, s) => Image.network('https://via.placeholder.com/50', width: 50))
                            : Image.network('https://via.placeholder.com/50', width: 50),
                        title: Text(prod.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('\$${prod.price} x $qty'),
                            const SizedBox(height: 8),
                            // Controls moved below to avoid horizontal overflow on small screens
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => store.removeOneFromCart(productId),
                                  tooltip: 'Quitar una unidad',
                                ),
                                GestureDetector(
                                  onTap: () => _showEditQtyDialog(productId, qty),
                                  child: Container(
                                    constraints: const BoxConstraints(minWidth: 36, maxWidth: 64),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text('$qty', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => store.addToCart(productId),
                                  tooltip: 'Agregar una unidad',
                                ),
                                // Delete action moved here as well
                                IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                  onPressed: () => store.removeFromCartCompletely(productId),
                                  tooltip: 'Eliminar producto',
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text('\$${store.cartTotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, color: Color(0xFFE50914), fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914), minimumSize: const Size(double.infinity, 50)),
                  onPressed: productIds.isEmpty
                      ? null
                      : () {
                          if (auth.currentUser == null) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Inicia sesión para poder comprar')));
                            return;
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const FormularioPagoScreen()));
                        },
                  child: const Text('REALIZAR COMPRA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}