import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProductListPage extends StatelessWidget {
  final int categoryIndex;
  const ProductListPage({super.key, required this.categoryIndex});

  Future<List<Map<String, dynamic>>> _fetchProducts() async {
    String category;
    switch (categoryIndex) {
      case 1:
        category = 'Man';
        break;
      case 2:
        category = 'Woman';
        break;
      default:
        category = 'All'; // For 'All Products'
    }

    QuerySnapshot querySnapshot;
    if (category == 'All') {
      querySnapshot = await FirebaseFirestore.instance.collection('products').get();
    } else {
      querySnapshot = await FirebaseFirestore.instance
          .collection('products')
          .where('category', isEqualTo: category)
          .get();
    }

    return querySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryIndex == 0 ? 'All Products' : categoryIndex == 1 ? 'Man' : 'Woman'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Card(
                elevation: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        product['imageUrl'],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product['title'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('\$${product['price']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
