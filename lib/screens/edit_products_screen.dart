import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:the_shop/providers/product.dart';
import 'package:the_shop/providers/products_provider.dart';
import 'package:the_shop/screens/user_products_screen.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  State<EditProductsScreen> createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceFocusNode = FocusNode();
  final _descFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );

  @override
  void dispose() {
    _imageUrlFocusNode.dispose();
    _priceFocusNode.dispose();
    _descFocusNode.dispose();
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlController.dispose();
  }

  var _initValues = {
    'title': '',
    'price': '',
    'description': '',
    'imageUrl': ''
  };
  var _isLoading = false;

  var _isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments as String;

      if (productId != '' || productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageUrl': ''
          // 'imageUrl': _editedProduct.imageUrl
        };

        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
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

  void _saveForm() {
    setState(() {
      _isLoading = true;
    });

    if (_form.currentState!.validate()) {
      _form.currentState!.save();
      setState(() {
        _isLoading = true;
      });
      if (_editedProduct.id != '' || _editedProduct.id != null) {
        Provider.of<Products>(context, listen: false)
            .updateProduct(_editedProduct.id, _editedProduct);

        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      } else {
        Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct)
            .then((_) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
          return;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
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
                      initialValue: _initValues['title'],
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
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: value.toString(),
                            description: _editedProduct.description,
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
                      },
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
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
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: _editedProduct.description,
                            price: double.parse(value.toString()),
                            imageUrl: _editedProduct.imageUrl);
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
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
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            title: _editedProduct.title,
                            description: value.toString(),
                            price: _editedProduct.price,
                            imageUrl: _editedProduct.imageUrl);
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
                            // validator: (value) {
                            //   if (value!.isEmpty) {
                            //     return 'Please enter an image URL';
                            //   }
                            //   if (!value.startsWith('http') ||
                            //       !value.startsWith('https')) {
                            //     return 'Enter a valid URL';
                            //   }
                            //   if (!value.endsWith('.png') ||
                            //       !value.endsWith('.jpg') ||
                            //       !value.endsWith('.jpeg')) {
                            //     return 'Enter a valid image URL';
                            //   }
                            //   return null;
                            // },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavourite: _editedProduct.isFavourite,
                                  title: _editedProduct.title,
                                  description: _editedProduct.description,
                                  price: _editedProduct.price,
                                  imageUrl: value.toString());
                            },
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
