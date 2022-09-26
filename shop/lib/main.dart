import 'package:flutter/material.dart';
import 'package:shop/screens/product_detail_page.dart';
import 'package:shop/utils/app_routes.dart';
import 'screens/products_overview_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.purple,
          secondary: Colors.deepOrange,
        ),
        fontFamily: 'Lato',
      ),
      home: ProductsOverviewPage(),
      routes: {
        AppRoutes.PRODUCT_DETAIL: (ctx) => ProductDetailPage(),
      },
    );
  }
}
