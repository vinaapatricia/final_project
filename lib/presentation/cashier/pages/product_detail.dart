import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/configs/theme/app_colors.dart';
import '../../cart/cart_pages.dart';
import '../../cart/provider.dart';
import '../components/size_selector.dart';

class ProductDetailPage extends StatefulWidget {
  final DocumentSnapshot product;
  final int initialQuantity;

  const ProductDetailPage({
    super.key,
    required this.product,
    this.initialQuantity = 1,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late int _quantity;
  int _selectedSizeIndex = 0;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  void _incrementQuantity() {
    setState(() {
      _quantity++;
    });
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final productData = widget.product.data() as Map<String, dynamic>?;

    if (productData == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Product Detail'),
        ),
        body: Center(
          child: Text('Product data not available'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const IconTheme(
              data: IconThemeData(color: Colors.black),
              child: Icon(Icons.search),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const IconTheme(
              data: IconThemeData(color: Colors.black),
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => CartPage()));
            },
          ),
          const SizedBox(
            width: 16,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.network(
                  productData['imageUrl'],
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                color: AppColors.darkBackground,
                child: Text(
                  productData['flag'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                productData['title'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Size',
                style: TextStyle(
                  color: Color(0xFF232B39),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 0.10,
                ),
              ),
              const SizedBox(height: 16),
              SizeSelector(
                selectedSizeIndex: _selectedSizeIndex,
                onSizeSelected: (index) {
                  setState(() {
                    _selectedSizeIndex = index;
                  });
                },
              ),
              const SizedBox(height: 16),
              Text(
                'Stock',
                style: TextStyle(
                  color: Color(0xFF232B39),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 0.10,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                productData['stock'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        height: 140,
        shadowColor: Colors.black,
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Price : \$${productData['price']}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w700),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _decrementQuantity,
                      icon: Icon(Icons.remove),
                      color: Colors.black,
                    ),
                    Text(
                      '$_quantity',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    IconButton(
                      onPressed: _incrementQuantity,
                      icon: Icon(Icons.add),
                      color: Colors.black,
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<CartProvider>(context, listen: false)
                      .addItem(productData, _quantity);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added to cart!'),
                    ),
                  );
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
                  'Add to Cart',
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
