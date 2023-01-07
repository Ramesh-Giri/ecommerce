import 'package:MON_PARFUM/dashboard_components/delivered_orders.dart';
import 'package:MON_PARFUM/dashboard_components/preparing_orders.dart';
import 'package:MON_PARFUM/dashboard_components/shipping_orders.dart';
import 'package:flutter/material.dart';

import '../main_screens/home.dart';
import '../utilities/app_color.dart';
import '../widgets/appbar_widgets.dart';

class SupplierOrders extends StatelessWidget {
  const SupplierOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const AppBarTitle(
            title: 'Orders',
          ),
          leading: const AppBarBackButton(),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColor.appPrimary,
            indicatorWeight: 2.0,
            tabs: const [
              RepeatTab(title: 'Preparing'),
              RepeatTab(title: 'Shipping'),
              RepeatTab(title: 'Delivered'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            PreparingOrders(),
            ShippingOrders(),
            DeliveredOrders(),
          ],
        ),
      ),
    );
  }
}
