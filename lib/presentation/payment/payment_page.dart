import 'package:flutter/material.dart';
import '../../core/configs/theme/app_colors.dart';
import '../../main.dart';
import 'components/category_amount_selector.dart';
import 'components/category_payment_selector.dart';

class PaymentPages extends StatefulWidget {
  const PaymentPages({super.key});

  @override
  State<PaymentPages> createState() => _PaymentPagesState();
}

class _PaymentPagesState extends State<PaymentPages> {
  int _selectedPaymentIndex = 0;
  // int _selectedAmountIndex = 0;
  int totalAmount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Payment',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CategoryPaymentSelector(
              selectedPaymentIndex: _selectedPaymentIndex,
              onPaymentSelected: (index) {
                setState(() {
                  _selectedPaymentIndex = index;
                });
              },
            ),
            const SizedBox(
              height: 24,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Payment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
                ),
                Text(
                  '499',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            const Text(
              'Paid Amount',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 16,
            ),
            TextFormField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.attach_money_outlined),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            // CategoryAmountSelector(
            //   selectedAmountIndex: _selectedAmountIndex,
            //   onAmountSelected: (index) {
            //     setState(() {
            //       _selectedAmountIndex = index;
            //     });
            //   },
            // ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 116,
        shadowColor: Colors.black,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Change'),
                Text(
                  '\$ ${totalAmount.toString()} ',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyApp()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Pay Now',
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
