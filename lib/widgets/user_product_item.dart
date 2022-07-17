import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/screens/edit_products_screen.dart';

import '../providers/products_provider.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String id;

  UserProductItem({
    required this.id,
    required this.title,
    required this.imageUrl,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(EditProductsScreen.routeName, arguments: id);
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  )),
              IconButton(
                  onPressed: () {
                    Provider.of<Products>(context, listen: false)
                        .deleteProduct(id);
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.error,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
