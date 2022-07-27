import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/dashboard_components/balance.dart';
import 'package:multi_store_app/dashboard_components/edit_business.dart';
import 'package:multi_store_app/dashboard_components/manage_products.dart';
import 'package:multi_store_app/dashboard_components/my_store.dart';
import 'package:multi_store_app/dashboard_components/stats.dart';
import 'package:multi_store_app/dashboard_components/suppliers_orders.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

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

List<Widget> pages = const [
  MyStore(),
  SupplierOrders(),
  EditBusiness(),
  ManageProducts(),
  BalanceScreen(),
  StatsScreen()
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
                Navigator.pushReplacementNamed(context, '/welcome_screen');
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
                      shadowColor: Colors.purpleAccent.shade200,
                      color: Colors.blueGrey.withOpacity(0.7),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            icons[index],
                            color: Colors.yellowAccent,
                            size: 45.0,
                          ),
                          Text(
                            labels[index].toUpperCase(),
                            textAlign: TextAlign.center,
                            style: GoogleFonts.acme(
                                letterSpacing: 2.0,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.yellowAccent),
                          )
                        ],
                      ),
                    ),
                  )),
        ),
      ),
    );
  }
}
