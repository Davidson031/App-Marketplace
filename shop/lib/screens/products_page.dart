import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/product_item.dart';

import '../models/product_list.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final produtos = Provider.of<ProductList>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciar Produtos'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: produtos.itemsCount,
          itemBuilder: (ctx, i){
            return Column(
              children: [
                ProductItem(produto: produtos.items[i]),
                const Divider(),
              ],
            ); 
          },
        ),
      ),
    );
  }
}
