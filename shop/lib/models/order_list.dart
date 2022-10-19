// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';
import 'cart.dart';
import 'order.dart';

class OrderList with ChangeNotifier {
  List<Order> _items = [];

  List<Order> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

//transformando o carrinho em um pedido
  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse('${Constants.ORDER_BASE_URL}.json'),
      body: jsonEncode({
        "total": cart.totalAmount,
        "date": date.toIso8601String(),
        "products": cart.items.values.map(
          (cartItem) => {
            "id": cartItem.id,
            "productId": cartItem.productId,
            "name": cartItem.name,
            "quantity": cartItem.quantity,
            "price": cartItem.price
          },
        ).toList(),
      }),
    );

    final id = jsonDecode(response.body)['name'];

    _items.insert(
      0,
      Order(
        id: id,
        total: cart.totalAmount,
        date: date,
        products: cart.items.values.toList(),
      ),
    );
    notifyListeners();
  }
}
