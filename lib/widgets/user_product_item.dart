import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class UserProductItem extends StatelessWidget {
  final String title;
  final String imageUrl;

  UserProductItem({required this.title, required this.imageUrl});
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
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    color: Theme.of(context).colorScheme.primary,
                  )),
              IconButton(
                  onPressed: () {},
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
