import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/product_model.dart'; 
import '../../models/category_model.dart';
import '../../models/user_model.dart';
import '../../models/order_model.dart';

// Modelo local rápido para Categorías si no tenías uno independiente
class StoreProvider with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Listas internas en memoria
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  List<UserModel> _users = [];
  List<OrderModel> _orders = [];
  List<String> _wishlistProductIds = [];
  final Map<String, int> _cart = {}; // ID del producto -> Cantidad

  // Getters Públicos
  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;
  List<UserModel> get users => _users; 
  List<OrderModel> get orders => _orders;
  List<OrderModel> get allOrders => _orders;
  List<String> get wishlistProductIds => _wishlistProductIds;
  Map<String, int> get cart => _cart;

  StoreProvider() {
    // Escucha activa en tiempo real desde que se inicializa el proveedor
    _listenToCategories();
    _listenToProducts();
    _listenToUsers();
    _listenToOrders();
  }

  // ==========================================
  // 1. ESCUCHAS EN TIEMPO REAL (FIRESTORE)
  // ==========================================

  void _listenToCategories() {
    _db.collection('categories').snapshots().listen((snapshot) {
  _categories = snapshot.docs.map((doc) => CategoryModel.fromMap(doc.data(), doc.id)).toList();
      notifyListeners();
  }, onError: (error) => debugPrint("Error escuchando categorías: $error"));
  }

  void _listenToProducts() {
    _db.collection('products').snapshots().listen((snapshot) {
      _products = snapshot.docs.map((doc) {
        final data = doc.data();
        // Conversión segura de num/String a double para el precio
        double parsedPrice = 0.0;
        if (data['price'] != null) {
          parsedPrice = double.tryParse(data['price'].toString()) ?? 0.0;
        }

        return ProductModel(
          id: doc.id,
          name: data['name'] ?? 'Sin nombre',
          price: parsedPrice,
          description: data['description'] ?? '',
          imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
          categoryId: data['category'] ?? data['categoryId'] ?? '',
        );
      }).toList();
      notifyListeners();
  }, onError: (error) => debugPrint("Error escuchando productos: $error"));
  }
  
  void _listenToUsers() {
    // Intenta escuchar 'users', si tu colección se llama 'usuarios' cámbialo aquí
    _db.collection('users').snapshots().listen((snapshot) {
      final currentUid = FirebaseAuth.instance.currentUser?.uid;
      _users = snapshot.docs.map((doc) {
  final data = doc.data();
        if (doc.id == currentUid) {
          // Inicializa wishlist desde el documento del usuario si existe
          final wl = (data['wishlist'] as List?)?.map((e) => e.toString()).toList() ?? [];
          _wishlistProductIds = List<String>.from(wl);
          // Cargar carrito persistido en el documento del usuario si existe
          final cartField = data['cart'] as Map<String, dynamic>?;
          if (cartField != null) {
            _cart.clear();
            cartField.forEach((k, v) {
              _cart[k.toString()] = v is int ? v : int.tryParse(v.toString()) ?? 0;
            });
          }
        }
        return UserModel.fromMap({...data, 'id': doc.id});
      }).toList();
      notifyListeners();
    }, onError: (error) {
      debugPrint("Error escuchando usuarios (probando con 'usuarios'): $error");
      // Fallback automático por si la tabla está en español
      _db.collection('usuarios').snapshots().listen((snap) {
        _users = snap.docs.map((doc) {
          final data = doc.data();
          return UserModel.fromMap({...data, 'id': doc.id});
        }).toList();
        notifyListeners();
      });
    });
  }

  void _listenToOrders() {
    _db.collection('orders').orderBy('createdAt', descending: true).snapshots().listen((snapshot) {
      _orders = snapshot.docs.map((doc) {
  final data = doc.data();
        return OrderModel.fromMap(data, doc.id);
      }).toList();
      notifyListeners();
  }, onError: (error) => debugPrint("Error en órdenes: $error"));
  }

  // ==========================================
  // 2. OPERACIONES CRUD - CATEGORÍAS
  // ==========================================

  Future<void> addCategory(String name, String iconKey) async {
    try {
      await _db.collection('categories').add({
        'name': name.trim(),
        'iconKey': iconKey.isEmpty ? 'star' : iconKey.trim(),
      });
    } catch (e) {
  debugPrint("Error al añadir categoría: $e");
      rethrow;
    }
  }

  Future<void> updateCategory(String id, String newName, String newIconKey) async {
    try {
      await _db.collection('categories').doc(id).update({
        'name': newName.trim(),
        'iconKey': newIconKey.trim(),
      });
    } catch (e) {
  debugPrint("Error al actualizar categoría: $e");
      rethrow;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await _db.collection('categories').doc(id).delete();
    } catch (e) {
  debugPrint("Error al eliminar categoría: $e");
      rethrow;
    }
  }

  // ==========================================
  // 3. OPERACIONES CRUD - PRODUCTOS
  // ==========================================

  Future<void> addProduct(String name, double price, String description, String imageUrl, String category) async {
    try {
      await _db.collection('products').add({
        'name': name.trim(),
        'price': price,
        'description': description.trim(),
        'imageUrl': imageUrl.isEmpty ? 'https://via.placeholder.com/150' : imageUrl.trim(),
        'category': category.trim(),
      });
    } catch (e) {
  debugPrint("Error al añadir producto: $e");
      rethrow;
    }
  }

  Future<void> updateProduct(String id, String name, double price, String description, String imageUrl, String category) async {
    try {
      await _db.collection('products').doc(id).update({
        'name': name.trim(),
        'price': price,
        'description': description.trim(),
        'imageUrl': imageUrl.trim(),
        'category': category.trim(),
      });
    } catch (e) {
  debugPrint("Error al actualizar producto: $e");
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _db.collection('products').doc(id).delete();
    } catch (e) {
  debugPrint("Error al eliminar producto: $e");
      rethrow;
    }
  }

  // ==========================================
  // 4. GESTIÓN DE ROLES DE USUARIOS
  // ==========================================

  Future<void> updateUserRole(String userId, bool isAdmin) async {
    try {
      // Intenta actualizar usando 'users' o cambia a 'usuarios' si corresponde
      await _db.collection('users').doc(userId).update({
        'isAdmin': isAdmin,
      });
    } catch (e) {
  debugPrint("Error al actualizar rol de usuario: $e");
      // Intento alterno automático por si tu colección está en español
      await _db.collection('usuarios').doc(userId).update({
        'isAdmin': isAdmin,
      });
    }
  }

  // ==========================================
  // 5. SISTEMA DE FAVORITOS (WISHLIST)
  // ==========================================

  bool isInWishlist(String productId) {
    return _wishlistProductIds.contains(productId);
  }

  void toggleWishlist(ProductModel product) {
    if (_wishlistProductIds.contains(product.id)) {
      _wishlistProductIds.remove(product.id);
    } else {
      _wishlistProductIds.add(product.id);
    }
    notifyListeners();

    // Persistir favoritos en el documento del usuario (si está autenticado)
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        _db.collection('users').doc(uid).update({'wishlist': _wishlistProductIds});
      } catch (e) {
        // intenta fallback a 'usuarios' en caso de que la colección esté en español
        try {
          _db.collection('usuarios').doc(uid).update({'wishlist': _wishlistProductIds});
        } catch (_) {}
      }
    }
  }

  // ==========================================
  // 6. SISTEMA DEL CARRITO DE COMPRAS
  // ==========================================

  void addToCart(String productId) {
    if (_cart.containsKey(productId)) {
      _cart[productId] = _cart[productId]! + 1;
    } else {
      _cart[productId] = 1;
    }
    notifyListeners();
    _saveCartToUserIfAuthenticated();
  }

  void removeOneFromCart(String productId) {
    if (!_cart.containsKey(productId)) return;
    if (_cart[productId] == 1) {
      _cart.remove(productId);
    } else {
      _cart[productId] = _cart[productId]! - 1;
    }
    notifyListeners();
    _saveCartToUserIfAuthenticated();
  }

  void removeFromCartCompletely(String productId) {
    _cart.remove(productId);
    notifyListeners();
    _saveCartToUserIfAuthenticated();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
    _saveCartToUserIfAuthenticated();
  }

  double getCartTotal() {
    double total = 0.0;
    _cart.forEach((productId, quantity) {
      final product = _products.firstWhere(
        (p) => p.id == productId,
        orElse: () => ProductModel(id: '', name: '', price: 0.0, description: '', imageUrl: '', categoryId: ''),
      );
      total += product.price * quantity;
    });
    return total;
  }

  // Getter consumido por pantallas existentes
  double get cartTotal => getCartTotal();

  // Permite actualizar la cantidad directamente desde la UI
  void updateCartQty(String productId, int qty) {
    if (qty <= 0) {
      _cart.remove(productId);
    } else {
      _cart[productId] = qty;
    }
    notifyListeners();
    _saveCartToUserIfAuthenticated();
  }

  // Convierte la wishlist de IDs a lista de productos
  List<ProductModel> get wishlist {
    return _wishlistProductIds.map((id) => _products.firstWhere((p) => p.id == id, orElse: () => ProductModel(id: '', name: '', price: 0.0, description: '', imageUrl: '', categoryId: ''))).where((p) => p.id.isNotEmpty).toList();
  }

  // Compatible con llamadas del UI que esperan un listado
  List<OrderModel> listenToOrders() => _orders;

  // ==========================================
  // 7. PROCESAMIENTO DE PEDIDOS (ORDERS)
  // ==========================================

  Future<bool> checkoutOrder(String userId, String userName, String userEmail) async {
    if (_cart.isEmpty) return false;

    try {
      List<Map<String, dynamic>> orderItems = [];
      _cart.forEach((productId, quantity) {
        final product = _products.firstWhere(
          (p) => p.id == productId,
          orElse: () => ProductModel(id: '', name: 'Producto no disponible', price: 0.0, description: '', imageUrl: '', categoryId: ''),
        );
        if (product.id.isEmpty) {
          // Si el producto ya no existe en la lista local, saltarlo en el pedido
          return;
        }
        orderItems.add({
          'productId': productId,
          'productName': product.name,
          'price': product.price,
          'quantity': quantity,
        });
      });

      if (orderItems.isEmpty) {
        // Nada que agregar (todos los productos desaparecieron), abortar
        return false;
      }

      await _db.collection('orders').add({
        'userId': userId,
        'userName': userName,
        'userEmail': userEmail,
        'items': orderItems,
        'totalPrice': getCartTotal(),
        'status': 'Pendiente',
        'createdAt': FieldValue.serverTimestamp(),
      });

      clearCart();
      return true;
    } catch (e) {
  debugPrint("Error al procesar la orden de compra: $e");
      return false;
    }
  }
  
  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _db.collection('orders').doc(orderId).update({
        'status': newStatus.trim(),
      });
      // Nota: Como tenemos un StreamListener (_listenToOrders) activo,
      // la interfaz de usuario se actualizará automáticamente en tiempo real
      // en cuanto Firebase confirme el cambio.
    } catch (e) {
  debugPrint("Error al actualizar el estado del pedido: $e");
      rethrow;
    }
  }

  // Persistir el carrito en el documento del usuario autenticado
  Future<void> _saveCartToUserIfAuthenticated() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      // Convertir a Map<String, int> apto para Firestore
      final mapToSave = <String, int>{};
      _cart.forEach((k, v) => mapToSave[k] = v);
      await _db.collection('users').doc(uid).set({'cart': mapToSave}, SetOptions(merge: true));
    } catch (e) {
      // Fallback si la colección se llama 'usuarios'
      try {
        final mapToSave = <String, int>{};
        _cart.forEach((k, v) => mapToSave[k] = v);
        await _db.collection('usuarios').doc(uid).set({'cart': mapToSave}, SetOptions(merge: true));
      } catch (e) {
        debugPrint('No se pudo guardar el carrito en Firestore: $e');
      }
    }
  }
}