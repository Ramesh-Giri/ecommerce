import 'package:MON_PARFUM/main_screens/visit_store.dart';
import 'package:MON_PARFUM/utilities/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../dashboard_components/balance.dart';
import '../dashboard_components/edit_business.dart';
import '../dashboard_components/manage_products.dart';
import '../dashboard_components/stats.dart';
import '../dashboard_components/suppliers_orders.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/appbar_widgets.dart';

List<String> labels = [
  'my store',
  'orders',
  'edit profile',
  'manage products',
  'balance',
  'statics',
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];

List<Widget> pages = [
  VisitStore(supplierId: FirebaseAuth.instance.currentUser!.uid),
  const SupplierOrders(),
  const EditBusiness(),
  ManageProducts(),
  const BalanceScreen(),
  const StatsScreen()
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Dashboard',
        ),
        actions: [
          IconButton(
              onPressed: () {
                MyAlertDialog.showMyDialog(context,
                    title: 'Logout?',
                    description: 'Are you sure you want to logout?', tapNo: () {
                  Navigator.pop(context);
                }, tapYes: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/welcome_screen');
                });
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 45.0,
          crossAxisSpacing: 45.0,
          children: List.generate(
              labels.length,
              (index) => InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => pages[index]));
                    },
                    child: Card(
                      elevation: 20.0,
                      color: AppColor.appPrimary.withOpacity(0.6),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            icons[index],
                            color: Colors.white,
                            size: 40.0,
                          ),
                          Text(labels[index].toUpperCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.sansita(
                                  letterSpacing: 2.0,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
