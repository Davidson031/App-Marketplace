import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = [];

  final _url = 'https://shop-776fc-default-rtdb.firebaseio.com/products.json';

  List<Product> get items => [..._items];

  List<Product> get favoriteItems => _items.where((p) => p.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  Future<void> loadProducts() async {

    _items.clear();
    
    final response = await http.get(Uri.parse(_url));

    if(response.body =='null') return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((productId, productData) {
      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: productData['isFavorite'],
        ),
      );
    });

    notifyListeners();
  }

  Future<void> addProductToList(Product product) async {
    final response = await http.post(
      Uri.parse(_url),
      body: jsonEncode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
        "isFavorite": product.isFavorite,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite));
    notifyListeners();
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