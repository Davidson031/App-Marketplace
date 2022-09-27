// ignore_for_file: prefer_const_constructors
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/providers/counter.dart';

import '../models/product_list.dart';

class ProductsOverviewPage extends StatefulWidget {
  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<ProductList>(context);
    final List<Product> listDeProdutos = provider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Marketplace'),
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: listDeProdutos.length,
        itemBuilder: (contexto, indice) {
          return ProductItem(product: listDeProdutos[indice]);
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}
