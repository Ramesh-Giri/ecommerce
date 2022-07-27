import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/customer_screens/customer_orders.dart';
import 'package:multi_store_app/customer_screens/wishlist.dart';
import 'package:multi_store_app/main_screens/cart.dart';

import '../widgets/alert_dialog.dart';
import '../widgets/appbar_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Container(
            height: 200.0,
            decoration: const BoxDecoration(
                gradient:
                    LinearGradient(colors: [Colors.yellow, Colors.brown])),
          ),
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                pinned: true,
                centerTitle: true,
                elevation: 0.0,
                backgroundColor: Colors.white,
                expandedHeight: 140,
                flexibleSpace: LayoutBuilder(
                  builder: (context, constraints) {
                    return FlexibleSpaceBar(
                      title: AnimatedOpacity(
                        opacity: constraints.biggest.height <= 120 ? 1 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Text(
                          'Account',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      background: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Colors.yellow, Colors.brown])),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25.0, left: 20.0),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 50.0,
                                backgroundImage:
                                    AssetImage('images/inapp/guest.jpg'),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: Text(
                                  'guest'.toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30.0),
                                    bottomLeft: Radius.circular(30.0))),
                            child: SizedBox(
                              height: 40.0,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen(
                                                back: AppBarBackButton(),
                                              )));
                                },
                                child: const Center(
                                  child: Text(
                                    'Cart',
                                    style: TextStyle(
                                        color: Colors.yellow, fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.yellow,
                            child: SizedBox(
                              height: 40.0,
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CustomerOrders()));
                                },
                                child: const Center(
                                  child: Text(
                                    'Orders',
                                    style: TextStyle(
                                        color: Colors.black54, fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(30.0),
                                    bottomRight: Radius.circular(30.0))),
                            child: SizedBox(
                              height: 40.0,
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const WishlistScreen()));
                                },
                                child: const Center(
                                  child: Text(
                                    'Wishlist',
                                    style: TextStyle(
                                        color: Colors.yellow, fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.grey.shade300,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 150.0,
                            child: Image(
                              image: AssetImage('images/inapp/logo.jpg'),
                            ),
                          ),
                          const ProfileHeaderLabel(
                            headerLabel: '  Account Info  ',
                          ),
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0)),
                            child: Column(
                              children: const [
                                ListTile(
                                  title: Text('Email Address'),
                                  subtitle: Text('admin@admin.com'),
                                  leading: Icon(Icons.email_outlined),
                                ),
                                YellowDivider(),
                                ListTile(
                                  title: Text('Phone No.'),
                                  subtitle: Text('+1111111111'),
                                  leading: Icon(Icons.phone),
                                ),
                                YellowDivider(),
                                ListTile(
                                  title: Text('Address'),
                                  subtitle: Text('example: 140 - st'),
                                  leading: Icon(Icons.location_pin),
                                ),
                              ],
                            ),
                          ),
                          const ProfileHeaderLabel(
                            headerLabel: '  Account Settings  ',
                          ),
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.0)),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {},
                                  title: const Text('Edit Profile'),
                                  leading: const Icon(Icons.edit),
                                ),
                                const YellowDivider(),
                                ListTile(
                                  onTap: () {},
                                  title: const Text('Change Password'),
                                  leading: const Icon(Icons.lock),
                                ),
                                const YellowDivider(),
                                ListTile(
                                  onTap: () {
                                    MyAlertDialog.showMyDialog(context,
                                        title: 'Logout?',
                                        description:
                                            'Are you sure you want to logout?',
                                        tapNo: () {
                                      Navigator.pop(context);
                                    }, tapYes: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pop(context);
                                      Navigator.pushReplacementNamed(
                                          context, '/welcome_screen');
                                    });
                                  },
                                  title: const Text('Logout'),
                                  leading: const Icon(Icons.logout),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  const ProfileHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  final String headerLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40.0,
            width: 50.0,
            child: Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
          ),
          Text(
            headerLabel,
            style: const TextStyle(
                color: Colors.grey,
                fontSize: 24.0,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 40.0,
            width: 50.0,
            child: Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
          )
        ],
      ),
    );
  }
}
