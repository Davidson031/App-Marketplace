import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';
import '../models/product.dart';
import '../utils/constants.dart';

class ProductList with ChangeNotifier {
  String _token;
  List<Product> _items = [];
  final String _userId;
  List<Product> get items => [..._items];

  List<Product> get favoriteItems => _items.where((p) => p.isFavorite).toList();

  int get itemsCount {
    return _items.length;
  }

  ProductList([this._token = '', this._items = const [], this._userId = '']);

  Future<void> loadProducts() async {
    _items.clear();

    final response = await http.get(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
    );

    if (response.body == 'null') return;

    final favoritesResp = await http.get(
      Uri.parse('${Constants.USER_FAVORITES_URL}/$_userId.json?auth=$_token'),
    );

    Map<String, dynamic> favData =
        favoritesResp.body == 'null' ? {} : jsonDecode(favoritesResp.body);

    Map<String, dynamic> data = jsonDecode(response.body);

    
    data.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;

      _items.add(
        Product(
          id: productId,
          name: productData['name'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  Future<void> addProductToList(Product product) async {
    final response = await http.post(
      Uri.parse('${Constants.PRODUCT_BASE_URL}.json?auth=$_token'),
      body: jsonEncode({
        "name": product.name,
        "description": product.description,
        "price": product.price,
        "imageUrl": product.imageUrl,
      }),
    );

    final id = jsonDecode(response.body)['name'];
    _items.add(Product(
        id: id,
        name: product.name,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse(
            '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
        body: jsonEncode({
          "name": product.name,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        }),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final products = _items[index];
      _items.remove(products);
      notifyListeners();

      final response = await http.delete(
        Uri.parse(
            '${Constants.PRODUCT_BASE_URL}/${product.id}.json?auth=$_token'),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();
        throw HttpException(
          msg: 'Não foi possível excluír o produto',
          statusCode: response.statusCode,
        );
      }
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