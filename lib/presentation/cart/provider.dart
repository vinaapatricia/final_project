// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:final_project/presentation/cart/models.dart';
// // import 'package:flutter/material.dart';

// // class CartProvider with ChangeNotifier {
// //   List<CartItem> _items = [];

// //   List<CartItem> get items => _items;

// //   void addItem(DocumentSnapshot product, int quantity) {
// //     _items.add(CartItem(product: product, quantity: quantity));
// //     notifyListeners();
// //   }

// //   double getTotalPrice() {
// //     double total = 0;
// //     for (var item in _items) {
// //       double price = double.tryParse(item.product['price'].toString()) ?? 0;
// //       total += price * item.quantity;
// //     }
// //     return total;
// //   }
// // }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class CartItem {
//   final DocumentSnapshot product;
//   int quantity;

//   CartItem({
//     required this.product,
//     required this.quantity,
//   });
// }

// class CartProvider with ChangeNotifier {
//   List<CartItem> _items = [];

//   List<CartItem> get items => _items;

//   void addItem(DocumentSnapshot product, int quantity) {
//     final index = _items.indexWhere((item) => item.product.id == product.id);
//     if (index >= 0) {
//       _items[index].quantity++;
//     } else {
//       _items.add(CartItem(product: product, quantity: 1));
//     }
//     notifyListeners();
//   }

//   void removeItem(DocumentSnapshot product) {
//     _items.removeWhere((item) => item.product.id == product.id);
//     notifyListeners();
//   }

//   double getTotalPrice() {
//     return _items.fold(0, (total, item) {
//       return total +
//           (item.quantity *
//               (double.tryParse(item.product['price'].toString()) ?? 0));
//     });
//   }

//   void clearCart() {
//     _items.clear();
//     notifyListeners();
//   }
// }
import 'package:flutter/material.dart';
import 'models.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Map<String, dynamic> product, int quantity) {
    _items.add(CartItem(product: product, quantity: quantity));
    notifyListeners();
  }

  void updateQuantity(int index, int quantity) {
    if (quantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] =
          CartItem(product: _items[index].product, quantity: quantity);
    }
    notifyListeners();
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  double getTotalPrice() {
    return _items.fold(0, (total, item) {
      double price = double.tryParse(item.product['price'].toString()) ?? 0;
      return total + (price * item.quantity);
    });
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
