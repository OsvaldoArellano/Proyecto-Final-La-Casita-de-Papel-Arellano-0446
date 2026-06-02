import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context);
    final auth = Provider.of<AppAuthProvider>(context);
    final userOrders = store.listenToOrders().where((o) => o.userId == auth.currentUser?.id).toList();

    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'Historial'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: userOrders.isEmpty
              ? const Text('No hay historial de compras', textAlign: TextAlign.center, style: TextStyle(fontSize: 16))
              : Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Total')),
                          DataColumn(label: Text('Estado')),
                        ],
                        rows: userOrders.map((o) {
                          return DataRow(cells: [
                            DataCell(Text(o.id.substring(0, 4))),
                            DataCell(Text('\$${o.total.toStringAsFixed(2)}')),
                            DataCell(Text(o.status)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}