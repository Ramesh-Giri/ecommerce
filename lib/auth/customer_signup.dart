import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
  late String profileImageUrl, uId;

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
    if (_formKey.currentState!.validate()) {
      if (imageFile != null) {
        //if the image is added save all the form data  ie email, name, password
        _formKey.currentState!.save();

        try {
          setState(() {
            isProcessing = true;
          });

          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          var ref = FirebaseStorage.instance.ref('customer_images/$email.jpg');
          await ref.putFile(File(imageFile!.path));

          profileImageUrl = await ref.getDownloadURL();

          var customerRef = FirebaseFirestore.instance.collection('customers');

          uId = FirebaseAuth.instance.currentUser!.uid;

          await customerRef.doc(uId).set({
            'fullName': name,
            'emailAddress': email,
            'profileImageUrl': profileImageUrl,
            'phoneNumber': '',
            'address': '',
            'cId': uId
          });

          //reset all the values in the form to default (empty).
          _formKey.currentState!.reset();
          setState(() {
            imageFile = null;
          });

          //
          MessageHandler.showSnackBar(
              _scaffoldKey, 'User created successfully!');

          //go to customer home screen
          Navigator.pushReplacementNamed(context, '/customer_home');
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
                          context, '/customer_signin');
                    },
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
