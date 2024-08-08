import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/configs/theme/app_colors.dart';
import '../cart/provider.dart';
import '../order_status/order.dart';
import 'payment_success.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  String _selectedPaymentMethod = '';

  void _saveOrderToFirestore(BuildContext context) async {
    final cart = Provider.of<CartProvider>(context, listen: false);
    final orderData = {
      'items': cart.items
          .map((item) => {
                'title': item.product['title'],
                'quantity': item.quantity,
                'price': item.product['price'],
                'imageUrl': item.product['imageUrl'],
              })
          .toList(),
      'totalPrice': cart.getTotalPrice(),
      'paymentMethod': _selectedPaymentMethod,
      'status': 'Success',
      'timestamp': Timestamp.now(),
    };

    try {
      final docRef =
          await FirebaseFirestore.instance.collection('orders').add(orderData);
      print('Order saved successfully');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order saved successfully'),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentSuccessPage(
            orderDetails: {
              'orderId': docRef.id,
              ...orderData,
            },
            paymentMethod: _selectedPaymentMethod,
            cartItems: cart.items,
            finalAmount: cart.getTotalPrice(),
          ),
        ),
      );
    } catch (e) {
      print('Failed to save order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to save order: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final totalPrice = cart.getTotalPrice();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Payment',
          style: TextStyle(
            color: Color(0xFF232B39),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: cart.items.length,
            //     itemBuilder: (context, index) {
            //       final item = cart.items[index];
            //       return ListTile(
            //         leading: Image.network(
            //           item.product['imageUrl'],
            //           width: 50,
            //           height: 50,
            //           fit: BoxFit.cover,
            //         ),
            //         title: Text(item.product['title']),
            //         subtitle: Text('Quantity: ${item.quantity}'),
            //         trailing: Text(
            //           '\$${(double.tryParse(item.product['price'].toString()) ?? 0).toStringAsFixed(2)}',
            //         ),
            //       );
            //     },
            //   ),
            // ),
            // SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Payment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            ListTile(
              title: const Text('OVO'),
              leading: Radio<String>(
                value: 'OVO',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('GoPay'),
              leading: Radio<String>(
                value: 'GoPay',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('E-Wallet'),
              leading: Radio<String>(
                value: 'E-Wallet',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Bank Transfer (BRI)'),
              leading: Radio<String>(
                value: 'BRI',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Bank Transfer (BCA)'),
              leading: Radio<String>(
                value: 'BCA',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Bank Transfer (Mandiri)'),
              leading: Radio<String>(
                value: 'Mandiri',
                groupValue: _selectedPaymentMethod,
                onChanged: (value) {
                  setState(() {
                    _selectedPaymentMethod = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_selectedPaymentMethod.isNotEmpty) {
                    _saveOrderToFirestore(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderStatusPage(),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select a payment method'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    backgroundColor: AppColors.primary),
                child: const Text(
                  'Confirm Payment',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
