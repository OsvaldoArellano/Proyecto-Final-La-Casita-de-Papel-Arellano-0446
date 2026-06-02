import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/store_provider.dart';
import '../../widgets/custom_app_bar.dart';

class DetallesProductoScreen extends StatelessWidget {
  final ProductModel product;
  const DetallesProductoScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final isFav = store.isInWishlist(product.id);

    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'DETALLES'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(color: const Color(0xFFE50914), borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(child: Image.network(product.imageUrl, fit: BoxFit.contain)),
              ),
              const SizedBox(height: 15),
              Text(product.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('\$${product.price.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, color: Colors.white70)),
              const SizedBox(height: 10),
              Text(product.description, style: const TextStyle(color: Colors.white, fontSize: 14)),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(isFav ? Icons.bookmark : Icons.bookmark_border, color: Colors.white, size: 30),
                    onPressed: () => store.toggleWishlist(product),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFFE50914)),
                    onPressed: () {
                      store.addToCart(product.id);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Añadido al carrito')));
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Añadir al Carrito'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}