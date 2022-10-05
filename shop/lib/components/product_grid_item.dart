// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/screens/product_detail_page.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/cart.dart';

class ProductGridItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final carrinho = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, produto, _) => IconButton(
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                product.toggleFavorite();
              },
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              carrinho.addItem(product);
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
