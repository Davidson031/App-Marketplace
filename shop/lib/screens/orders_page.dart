import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/components/app_drawer.dart';
import 'package:shop/components/order.dart';

import '../models/order_list.dart';

class OrdersPage extends StatelessWidget {
  @override


  Widget build(BuildContext context) {

    final aaa = Provider.of<OrderList>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
              itemCount: aaa.itemsCount,
              itemBuilder: (context, index) => OrderWidget(
                order: aaa.items[index],
              ),
            );
            // return Consumer<OrderList>(
            //   builder: (ctx, orders, child) => ListView.builder(
            //     itemCount: orders.itemsCount,
            //     itemBuilder: (context, i) =>
            //         OrderWidget(order: orders.items[i]),
            //   ),
            // );
          }
        }),
      ),
    );
  }
}
