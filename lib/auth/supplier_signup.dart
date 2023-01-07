import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utilities/app_color.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/snackbar.dart';

class SupplierRegister extends StatefulWidget {
  const SupplierRegister({Key? key}) : super(key: key);

  @override
  State<SupplierRegister> createState() => _SupplierRegisterState();
}

class _SupplierRegisterState extends State<SupplierRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  late bool hidePassword;

  late String storeName;
  late String email;
  late String password;
  late String storeLogo, uId;
  bool termsChecked = false;

  final ImagePicker _picker = ImagePicker();

  XFile? imageFile;
  dynamic _pickedImageError;

  bool isProcessing = false;

  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);

      setState(() {
        imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });

      print('$_pickedImageError');
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);

      setState(() {
        imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });
    }
  }

  void signUp() async {
    if (termsChecked) {
      if (_formKey.currentState!.validate()) {
        if (imageFile != null) {
          //if the image is added save all the form data  ie email, name, password
          _formKey.currentState!.save();

          try {
            setState(() {
              isProcessing = true;
            });

            await FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: email, password: password);

            var ref =
                FirebaseStorage.instance.ref('supplier_images/$email.jpg');
            await ref.putFile(File(imageFile!.path));

            storeLogo = await ref.getDownloadURL();

            var supplierRef =
                FirebaseFirestore.instance.collection('suppliers');

            uId = FirebaseAuth.instance.currentUser!.uid;

            await supplierRef.doc(uId).set({
              'storeName': storeName,
              'emailAddress': email,
              'storeLogo': storeLogo,
              'phoneNumber': '',
              'sId': uId,
              'coverImage': '',
            });

            //reset all the values in the form to default (empty).
            _formKey.currentState!.reset();
            setState(() {
              imageFile = null;
            });

            //
            MessageHandler.showSnackBar(
                _scaffoldKey, 'Store created successfully!');

            //go to supplier home screen
            Navigator.pushReplacementNamed(context, '/supplier_login');
          } on FirebaseException catch (e) {
            //show dialog incase of exception
            MessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
          }
        } else {
          MessageHandler.showSnackBar(_scaffoldKey, 'Please pick an image');
        }
      } else {
        MessageHandler.showSnackBar(_scaffoldKey, 'Please fill all fields');
      }
    } else {
      MessageHandler.showSnackBar(_scaffoldKey,
          'Please agree to terms and conditions before moving forward');
    }
    setState(() {
      isProcessing = false;
    });
  }

  @override
  void initState() {
    super.initState();
    hidePassword = true;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Image.asset(
                'images/inapp/logo.jpg',
                height: 130.0,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(children: [
                    const AuthHeaderLabel(
                      headerLabel: 'Sign Up',
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 40.0),
                          child: CircleAvatar(
                            radius: 60.0,
                            backgroundColor:
                                AppColor.appPrimary.withOpacity(0.4),
                            backgroundImage: imageFile == null
                                ? null
                                : FileImage(File(imageFile!.path)),
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.appPrimary,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15.0),
                                      topRight: Radius.circular(15.0))),
                              child: IconButton(
                                onPressed: _pickImageFromCamera,
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: AppColor.appPrimary,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(15.0),
                                      bottomRight: Radius.circular(15.0))),
                              child: IconButton(
                                onPressed: _pickImageFromGallery,
                                icon: const Icon(
                                  Icons.image_search,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        validator: (value) =>
                            value!.isEmpty ? 'Please Enter your name' : null,
                        onSaved: (value) => storeName = value!,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Store Name',
                          hintText: 'Enter your store name',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your Email';
                          } else if (value.isValidEmail() == false) {
                            return 'Please enter a valid email address';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) => email = value!,
                        keyboardType: TextInputType.emailAddress,
                        decoration: textFormDecoration.copyWith(
                          labelText: 'Email Address',
                          hintText: 'Enter your email address',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: TextFormField(
                        obscureText: hidePassword,
                        validator: (value) => value!.isEmpty
                            ? 'Please Enter your password'
                            : null,
                        onSaved: (value) => password = value!,
                        decoration: textFormDecoration.copyWith(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                },
                                icon: Icon(
                                  hidePassword
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: AppColor.appPrimary,
                                ))),
                      ),
                    ),
                    buildTermsCondition(),
                    isProcessing
                        ? const CircularProgressIndicator()
                        : AuthMainButton(
                            label: 'Sign Up',
                            onTap: signUp,
                          ),
                    HaveAccount(
                      haveAccount: 'already have account??',
                      actionLabel: 'Log In',
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, '/supplier_login');
                      },
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTermsCondition() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Checkbox(
            value: termsChecked,
            activeColor: AppColor.appPrimaryDark,
            onChanged: (value) {
              setState(() {
                termsChecked = !termsChecked;
              });
            }),
        const Text('I agree to'),
        InkWell(
          onTap: () {
            showModalBottomSheet(
                context: context,
                isDismissible: false,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 10.0),
                    child: ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(Icons.close))
                          ],
                        ),
                        const Center(
                          child: Text(
                            'Terms and Conditions',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        const Text(
                          '1) All the products will be monitored by the admin, and can be removed if necessary. Admin will contact you in that case',
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const Text(
                          '2) Products with unnecessarily high amount can be removed',
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const Text(
                          '3) Provide certificate of authenticity if the product price is more than \$500',
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        const Text(
                          '4) Delivery should be done within the expected date.',
                          style: TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                });
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'terms and conditions',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}
