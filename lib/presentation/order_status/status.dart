import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

import '../cart/provider.dart';

class StatusPage extends StatelessWidget {
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
                title: Text('Order ID: ${order.id}'),
                subtitle: Text('Status: ${order['status']}'),
                trailing: IconButton(
                  icon: Icon(Icons.download),
                  onPressed: () => _generatePdfAndDownload(orders),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
