// ignore_for_file: prefer_const_constructors
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/providers/counter.dart';
import '../components/product_grid.dart';
import '../models/product_list.dart';

class ProductsOverviewPage extends StatefulWidget {
  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Marketplace'),
      ),
      body: ProductGrid(),
    );
  }
}


