import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/yellow_button.dart';

const textColor = [
  Colors.yellowAccent,
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.purple,
  Colors.teal,
];
TextStyle textStyle = GoogleFonts.acme(
    color: Colors.yellow, fontSize: 45.0, fontWeight: FontWeight.bold);

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool processing = false;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: const BoxConstraints.expand(),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('images/inapp/bgimage.jpg'),
                fit: BoxFit.cover)),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText('Welcome',
                      textStyle: textStyle, colors: textColor),
                  ColorizeAnimatedText('Store',
                      textStyle: textStyle, colors: textColor),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
              Image.asset(
                'images/inapp/logo.jpg',
                height: 200.0,
                width: 200.0,
              ),
              SizedBox(
                  height: 80.0,
                  child: DefaultTextStyle(
                    style: textStyle.copyWith(color: Colors.lightBlueAccent),
                    child: AnimatedTextKit(
                      animatedTexts: [
                        RotateAnimatedText('BUY'),
                        RotateAnimatedText('SHOP'),
                        RotateAnimatedText('Store'),
                      ],
                      repeatForever: true,
                      isRepeatingAnimation: true,
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12.0),
                        decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            bottomLeft: Radius.circular(50.0),
                          ),
                        ),
                        child: const Text(
                          'Suppliers Only',
                          style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 26.0,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 6.0,
                      ),
                      Container(
                        height: 60.0,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.9,
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
                            AnimatedLogo(controller: _controller),
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
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 0.9,
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
                        AnimatedLogo(controller: _controller),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 25.0),
                decoration: BoxDecoration(
                  color: Colors.white38.withOpacity(0.3),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SocialMediaIcon(
                      label: 'Google',
                      onPressed: () {},
                      child: Image.asset(
                        'images/inapp/google.jpg',
                        height: 50.0,
                        width: 50.0,
                      ),
                    ),
                    SocialMediaIcon(
                      label: 'Facebook',
                      onPressed: () {},
                      child: Image.asset(
                        'images/inapp/facebook.jpg',
                        height: 50.0,
                        width: 50.0,
                      ),
                    ),
                    processing
                        ? const CircularProgressIndicator()
                        : SocialMediaIcon(
                      label: 'Guest',
                      onPressed: () async {
                        setState(() {
                          processing = true;
                        });

                        var customerRef = FirebaseFirestore.instance
                            .collection('customers');

                        await FirebaseAuth.instance.signInAnonymously()
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
                        size: 55.0,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    Key? key,
    required AnimationController controller,
  })
      : _controller = controller,
        super(key: key);

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (context, child) =>
          Transform.rotate(angle: _controller.value * 2 * pi, child: child),
      child: Image.asset('images/inapp/logo.jpg'),
    );
  }
}

class SocialMediaIcon extends StatelessWidget {
  const SocialMediaIcon({Key? key,
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
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
