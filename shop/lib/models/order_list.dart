// ignore_for_file: prefer_final_fields

import 'dart:math';

import 'package:flutter/material.dart';

import 'cart.dart';
import 'order.dart';

class OrderList with ChangeNotifier{

List<Order> _items = [];

List<Order> get items {
  return [..._items];
}

int get itemsCount {
  return _items.length;
}

//transformando o carrinho em um pedido
void addOrder(Cart cart){
  _items.insert(
    0, 
    Order(
      id: Random().nextDouble().toString(), 
      total: cart.totalAmount,
      date: DateTime.now(),
      products: cart.items.values.toList(),
    ),
  );
  notifyListeners();
}


}
