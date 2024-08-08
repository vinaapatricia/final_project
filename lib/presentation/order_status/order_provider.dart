import 'package:flutter/material.dart';

import '../cart/models.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => _orders;

  void addOrder(OrderItem order) {
    _orders.add(order);
    notifyListeners();
  }
}

class OrderItem {
  final List<CartItem> items;
  final double totalPrice;
  final double tax;
  final double discount;

  OrderItem({
    required this.items,
    required this.totalPrice,
    this.tax = 0,
    this.discount = 0,
  });
}
