// ignore_for_file: prefer_const_constructors

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import '../models/product.dart';
import 'package:shop/components/product_item.dart';

class ProductsOverviewPage extends StatelessWidget {

  final List<Product> listDeProdutos = dummyProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Marketplace'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: listDeProdutos.length,
        itemBuilder: (contexto, indice){
          return ProductItem(product: listDeProdutos[indice]);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3/2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10, 
        ), 
      ),
      
    );
  }



}