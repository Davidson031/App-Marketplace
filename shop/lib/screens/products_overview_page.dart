// ignore_for_file: prefer_const_constructors
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import '../components/badge.dart';
import '../models/cart.dart';
import '../models/product.dart';
import 'package:shop/components/product_grid_item.dart';
import 'package:shop/providers/counter.dart';
import '../components/product_grid.dart';
import '../models/product_list.dart';
import '../utils/app_routes.dart';

enum FiltroOpcoes { Favoritos, Todos }

class ProductsOverviewPage extends StatefulWidget {
  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(context, listen: false)
        .loadProducts()
        .then((value) => setState(() {
              _isLoading = false;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meu Marketplace'),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                value: FiltroOpcoes.Favoritos,
                child: Text('Somente Favoritos'),
              ),
              PopupMenuItem(
                value: FiltroOpcoes.Todos,
                child: Text('Todos'),
              ),
            ],
            onSelected: (FiltroOpcoes f) {
              setState(() {
                if (f == FiltroOpcoes.Favoritos) {
                  _showFavoriteOnly = true;
                } else {
                  _showFavoriteOnly = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.CART);
              },
              icon: Icon(Icons.shopping_cart),
            ),
            builder: (context, cart, child) => Badge(
              value: cart.itemsCount.toString(),
              child: child!,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductGrid(_showFavoriteOnly),
      drawer: AppDrawer(),
    );
  }
}
