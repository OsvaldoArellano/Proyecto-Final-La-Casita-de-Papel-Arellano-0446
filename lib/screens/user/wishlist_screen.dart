import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../widgets/custom_app_bar.dart';
import 'detalles_producto_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final wishlist = store.wishlist;

    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'Wishlist'),
      body: wishlist.isEmpty
          ? const Center(child: Text('No tienes elementos guardados en tu lista.'))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              // GridView de origen responsivo
              child: GridView.builder(
                itemCount: wishlist.length,
                // CAMBIO CLAVE: Usamos extensión máxima en lugar de un conteo fijo
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200, // Ancho máximo ideal para tarjetas de productos
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.80,  // Ajustado un poco para dar más aire vertical a la imagen y textos
                ),
                itemBuilder: (context, index) {
                  final prod = wishlist[index];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => DetallesProductoScreen(product: prod))
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE50914), 
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Alinea textos a la izquierda
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6), // Redondea las esquinas de la imagen
                              child: Image.network(
                                prod.imageUrl, 
                                fit: BoxFit.cover,
                                width: double.infinity, // Obliga a la imagen a llenar el ancho disponible
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            prod.name, 
                            maxLines: 1, // Evita que un título largo rompa el diseño
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${prod.price}', 
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                              // Movimos el IconButton aquí abajo para que no rompa el flujo vertical
                              SizedBox(
                                height: 32,
                                width: 32,
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.bookmark_remove, color: Colors.white, size: 22),
                                  onPressed: () => store.toggleWishlist(prod),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}