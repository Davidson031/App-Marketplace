import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'package:shop/data/dummy_data.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  final _baseUrl = 'https://shop-776fc-default-rtdb.firebaseio.com';

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => _items.where((p) => p.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  Future<void> addProductToList(Product product) {
      final future = http.post(
      Uri.parse('$_baseUrl/products.json'),
      body: jsonEncode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        "isFavorite": product.isFavorite,
      }),
    );
    
    
    return future.then<void>((response) {
      final id = jsonDecode(response.body)['name'];
      _items.add(Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite
      ));
      notifyListeners();
    });
  }

  Future<void> updateProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  void deleteProduct(Product product) {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      _items.removeWhere((p) => p.id == product.id);
      notifyListeners();
    }
  }

  Future<void> saveProduct(Map<String, Object> product) {
    bool hasId = product['id'] != null;

    final produto = Product(
      id: hasId ? product['id'] as String : Random().nextDouble().toString(),
      name: product['nome'] as String,
      description: product['descricao'] as String,
      price: product['preco'] as double,
      imageUrl: product['url'] as String,
      isFavorite: false,
    );

    if (hasId) {
      return updateProduct(produto);
    } else {
      return addProductToList(produto);
    }
  }
}



// bool _showFavoriteOnly = false;

//   List<Product> get items {
//     if (_showFavoriteOnly) {
//       return _items.where((p) => p.isFavorite).toList();
//     }
//     return [..._items];
//   }

//   void showFavoriteOnly() {
//     _showFavoriteOnly = true;
//     notifyListeners();
//   }

//   void showAll() {
//     _showFavoriteOnly = false;
//     notifyListeners();
//   }

//   void addProductToList(Product product) {
//     _items.add(product);
//     notifyListeners();
//   }