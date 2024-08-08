// import 'package:final_project/presentation/order_status/status.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../cart/provider.dart';

// import 'package:cloud_firestore/cloud_firestore.dart';

// class OrderStatusPage extends StatelessWidget {
//   Future<void> _saveOrderToFirestore(BuildContext context) async {
//     final cart = Provider.of<CartProvider>(context, listen: false);

//     final orderData = {
//       'items': cart.items
//           .map((item) => {
//                 'title': item.product['title'],
//                 'quantity': item.quantity,
//                 'price': item.product['price'],
//               })
//           .toList(),
//       'totalPrice': cart.getTotalPrice(),
//       'status': 'Success',
//       'timestamp': Timestamp.now(),
//     };

//     await FirebaseFirestore.instance.collection('orders').add(orderData);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Status'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton(
//                 onPressed: () async {
//                   await _saveOrderToFirestore(context);
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Payment Successful!'),
//                     ),
//                   );
//                 },
//                 child: Text('Done Payment'),
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => StatusPage(),
//                     ),
//                   );
//                 },
//                 child: Text('Go to Status Page'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class OrderStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Status'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('orders').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order #${order.id}'),
                subtitle: Text('Total: \$${order['totalPrice']}'),
                trailing: IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () async {
                    await _generatePdfAndDownload(orders);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _downloadOrderPdf(DocumentSnapshot order) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Order #${order.id}',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 16),
              pw.Text('Items:',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              ...order['items'].map<pw.Widget>((item) {
                return pw.Text(
                  '${item['title']} - Quantity: ${item['quantity']} - \$${item['price']}',
                  style: pw.TextStyle(fontSize: 16),
                );
              }).toList(),
              pw.SizedBox(height: 16),
              pw.Text('Total Price: \$${order['totalPrice']}',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text('Tax: \$${order['tax']}',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              if (order['discount'] > 0)
                pw.Text('Discount: \$${order['discount']}',
                    style: pw.TextStyle(
                        fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.Text('Status: ${order['status']}',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> _generatePdfAndDownload(List<DocumentSnapshot> orders) async {
    final pdf = pw.Document();
    for (var order in orders) {
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Order ID: ${order.id}',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 16),
                pw.Text('Items:'),
                pw.SizedBox(height: 8),
                ...order['items'].map<pw.Widget>((item) {
                  return pw.Text('${item['title']} x ${item['quantity']}');
                }).toList(),
                pw.SizedBox(height: 8),
                pw.Text(
                    'Total Price: \$${order['totalPrice'].toStringAsFixed(2)}'),
                pw.SizedBox(height: 16),
                pw.Text('Status: ${order['status']}'),
                pw.SizedBox(height: 16),
                pw.Text('Timestamp: ${order['timestamp'].toDate().toString()}'),
                pw.Divider(),
              ],
            );
          },
        ),
      );
    }
    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'order_details.pdf');
  }
}
