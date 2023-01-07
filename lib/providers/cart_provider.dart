import 'package:MON_PARFUM/providers/product.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getItems => _list;

  double get totalPrice {
    var total = 0.0;

    for (var item in _list) {
      total += item.price * item.quantity;
    }

    return total;
  }

  int get getCount => _list.length;

  void addItem(Product product) {
    _list.add(product);
    notifyListeners();
  }

  void increment(Product product) {
    product.increase();
    notifyListeners();
  }

  void decrement(Product product) {
    product.decrease();
    notifyListeners();
  }

  removeItem(Product product) {
    _list.remove(product);
    notifyListeners();
  }

  clearCart() {
    _list.clear();
    notifyListeners();
  }
}
