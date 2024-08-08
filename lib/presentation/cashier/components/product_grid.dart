import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductGrid extends StatefulWidget {
  final String searchQuery;
  final int selectedCategoryIndex;

  const ProductGrid({
    required this.searchQuery,
    required this.selectedCategoryIndex,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductGrid> createState() => _ProductGridState();
}

class _ProductGridState extends State<ProductGrid> {
  final CollectionReference products =
      FirebaseFirestore.instance.collection("products");

  Future<List<Map<String, dynamic>>> _fetchProducts(String category) async {
    QuerySnapshot querySnapshot;
    if (category == 'All') {
      querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
    } else {
      querySnapshot =
          await FirebaseFirestore.instance.collection('products').get();
    }
    return querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    String category;
    switch (widget.selectedCategoryIndex) {
      case 1:
        category = 'Man';
        break;
      case 2:
        category = 'Woman';
        break;
      default:
        category = 'All';
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchProducts(category),
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

        final products = snapshot.data!
            .where((product) => product['title']
                .toString()
                .toLowerCase()
                .contains(widget.searchQuery.toLowerCase()))
            .toList();

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
    );
  }
}
