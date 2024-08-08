import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/presentation/cart/models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PaymentSuccessPage extends StatelessWidget {
  final Map<String, dynamic> orderDetails;
  final String paymentMethod;
  final List<CartItem> cartItems;
  final double finalAmount;

  PaymentSuccessPage({
    Key? key,
    required this.orderDetails,
    required this.paymentMethod,
    required this.cartItems,
    required this.finalAmount,
  }) : super(key: key);

  Future<Uint8List> _downloadImage(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<void> _generateAndDownloadPdf() async {
    final pdf = pw.Document();

    final List<pw.ImageProvider> images = [];
    for (var item in cartItems) {
      final imageData = await _downloadImage(item.product['imageUrl']);
      images.add(pw.MemoryImage(imageData));
    }

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Payment Success',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Order ID: ${orderDetails['orderId']}'),
              pw.Text('Status: Success'),
              pw.SizedBox(height: 20),
              pw.Text('Items Ordered:'),
              for (int i = 0; i < cartItems.length; i++)
                pw.Row(
                  children: [
                    pw.Image(
                      images[i],
                      width: 50,
                      height: 50,
                      fit: pw.BoxFit.cover,
                    ),
                    pw.SizedBox(width: 10),
                    pw.Text(cartItems[i].product['title']),
                    pw.SizedBox(width: 10),
                    pw.Text(
                        '\$${cartItems[i].product['price']} x ${cartItems[i].quantity}'),
                  ],
                ),
              pw.SizedBox(height: 20),
              pw.Text('Total Amount: \$${finalAmount.toStringAsFixed(2)}'),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File("${output.path}/receipt.pdf");
    await file.writeAsBytes(await pdf.save());

    OpenFilex.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Payment Successful!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _generateAndDownloadPdf,
              child: const Text('Download Receipt'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Back to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
