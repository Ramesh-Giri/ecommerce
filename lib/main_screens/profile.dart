import 'package:MON_PARFUM/utilities/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customer_screens/customer_orders.dart';
import '../customer_screens/wishlist.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/appbar_widgets.dart';
import 'cart.dart';

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var customerRef = FirebaseFirestore.instance.collection('customers');

  var anonymousCustomerRef = FirebaseFirestore.instance.collection('anonymous');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser!.isAnonymous
          ? anonymousCustomerRef.doc(widget.userId).get()
          : customerRef.doc(widget.userId).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading data'));
        }
        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Center(child: Text('Document doesn\'t exist'));
        }
        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                  height: 200.0,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Color(0xff3D3BAB),
                    Color(0xff4745AF),
                    Color(0xff4C4AB2),
                  ])),
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
                              opacity:
                                  constraints.biggest.height <= 120 ? 1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Text(
                                'Account',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            background: Container(
                              decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                Color(0xff3D3BAB),
                                Color(0xff4745AF),
                                Color(0xff4C4AB2),
                              ])),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 25.0, left: 20.0),
                                child: Row(
                                  children: [
                                    data['profileImageUrl'].isEmpty
                                        ? const CircleAvatar(
                                            radius: 50.0,
                                            backgroundColor: Colors.grey,
                                            backgroundImage: AssetImage(
                                              'images/inapp/guest.jpg',
                                            ),
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 2.0)),
                                            child: CircleAvatar(
                                              radius: 50.0,
                                              backgroundColor: Colors.grey,
                                              backgroundImage: NetworkImage(
                                                data['profileImageUrl'],
                                              ),
                                            ),
                                          ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 25.0),
                                      child: Text(
                                        data['fullName'].isEmpty
                                            ? 'Guest'.toUpperCase()
                                            : data['fullName'].toUpperCase(),
                                        style: const TextStyle(
                                            color: Colors.white,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
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
                                              color: Colors.white,
                                              fontSize: 20.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: AppColor.appPrimary.withOpacity(0.6),
                                  child: SizedBox(
                                    height: 40.0,
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
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
                                              color: Colors.white,
                                              fontSize: 20.0),
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
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
                                              color: Colors.white,
                                              fontSize: 20.0),
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
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: const Text('Email Address'),
                                        subtitle: Text(
                                            data['emailAddress'].isEmpty
                                                ? '-'.toUpperCase()
                                                : data['emailAddress']),
                                        leading:
                                            const Icon(Icons.email_outlined),
                                      ),
                                      const YellowDivider(),
                                      ListTile(
                                        title: const Text('Phone No.'),
                                        subtitle: Text(
                                            data['phoneNumber'].isEmpty
                                                ? '-'.toUpperCase()
                                                : data['phoneNumber']),
                                        leading: const Icon(Icons.phone),
                                      ),
                                      const YellowDivider(),
                                      ListTile(
                                        title: const Text('Address'),
                                        subtitle: Text(data['address'].isEmpty
                                            ? '-'.toUpperCase()
                                            : data['address']),
                                        leading: const Icon(Icons.location_pin),
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
                                      borderRadius:
                                          BorderRadius.circular(16.0)),
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
                                            await FirebaseAuth.instance
                                                .signOut();
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
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.purple,
        ));
      },
    );
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Divider(
        color: AppColor.appPrimaryFaded,
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
