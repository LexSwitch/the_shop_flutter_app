import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/screens/product_detail_screen.dart';

import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  // ProductItem({
  //   required this.id,
  //   required this.imageUrl,
  //   required this.title,
  // });

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
            leading: IconButton(
              onPressed: () {
                product.toggleFavoriteStatus();
              },
              color: Theme.of(context).colorScheme.secondary,
              icon: Icon(
                product.isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
            ),
            trailing: IconButton(
              onPressed: () {},
              color: Theme.of(context).colorScheme.secondary,
              icon: const Icon(
                Icons.shopping_cart,
              ),
            ),
            backgroundColor: Colors.black87,
            title: Text(
              product.title,
              textAlign: TextAlign.center,
            )),
      ),
    );
  }
}
