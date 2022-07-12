import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/providers/products_provider.dart';
import 'package:the_shop/widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: ListView.builder(
            itemCount: productsData.items.length,
            itemBuilder: (_, index) {
              return UserProductItem(
                  title: productsData.items[index].title,
                  imageUrl: productsData.items[index].imageUrl);
            }),
      ),
    );
  }
}
