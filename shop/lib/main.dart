import 'dart:developer';
import 'package:provider/provider.dart';
import 'package:shop/models/order_list.dart';
import 'package:shop/screens/orders_page.dart';
import 'package:shop/screens/products_page.dart';
import 'models/cart.dart';
import 'models/product_list.dart';
import 'providers/counter.dart';
import 'package:flutter/material.dart';
import 'package:shop/screens/product_detail_page.dart';
import 'package:shop/utils/app_routes.dart';
import 'screens/products_overview_page.dart';
import 'screens/counter_page.dart';
import 'screens/cart_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: Colors.purple,
              secondary: Colors.deepOrange,
            ),
            fontFamily: 'Lato',
          ),
          //home: ProductsOverviewPage(),
          routes: { 
            AppRoutes.HOME: (contexto) => ProductsOverviewPage(),
            AppRoutes.PRODUCT_DETAIL: (contexto) => ProductDetailPage(),
            AppRoutes.CART: (contexto) => CartPage(),
            AppRoutes.ORDERS: (contexto) => OrdersPage(),
            AppRoutes.PRODUCTS: (contexto) => ProductsPage(),
          },
        ),
    );
    
  }
}
