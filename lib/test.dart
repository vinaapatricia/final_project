import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/presentation/order_status/order.dart';
import 'package:flutter/material.dart';

import 'presentation/payment/payment_success.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => OrderStatusPage()));
              },
              child: Text('order status page')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentSuccessPage(
                              paymentMethod: '',
                              orderDetails: {},
                              cartItems: [],
                              finalAmount: 0.0,
                            )));
              },
              child: Text('order detail page'))
        ],
      ),
    );
  }
}
