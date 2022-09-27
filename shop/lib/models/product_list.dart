import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:shop/data/dummy_data.dart';

class ProductList with ChangeNotifier {

  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];

  void addProductToList(Product product) {
    _items.add(product);
    notifyListeners();
  }

}