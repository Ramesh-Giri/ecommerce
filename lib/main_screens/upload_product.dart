import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/snackbar.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  late double price;
  late int quantity;
  late String productName;
  late String productDescription;

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        color: Colors.blueGrey.shade100,
                        height: MediaQuery.of(context).size.width * 0.5,
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: const Center(
                            child: Text(
                          'Pick Images',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16.0),
                        )),
                      ),
                      Column(
                        children: [],
                      )
                    ],
                  ),
                  const Divider(
                    height: 30.0,
                    color: Colors.yellow,
                    thickness: 1.5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.4,
                      child: TextFormField(
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter price';
                          } else if (!value.isValidPrice()) {
                            return 'Please Enter valid price';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => price = double.parse(value!),
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Price',
                          hintText: 'price .. \$',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 0.5,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Quantity';
                          } else if (!value.isValidQuantity()) {
                            return 'Please Enter valid quantity';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => quantity = int.parse(value!),
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Quantity',
                          hintText: 'Add quantity',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      maxLines: 3,
                      maxLength: 100,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please Enter Product Name';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) => productName = value!,
                      decoration: textFormDecoration.copyWith(
                        labelText: 'Product Name',
                        hintText: 'Enter product name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: TextFormField(
                        maxLines: 5,
                        maxLength: 800,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Description';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => productDescription = value!,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Product Description',
                          hintText: 'Enter product description',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: () {},
              child: const Icon(
                Icons.photo_library,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              width: 6.0,
            ),
            FloatingActionButton(
              backgroundColor: Colors.yellow,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                } else {
                  MessageHandler.showSnackBar(
                      _scaffoldKey, 'Please fill all the necessary fields!');
                }
              },
              child: const Icon(
                Icons.upload,
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }
}

var textFormDecoration = InputDecoration(
  labelStyle: const TextStyle(color: Colors.purple),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.yellow, width: 1)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.blueAccent, width: 2)),
);

extension QuantityValidator on String {
  bool isValidQuantity() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}
