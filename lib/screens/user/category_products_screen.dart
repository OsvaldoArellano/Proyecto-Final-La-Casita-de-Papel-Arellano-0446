import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../widgets/custom_app_bar.dart';
import 'detalles_producto_screen.dart';

class CategoryProductsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;
  const CategoryProductsScreen({super.key, required this.categoryId, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final categoryProducts = store.products.where((p) => p.categoryId == categoryId).toList(); 

    return Scaffold(
      appBar: CustomAppBar(showBack: true, titleText: categoryName.toUpperCase()),
      body: categoryProducts.isEmpty
          ? const Center(
              child: Text(
                'No hay productos en esta categoría.',
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: categoryProducts.length,
                // CAMBIO CLAVE: Configuración adaptativa para el Grid
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200, // Ancho máximo ideal para que las tarjetas no se deformen
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.82,  // Relación de aspecto vertical adecuada para contener imagen y textos
                ),
                itemBuilder: (context, idx) {
                  final product = categoryProducts[idx];
                  return GestureDetector(
                    onTap: () => Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (_) => DetallesProductoScreen(product: product))
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE50914), 
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Alineación de textos limpia a la izquierda
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6), // Bordes redondeados sutiles para la imagen
                              child: Image.network(
                                product.imageUrl, 
                                fit: BoxFit.cover,
                                width: double.infinity, // Forzamos a que expanda todo el ancho de su celda
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            product.name, 
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis, // Si el nombre del producto es largo, añade "..." de forma segura
                            style: const TextStyle(
                              color: Colors.white, 
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '\$${product.price}', 
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
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