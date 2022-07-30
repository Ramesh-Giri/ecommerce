import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/widgets/snackbar.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

import '../utilities/categ_list.dart';

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
  late String productId;
  String category = "select category";
  late String subCategory = 'Subcategory';

  bool isUploading = false;

  List<String> subCategoryList = [];

  final ImagePicker _picker = ImagePicker();

  List<XFile>? imageFiles = [];
  dynamic _pickedImageError;

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);

      for (var item in pickedImage!) {
        setState(() {
          imageFiles!.add(item);
        });
      }
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
    }
  }

  void selectedMainCategory(String? value) {
    if (value == 'men') {
      subCategoryList = men;
    } else if (value == 'women') {
      subCategoryList = women;
    } else if (value == 'electronics') {
      subCategoryList = electronics;
    } else if (value == 'accessories') {
      subCategoryList = accessories;
    } else if (value == 'shoes') {
      subCategoryList = shoes;
    } else if (value == 'home & garden') {
      subCategoryList = homeandgarden;
    } else if (value == 'beauty') {
      subCategoryList = beauty;
    } else if (value == 'kids') {
      subCategoryList = kids;
    } else if (value == 'bags') {
      subCategoryList = bags;
    } else {
      subCategoryList = [];
    }

    setState(() {
      category = value!;
      subCategory = 'Subcategory';
    });
  }

  void uploadProduct() async {
    if (category != 'select category' && subCategory != 'Subcategory') {
      setState(() {
        isUploading = true;
      });
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (imageFiles!.isNotEmpty) {
          try {
            var imageUrls = [];
            for (var item in imageFiles!) {
              var ref = FirebaseStorage.instance
                  .ref('products/${path.basename(item.path)}');

              await ref.putFile(File(item.path)).whenComplete(() async {
                imageUrls.add(await ref.getDownloadURL());
              });
            }

            if (imageUrls.isNotEmpty) {
              var productsRef =
                  FirebaseFirestore.instance.collection('products');

              productId = const Uuid().v4();

              await productsRef.doc(productId).set({
                'price': price,
                'productId': productId,
                'sId': FirebaseAuth.instance.currentUser!.uid,
                'quantity': quantity,
                'discount': 0,
                'productName': productName,
                'productDescription': productDescription,
                'mainCategory': category,
                'subCategory': subCategory,
                'productImages': imageUrls,
              });
            }
          } catch (e) {
            print('Image upload issue: ${e.toString()}');
          }

          //clear textFields and images after saving
          setState(() {
            _formKey.currentState!.reset();
            imageFiles!.clear();
            category = "select category";
          });
        } else {
          MessageHandler.showSnackBar(
              _scaffoldKey, 'Please select product images!');
        }
      } else {
        MessageHandler.showSnackBar(
            _scaffoldKey, 'Please fill all the necessary fields!');
      }
    } else {
      MessageHandler.showSnackBar(
          _scaffoldKey, 'Please select product categories');
    }

    setState(() {
      isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                reverse: true,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Stack(
                            children: [
                              Container(
                                color: Colors.blueGrey.shade100,
                                height: MediaQuery.of(context).size.width * 0.5,
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: imageFiles!.isEmpty
                                    ? const Center(
                                        child: Text(
                                        'Pick Images',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 16.0),
                                      ))
                                    : ListView.builder(
                                        itemCount: imageFiles!.length,
                                        itemBuilder: (context, index) =>
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.file(File(
                                                  imageFiles![index].path)),
                                            )),
                              ),
                              if (imageFiles!.isNotEmpty)
                                Positioned(
                                    right: 0.0,
                                    child: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          imageFiles!.clear();
                                        });
                                      },
                                      icon: const Icon(Icons.delete_forever),
                                    ))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width * 0.5,
                              width: MediaQuery.of(context).size.width * 0.45,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        '* Select Category',
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 12.0),
                                      ),
                                      DropdownButton(
                                          isExpanded: true,
                                          iconSize: 40.0,
                                          menuMaxHeight: 500,
                                          iconEnabledColor: Colors.red,
                                          dropdownColor: Colors.yellow.shade300,
                                          value: category,
                                          items: maincateg
                                              .map<DropdownMenuItem<String>>(
                                                  (item) => DropdownMenuItem(
                                                        child: Text(
                                                            item.toString()),
                                                        value: item,
                                                      ))
                                              .toList(),
                                          onChanged: selectedMainCategory),
                                    ],
                                  ),
                                  if (subCategoryList.isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          '* Select Subcategory',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12.0),
                                        ),
                                        DropdownButton(
                                            menuMaxHeight: 500,
                                            isExpanded: true,
                                            iconSize: 40.0,
                                            iconEnabledColor: Colors.red,
                                            iconDisabledColor: Colors.black,
                                            dropdownColor:
                                                Colors.yellow.shade300,
                                            value: subCategory,
                                            items: subCategoryList
                                                .map<DropdownMenuItem<String>>(
                                                    (item) => DropdownMenuItem(
                                                          child: Text(
                                                              item.toString()),
                                                          value: item,
                                                        ))
                                                .toList(),
                                            onChanged: (value) {
                                              setState(() {
                                                subCategory = value.toString();
                                              });
                                            }),
                                      ],
                                    )
                                ],
                              ),
                            ),
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
            if (isUploading)
              Positioned(
                  child: Container(
                color: Colors.black87.withOpacity(0.7),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )),
          ],
        ),
        floatingActionButton: isUploading
            ? const SizedBox()
            : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                    backgroundColor: Colors.yellow,
                    onPressed: _pickImageFromGallery,
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
                    onPressed: uploadProduct,
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
