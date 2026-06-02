import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../providers/store_provider.dart';

// import '../../providers/theme_provider.dart';
import '../../widgets/custom_app_bar.dart';



class AdminOrdersScreen extends StatelessWidget {

  const AdminOrdersScreen({super.key});



  @override

  Widget build(BuildContext context) {

  final store = Provider.of<StoreProvider>(context);



    return Scaffold(

      appBar: const CustomAppBar(showBack: true, titleText: 'ADM. PEDIDOS'),

      body: ListView.builder(

        itemCount: store.orders.length,

        itemBuilder: (context, idx) {

          final order = store.orders[idx];

          final idDisplay = (order.id.length >= 5) ? order.id.substring(0, 5) : order.id;

          // Asegurar que el valor actual de status esté presente en las opciones

          final statuses = <String>{order.status, 'Pendiente', 'en proceso', 'enviado', 'entregado'}.toList();

          return Card(

            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

            elevation: 2,

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

            child: Padding(

              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),

              child: Row(

                children: [

                  Expanded(

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Text('Pedido: #$idDisplay', style: const TextStyle(fontWeight: FontWeight.bold)),

                        const SizedBox(height: 6),

                        Text('Total: \$${order.total.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black87)),

                        const SizedBox(height: 4),

                        Text('Estado: ${order.status.toUpperCase()}', style: const TextStyle(fontSize: 12, color: Colors.black54)),

                      ],

                    ),

                  ),

                  const SizedBox(width: 8),

                  DropdownButton<String>(

                    value: order.status,

                    items: statuses.map((status) => DropdownMenuItem(value: status, child: Text(status))).toList(),

                    onChanged: (newStatus) async {

                      if (newStatus != null) await store.updateOrderStatus(order.id, newStatus);

                    },

                  ),

                ],

              ),

            ),

          );

        },

      ),

    );

  }

}