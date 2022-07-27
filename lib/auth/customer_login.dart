import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/auth_widgets.dart';
import '../widgets/snackbar.dart';

class CustomerLogin extends StatefulWidget {
  const CustomerLogin({Key? key}) : super(key: key);

  @override
  State<CustomerLogin> createState() => _CustomerLoginState();
}

class _CustomerLoginState extends State<CustomerLogin> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  late bool hidePassword;

  late String email;
  late String password;

  bool isProcessing = false;

  void signIn() async {
    if (_formKey.currentState!.validate()) {
      //if the image is added save all the form data  ie email, name, password
      _formKey.currentState!.save();

      try {
        setState(() {
          isProcessing = true;
        });

        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        //reset all the values in the form to default (empty).
        _formKey.currentState!.reset();

        //
        MessageHandler.showSnackBar(_scaffoldKey, 'Login successfully!');

        //go to customer home screen
        Navigator.pushReplacementNamed(context, '/customer_home');
      } on FirebaseException catch (e) {
        //show dialog incase of exception
        MessageHandler.showSnackBar(_scaffoldKey, e.message.toString());
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
                    headerLabel: 'Sign In',
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
                          label: 'Sign In',
                          onTap: signIn,
                        ),
                  HaveAccount(
                    haveAccount: 'New Here? ',
                    actionLabel: 'Sign Up',
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, '/customer_register');
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
