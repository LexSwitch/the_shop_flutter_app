import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/providers/cart.dart';
import 'package:the_shop/providers/orders.dart';
import 'package:the_shop/screens/cart_screen.dart';
import 'package:the_shop/screens/product_detail_screen.dart';
import 'package:the_shop/screens/products_overview_screen.dart';
import './providers/products_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Products(),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (context) => Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            fontFamily: 'Lato',
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
            ).copyWith(
              secondary: Colors.deepOrange,
            )),
        home: ProductsOverviewScreen(),
        routes: {
          CartScreen.routeName: (ctx) => CartScreen(),
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
