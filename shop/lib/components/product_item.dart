import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

import '../models/product.dart';

class ProductItem extends StatelessWidget {
  final Product produto;

  const ProductItem({
    Key? key,
    required this.produto,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onPressed: (){},
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: (){},
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
