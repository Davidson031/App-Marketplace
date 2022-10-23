// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth.dart';
import '../models/product.dart';
import 'package:shop/components/product_grid_item.dart';
import '../models/product_list.dart';

class ProductGrid extends StatelessWidget {

  final bool showFavoriteOnly;

  const ProductGrid(this.showFavoriteOnly, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ProductList providerListaDeProdutos = Provider.of<ProductList>(context);
    final List<Product> listDeProdutos = showFavoriteOnly ? providerListaDeProdutos.favoriteItems : providerListaDeProdutos.items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: listDeProdutos.length,
      itemBuilder: (contexto, indice) {
        return ChangeNotifierProvider.value(
          value: listDeProdutos[indice],
          child: ProductGridItem(),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
