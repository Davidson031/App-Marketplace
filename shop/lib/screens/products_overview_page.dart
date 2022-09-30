// ignore_for_file: prefer_const_constructors
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'package:shop/components/product_item.dart';
import 'package:shop/providers/counter.dart';
import '../components/product_grid.dart';
import '../models/product_list.dart';

enum FiltroOpcoes { Favoritos, Todos }

class ProductsOverviewPage extends StatefulWidget {
  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {

  bool _showFavoriteOnly = false;

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
        ],
      ),
      body: ProductGrid(_showFavoriteOnly),
    );
  }
}