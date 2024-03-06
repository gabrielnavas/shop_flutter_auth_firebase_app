import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_flutter_app/exceptions/http_exception.dart';
import 'package:shop_flutter_app/models/product.dart';
import 'package:shop_flutter_app/providers/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final _nameFocus = FocusNode();
  final _descriptionUrlFocus = FocusNode();
  final _priceUrlFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Product? productToEdit;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Object? args = ModalRoute.of(context)?.settings.arguments;
    if (args == null) {
      return;
    }
    productToEdit = args as Product;
    if (productToEdit != null) {
      _imageUrlController.text = productToEdit!.imageUrl;
      _nameController.text = productToEdit!.name;
      _descriptionController.text = productToEdit!.description;
      _priceController.text = productToEdit!.price.toString();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameFocus.dispose();
    _descriptionUrlFocus.dispose();
    _priceUrlFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  void updateImage() {
    // it's update the _imageUrlController, because if
    // _imageUrlController.text is empty, need show image to text
    // and it's update the UI
    setState(() {});
  }

  bool _verifyForm() {
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return false;
    }

    _formKey.currentState?.save();
    return true;
  }

  void _submitForm(Product product) async {
    if (!_verifyForm()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final ProductList productList =
        Provider.of<ProductList>(context, listen: false);

    final msg = ScaffoldMessenger.of(context);

    if (productToEdit == null) {
      productList.addProduct(product).then((productIsAdded) {
        if (productIsAdded) {
          msg.hideCurrentSnackBar();
          msg.showSnackBar(
            SnackBar(
              content: const Text('Produto adicionado!'),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Desfazer',
                onPressed: () => productList.removeProduct(product).then((_) {
                  msg.hideCurrentSnackBar();
                  msg.showSnackBar(const SnackBar(
                    content: Text('Não foi possível desfazer essa ação.'),
                    duration: Duration(seconds: 3),
                  ));
                }).catchError((ex) {
                  msg.hideCurrentSnackBar();
                  msg.showSnackBar(
                    SnackBar(
                      content: Text((ex as HttpException).message),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }),
              ),
            ),
          );
          Navigator.of(context).pop();
        } else {
          return showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Não foi possível realizar a transação.'),
              content: const Text('Tente novamente mais tarde!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text(
                    'Ok',
                  ),
                ),
              ],
            ),
          );
        }
      });
    } else {
      // the global product from this screen is empty
      product.id = productToEdit!.id;

      productList.updateProduct(product).then((productIsAdded) {
        if (productIsAdded) {
          msg.hideCurrentSnackBar();
          msg.showSnackBar(
            const SnackBar(
              content: Text('Produto adicionado!'),
              duration: Duration(seconds: 3),
            ),
          );
          Navigator.of(context).pop(product);
        } else {
          return showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Não foi possível realizar a transação.'),
              content: const Text('Tente novamente mais tarde!'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: const Text(
                    'Ok',
                  ),
                ),
              ],
            ),
          );
        }
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Product product = Product.init();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        title: Text(
            productToEdit == null ? 'Adicionar produto' : 'Atualizar produto'),
        actions: [
          IconButton(
            onPressed: () => _submitForm(product),
            icon: const Icon(
              Icons.save,
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                        decoration: const InputDecoration(label: Text('Nome')),
                        controller: _nameController,
                        focusNode: _nameFocus,
                        textInputAction: TextInputAction.next,
                        autofocus: true,
                        validator: (value) => Product.validName(value ?? ''),
                        onChanged: (value) => _verifyForm(),
                        onSaved: (name) {
                          if (name != null && name.isNotEmpty) {
                            product.name = name;
                          }
                        }),
                    TextFormField(
                        decoration: const InputDecoration(label: Text('Preço')),
                        controller: _priceController,
                        focusNode: _priceUrlFocus,
                        textInputAction: TextInputAction.next,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        onChanged: (value) => _verifyForm(),
                        validator: (value) => Product.validPrice(
                            double.tryParse(value?.trim() ?? '-1') ?? -1),
                        onSaved: (price) {
                          if (price != null && price.isNotEmpty) {
                            product.price = double.parse(price);
                          }
                        }),
                    TextFormField(
                        decoration:
                            const InputDecoration(label: Text('Descrição')),
                        controller: _descriptionController,
                        focusNode: _descriptionUrlFocus,
                        keyboardType: TextInputType.multiline,
                        maxLines: 3,
                        validator: (value) =>
                            Product.validDescription(value ?? ''),
                        onChanged: (value) => _verifyForm(),
                        onSaved: (description) {
                          if (description != null && description.isNotEmpty) {
                            product.description = description;
                          }
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                              decoration: const InputDecoration(
                                  label: Text('Url da imagem')),
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocus,
                              onFieldSubmitted: (value) => _submitForm(product),
                              validator: (value) =>
                                  Product.validImageUrl(value ?? ''),
                              onChanged: (value) => _verifyForm(),
                              onSaved: (imageUrl) {
                                if (imageUrl != null && imageUrl.isNotEmpty) {
                                  product.imageUrl = imageUrl;
                                }
                              }),
                        ),
                        Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.only(top: 10, left: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(136, 130, 130, 130),
                                width: 1),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? const Text('informe a url')
                              : FittedBox(
                                  fit: BoxFit.cover,
                                  child:
                                      Image.network(_imageUrlController.text),
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
