import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/models/cart_item.dart';
import 'package:shop/models/product.dart';

class Cart with ChangeNotifier{

  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return  {..._items};
  }

  int get itemsCount { 
    return _items.length;
  }

  double get totalAmount {
    double total = 0;

    _items.forEach((key, itemDoCarrinho) { 
      total += itemDoCarrinho.price * itemDoCarrinho.quantity;
    });

    return total;

  }

  void addItem(Product product){

    if(_items.containsKey(product.id)){
      _items.update(product.id, (itemAtual){
        return CartItem(
          id: itemAtual.id, 
          productId: itemAtual.productId, 
          name: itemAtual.name, 
          quantity: itemAtual.quantity + 1, 
          price: itemAtual.price
          );
      });
    }else{
      _items.putIfAbsent(product.id, (){
        return CartItem(
          id: Random().nextDouble().toString(), 
          productId: product.id, 
          name: product.name, 
          quantity: 1, 
          price: product.price
          );
      });
    }

    notifyListeners();
  
  }

  void removeItem(String productId){
    _items.remove(productId);
    notifyListeners();
  }

  void clear(){
    _items = {};
    notifyListeners();
  }

}