import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {

  final Product produto = ModalRoute.of(context)?.settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: Text(produto.title),
      ),
      body: Center(),
    );
  }
}