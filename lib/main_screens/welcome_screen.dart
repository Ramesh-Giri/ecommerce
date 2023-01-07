import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/app_color.dart';
import '../widgets/yellow_button.dart';

TextStyle textStyle = GoogleFonts.sansita(
    color: AppColor.appPrimary, fontSize: 45.0, fontWeight: FontWeight.bold);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xff3D3BAB),
          Color(0xff4745AF),
          Color(0xff4C4AB2),
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              'images/inapp/logo.jpg',
              height: 130.0,
              fit: BoxFit.cover,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      child: const Text(
                        'Sell here',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Container(
                      height: 60.0,
                      width: MediaQuery.of(context).size.width * 0.65,
                      padding: const EdgeInsets.all(12.0),
                      decoration: const BoxDecoration(
                        color: Colors.white38,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          bottomLeft: Radius.circular(50.0),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          YellowButton(
                            label: 'Login',
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, '/supplier_login');
                            },
                            widthRation: 0.25,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: YellowButton(
                              label: 'Sign Up ',
                              onTap: () {
                                Navigator.pushReplacementNamed(
                                    context, '/supplier_register');
                              },
                              widthRation: 0.25,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 12.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 60.0,
                  width: MediaQuery.of(context).size.width * 0.65,
                  padding: const EdgeInsets.all(12.0),
                  decoration: const BoxDecoration(
                    color: Colors.white38,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50.0),
                      bottomRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: YellowButton(
                          label: 'Login',
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/customer_login');
                          },
                          widthRation: 0.25,
                        ),
                      ),
                      YellowButton(
                        label: 'Sign Up ',
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, '/customer_register');
                        },
                        widthRation: 0.25,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  processing
                      ? const CircularProgressIndicator()
                      : SocialMediaIcon(
                          label: 'Login as Guest',
                          onPressed: () async {
                            setState(() {
                              processing = true;
                            });

                            var customerRef = FirebaseFirestore.instance
                                .collection('anonymous');

                            await FirebaseAuth.instance
                                .signInAnonymously()
                                .whenComplete(() async {
                              var uId = FirebaseAuth.instance.currentUser!.uid;

                              await customerRef.doc(uId).set({
                                'fullName': '',
                                'emailAddress': '',
                                'profileImageUrl': '',
                                'phoneNumber': '',
                                'address': '',
                                'cId': uId
                              });
                            });
                            setState(() {
                              processing = false;
                            });

                            Navigator.pushReplacementNamed(
                                context, '/customer_home');
                          },
                          child: const Icon(
                            Icons.person,
                            size: 32.0,
                            color: Colors.white,
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SocialMediaIcon extends StatelessWidget {
  const SocialMediaIcon(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.child})
      : super(key: key);

  final String label;
  final Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            child,
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
