import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../widgets/auth_widgets.dart';
import '../widgets/snackbar.dart';

class CustomerRegister extends StatefulWidget {
  const CustomerRegister({Key? key}) : super(key: key);

  @override
  State<CustomerRegister> createState() => _CustomerRegisterState();
}

class _CustomerRegisterState extends State<CustomerRegister> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  late bool hidePassword;

  late String name;
  late String email;
  late String password;

  final ImagePicker _picker = ImagePicker();

  XFile? imageFile;
  dynamic _pickedImageError;

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

      print('$_pickedImageError');
    }
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
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
                          backgroundColor: Colors.purpleAccent,
                          backgroundImage: imageFile == null
                              ? null
                              : FileImage(File(imageFile!.path)),
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
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
                            decoration: const BoxDecoration(
                                color: Colors.purple,
                                borderRadius: BorderRadius.only(
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
                      onSaved: (value) => name = value!,
                      decoration: textFormDecoration.copyWith(
                        labelText: 'Full Name',
                        hintText: 'Enter your full name',
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
                      validator: (value) =>
                      value!.isEmpty ? 'Please Enter your password' : null,
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
                                color: Colors.purple,
                              ))),
                    ),
                  ),
                  AuthMainButton(
                    label: 'Sign Up',
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        if (imageFile != null) {
                          _formKey.currentState!.reset();

                          setState(() {
                            imageFile = null;
                          });
                        } else {
                          MessageHandler.showSnackBar(
                              _scaffoldKey, 'Please pick an image');
                        }

                        _formKey.currentState!.save();
                      } else {
                        MessageHandler.showSnackBar(
                            _scaffoldKey, 'Please fill all fields');
                      }
                    },
                  ),
                  HaveAccount(
                    haveAccount: 'already have account??',
                    actionLabel: 'Log In',
                    onTap: () {},
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
