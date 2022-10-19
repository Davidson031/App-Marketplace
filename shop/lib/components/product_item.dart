import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product produto;

  const ProductItem({
    Key? key,
    required this.produto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(produto.imageUrl),
      ),
      title: Text(produto.name),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: produto,
                );
              },
              icon: const Icon(Icons.edit),
              color: Colors.purple,
            ),
            IconButton(
              onPressed: () {
                showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Tem Certeza?'),
                        content: const Text('Deseja excluir o produto?'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('Não')),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('Sim')),
                        ],
                      );
                    }).then((value) async {
                  if (value ?? false) {
                    try {
                      await Provider.of<ProductList>(
                        context,
                        listen: false,
                      ).deleteProduct(produto);
                    } on HttpException catch (error) {
                      msg.showSnackBar(
                        SnackBar(
                          content: Text(error.toString()),
                        ),
                      );
                    }
                  }
                });
              },
              icon: const Icon(Icons.delete),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
}
