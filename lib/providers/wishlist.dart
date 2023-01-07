import 'package:MON_PARFUM/providers/product.dart';
import 'package:flutter/material.dart';

class WishList extends ChangeNotifier {
  final List<Product> _list = [];

  List<Product> get getWishListItems => _list;

  int get getCount => _list.length;

  void addWishListItem(Product product) {
    _list.add(product);
    notifyListeners();
  }

  removeItem(String productId) {
    _list.remove(
        _list.where((product) => product.documentId == productId).first);
    notifyListeners();
  }

  clearWishList() {
    _list.clear();
    notifyListeners();
  }
}
