import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/store_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_app_bar.dart';

class FormularioPagoScreen extends StatefulWidget {
  const FormularioPagoScreen({super.key});

  @override
  State<FormularioPagoScreen> createState() => _FormularioPagoScreenState();
}

class _FormularioPagoScreenState extends State<FormularioPagoScreen> {
  final _cardCtrl = TextEditingController();
  final _expCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StoreProvider>(context, listen: false);
    final auth = Provider.of<AppAuthProvider>(context, listen: false);

    return Scaffold(
      appBar: const CustomAppBar(showBack: true, titleText: 'Formulario de Pago'),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: _cardCtrl, decoration: const InputDecoration(labelText: 'Número de Tarjeta'), keyboardType: TextInputType.number),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(child: TextField(controller: _expCtrl, decoration: const InputDecoration(labelText: 'MM/AA'), keyboardType: TextInputType.datetime)),
                const SizedBox(width: 15),
                Expanded(child: TextField(controller: _cvvCtrl, decoration: const InputDecoration(labelText: 'CVV'), keyboardType: TextInputType.number)),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE50914), minimumSize: const Size(double.infinity, 50)),
              onPressed: () async {
                await store.checkoutOrder(auth.currentUser!.id, auth.currentUser!.name, auth.currentUser!.email);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Compra Realizada Exitosamente')));
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('PAGAR AHORA', style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}