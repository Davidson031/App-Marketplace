import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:shop/providers/counter.dart';
import '../models/product.dart';

class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exemplo Counter'),
      ),
      body: Column(
        children: [
          Text(CounterProvider.of(context)?.state.value.toString() ?? '0'),
          IconButton(
              onPressed: () {
                setState(() {
                  CounterProvider.of(context)?.state.inc();
                });
              },
              icon: Icon(Icons.add)),
          IconButton(
              onPressed: () {
                setState(() {
                  CounterProvider.of(context)?.state.dec();
                });
              },
              icon: Icon(Icons.remove))
        ],
      ),
    );
  }
}
