import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String _selectedSortOption = 'Latest Orders';
  String _selectedFilterCategory = 'All';
  double _minPrice = 0;
  double _maxPrice = 1000; // Set a reasonable max value

  // Dummy categories for demonstration
  List<String> _categories = ['All', 'Electronics', 'Clothing', 'Home'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _selectedFilterCategory = value;
              });
            },
            itemBuilder: (context) {
              return _categories.map((category) {
                return PopupMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList();
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog();
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getFilteredAndSortedOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return ListTile(
                title: Text('Order ID: ${order.id}'),
                subtitle: Text(
                    'Total Price: \$${order['totalPrice'].toStringAsFixed(2)}'),
                trailing: Text(
                    'Date: ${order['timestamp'].toDate().toString()}'),
              );
            },
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> _getFilteredAndSortedOrders() {
    final firestore = FirebaseFirestore.instance.collection('orders');

    Query query = firestore;

    // Filter by category
    if (_selectedFilterCategory != 'All') {
      query = query.where('category', isEqualTo: _selectedFilterCategory);
    }

    // Filter by price range
    query = query.where('totalPrice', isGreaterThanOrEqualTo: _minPrice)
                 .where('totalPrice', isLessThanOrEqualTo: _maxPrice);

    // Sort by selected option
    switch (_selectedSortOption) {
      case 'Price (Low to High)':
        query = query.orderBy('totalPrice');
        break;
      case 'Price (High to Low)':
        query = query.orderBy('totalPrice', descending: true);
        break;
      case 'Latest Orders':
        query = query.orderBy('timestamp', descending: true);
        break;
      case 'Oldest Orders':
        query = query.orderBy('timestamp');
        break;
      default:
        query = query.orderBy('timestamp', descending: true);
        break;
    }

    // Debug: Print query parameters
    print('Query: ${query}');

    return query.snapshots();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    value: _selectedSortOption,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedSortOption = newValue!;
                      });
                    },
                    items: <String>[
                      'Latest Orders',
                      'Oldest Orders',
                      'Price (Low to High)',
                      'Price (High to Low)',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  Text('Min Price: \$${_minPrice.toStringAsFixed(2)}'),
                  Slider(
                    min: 0,
                    max: _maxPrice, // Adjust max value
                    divisions: 100,
                    value: _minPrice,
                    onChanged: (value) {
                      if (value <= _maxPrice) {
                        setState(() {
                          _minPrice = value;
                        });
                      }
                    },
                  ),
                  Text('Max Price: \$${_maxPrice.toStringAsFixed(2)}'),
                  Slider(
                    min: _minPrice, // Set min value to avoid invalid range
                    max: 1000, // Set a reasonable max value
                    divisions: 100,
                    value: _maxPrice,
                    onChanged: (value) {
                      if (value >= _minPrice) {
                        setState(() {
                          _maxPrice = value;
                        });
                      }
                    },
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );
  }
}
