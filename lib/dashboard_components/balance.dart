import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/app_color.dart';
import '../widgets/appbar_widgets.dart';

class BalanceScreen extends StatelessWidget {
  const BalanceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('sId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('deliveryStatus', isEqualTo: 'delivered')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          double totalPrice = 0.00;
          for (var item in snapshot.data!.docs) {
            totalPrice += item['orderQuantity'] * item['orderPrice'];
          }

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: const AppBarTitle(
                title: 'Balance',
              ),
              leading: const AppBarBackButton(),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  statsModel(
                      context: context,
                      label: 'Total Balance',
                      value: totalPrice),
                  const SizedBox(
                    height: 100.0,
                  ),
                  Container(
                    height: 45.0,
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        color: AppColor.appPrimary.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(25)),
                    child: MaterialButton(
                      onPressed: () {},
                      child: const Text(
                        'Get my money !',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Column statsModel(
      {required BuildContext context,
      required String label,
      required num value}) {
    return Column(
      children: [
        Container(
          height: 60.0,
          width: MediaQuery.of(context).size.width * 0.55,
          decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0))),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: const TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ),
        Container(
          height: 90.0,
          width: MediaQuery.of(context).size.width * 0.70,
          decoration: BoxDecoration(
              color: Colors.blueGrey.shade100,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(25.0),
                  bottomRight: Radius.circular(25.0))),
          child: AnimatedCounter(
            count: value,
          ),
        )
      ],
    );
  }
}

class AnimatedCounter extends StatefulWidget {
  final dynamic count;

  const AnimatedCounter({Key? key, this.count}) : super(key: key);

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 100));
    _animation = _controller;
    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.count)
          .animate(_controller);
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Center(
              child: Text(
                _animation.value.toStringAsFixed(0),
                style: GoogleFonts.sansita(
                    color: AppColor.appPrimaryDark,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2),
              ),
            ));
  }
}
