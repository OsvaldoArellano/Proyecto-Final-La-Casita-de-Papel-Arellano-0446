import 'package:cloud_firestore/cloud_firestore.dart';

class OrderItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 1,
      price: (map['price'] as num).toDouble(),
    );
  }
}

class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status; // 'en proceso', 'enviado', 'entregado'
  final DateTime date;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((i) => i.toMap()).toList(),
      'total': total,
      'status': status,
      'date': Timestamp.fromDate(date),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderModel(
      id: documentId,
      userId: map['userId'] ?? '',
      items: (map['items'] as List? ?? [])
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList(),
      total: ((map['total'] ?? map['totalPrice']) as num? ?? 0).toDouble(),
      status: map['status'] ?? 'en proceso',
      date: (() {
        final ts = map['date'] ?? map['createdAt'];
        if (ts is Timestamp) return ts.toDate();
        if (ts is int) return DateTime.fromMillisecondsSinceEpoch(ts);
        if (ts is String) return DateTime.tryParse(ts) ?? DateTime.now();
        return DateTime.now();
      })(),
    );
  }
}