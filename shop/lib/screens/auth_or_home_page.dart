import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/screens/auth_page.dart';
import 'package:shop/screens/products_overview_page.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Auth auth = Provider.of<Auth>(context);

    return auth.isAuthenticated ? ProductsOverviewPage() : AuthPage();
  }
}