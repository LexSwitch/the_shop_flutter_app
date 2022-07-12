import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class EditProductsScreen extends StatefulWidget {
  const EditProductsScreen({Key? key}) : super(key: key);

  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Container(),
    );
  }
}
