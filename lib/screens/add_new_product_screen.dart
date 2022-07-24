import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products_provider.dart';

class AddNewProduct extends StatefulWidget {
  static const routeName = '/add-product';

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  var _newProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController.text.isEmpty ||
          (!_imageUrlController.text.startsWith('http') ||
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') ||
              !_imageUrlController.text.endsWith('.jpg') ||
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
  }

  void _saveForm() {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      Provider.of<Products>(context, listen: false)
          .addProduct(_newProduct)
          .catchError((error) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occured'),
                  content: Text('Something went wrong.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text('Okay.'))
                  ],
                ));
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
        return;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add New Product'),
          actions: [
            IconButton(
              onPressed: _saveForm,
              icon: Icon(Icons.save),
            )
          ],
        ),
        body: _isLoading
            ? Center(
                child: SpinKitSpinningLines(
                  color: Theme.of(context).primaryColor,
                  size: 70,
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: [
                      TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Provide product title';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_priceFocusNode);
                        },
                        onSaved: (value) {
                          _newProduct = Product(
                              id: _newProduct.id,
                              title: value.toString(),
                              description: _newProduct.description,
                              price: _newProduct.price,
                              imageUrl: _newProduct.imageUrl);
                        },
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        focusNode: _priceFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Please enter a price greater than zero';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_descFocusNode);
                        },
                        onSaved: (value) {
                          _newProduct = Product(
                              id: _newProduct.id,
                              title: _newProduct.title,
                              description: _newProduct.description,
                              price: double.parse(value.toString()),
                              imageUrl: _newProduct.imageUrl);
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a description';
                          }
                          if (value.length < 10) {
                            return 'Should be at least ten characters long';
                          }
                        },
                        onSaved: (value) {
                          _newProduct = Product(
                              id: _newProduct.id,
                              title: _newProduct.title,
                              description: value.toString(),
                              price: _newProduct.price,
                              imageUrl: _newProduct.imageUrl);
                        },
                        maxLines: 3,
                        focusNode: _descFocusNode,
                        keyboardType: TextInputType.multiline,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _imageUrlController.text.isEmpty
                                ? Text('Enter a URL')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrlController.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              onEditingComplete: () {
                                setState(() {});
                              },
                              controller: _imageUrlController,
                              decoration: InputDecoration(
                                labelText: 'Image URL',
                              ),
                              keyboardType: TextInputType.url,
                              textInputAction: TextInputAction.done,
                              focusNode: _imageUrlFocusNode,
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              onSaved: (value) {
                                _newProduct = Product(
                                    id: _newProduct.id,
                                    title: _newProduct.title,
                                    description: _newProduct.description,
                                    price: _newProduct.price,
                                    imageUrl: value.toString());
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ));
  }
}
