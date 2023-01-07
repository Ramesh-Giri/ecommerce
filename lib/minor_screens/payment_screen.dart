import 'package:MON_PARFUM/utilities/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:uuid/uuid.dart';

import '../providers/cart_provider.dart';
import '../widgets/appbar_widgets.dart';
import '../widgets/yellow_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  var customerRef = FirebaseFirestore.instance.collection('customers');

  int selectedValue = 1;

  late String orderId;

  void showProgress() {
    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(
        max: 100,
        msg: 'Please wait..',
        progressBgColor: AppColor.appPrimaryDark);
  }

  @override
  Widget build(BuildContext context) {
    var totalPrice = context.watch<Cart>().totalPrice;
    var totalPaid = context.watch<Cart>().totalPrice + 10.0;
    return FutureBuilder(
        future: customerRef.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          }
          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Center(child: Text('Document doesn\'t exist'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Material(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;

            return Material(
              color: Colors.grey.shade200,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade200,
                  bottomSheet: Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.grey.shade200,
                    child: YellowButton(
                      label: 'Confirm \$${totalPaid.toStringAsFixed(2)}',
                      onTap: () {
                        if (selectedValue == 1) {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) => SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 100.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'Pay at home \$ ${totalPrice.toStringAsFixed(2)}',
                                            style:
                                                const TextStyle(fontSize: 24.0),
                                          ),
                                          YellowButton(
                                              label:
                                                  'Confirm \$${totalPrice.toStringAsFixed(2)}',
                                              onTap: () async {
                                                showProgress();

                                                for (var item in context
                                                    .read<Cart>()
                                                    .getItems) {
                                                  CollectionReference
                                                      orderReference =
                                                      FirebaseFirestore.instance
                                                          .collection('orders');
                                                  orderId = const Uuid().v4();
                                                  await orderReference
                                                      .doc(orderId)
                                                      .set({
                                                    'cId': data['cId'],
                                                    'customerName':
                                                        data['fullName'],
                                                    'emailAddress':
                                                        data['emailAddress'],
                                                    'address': data['address'],
                                                    'phoneNumber':
                                                        data['phoneNumber'],
                                                    'profileImageUrl':
                                                        data['profileImageUrl'],
                                                    'sId': item.suppId,
                                                    'productId':
                                                        item.documentId,
                                                    'orderId': orderId,
                                                    'orderImage':
                                                        item.imageUrls.first,
                                                    'orderName': item.name,
                                                    'orderQuantity':
                                                        item.quantity,
                                                    'orderPrice':
                                                        item.quantity *
                                                            item.price,
                                                    'deliveryStatus':
                                                        'preparing',
                                                    'deliveryDate': '',
                                                    'orderDate': DateTime.now(),
                                                    'paymentStatus':
                                                        'cash on delivery',
                                                    'orderReview': false
                                                  }).whenComplete(() async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .runTransaction(
                                                            (transaction) async {
                                                      DocumentReference
                                                          documentReference =
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'products')
                                                              .doc(item
                                                                  .documentId);
                                                      var snapshot2 =
                                                          await transaction.get(
                                                              documentReference);

                                                      transaction.update(
                                                          documentReference, {
                                                        'inStock': snapshot2[
                                                                'inStock'] -
                                                            item.quantity
                                                      });
                                                    });
                                                  });
                                                }
                                                context
                                                    .read<Cart>()
                                                    .clearCart();
                                                Navigator.popUntil(
                                                    context,
                                                    ModalRoute.withName(
                                                        '/customer_home'));
                                              },
                                              widthRation: 0.9)
                                        ],
                                      ),
                                    ),
                                  ));
                        } else if (selectedValue == 2) {
                        } else if (selectedValue == 3) {}
                      },
                      widthRation: 1,
                    ),
                  ),
                  appBar: AppBar(
                    elevation: 0.0,
                    leading: const AppBarBackButton(),
                    title: const AppBarTitle(
                      title: 'Payment',
                    ),
                    backgroundColor: Colors.grey.shade200,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 120.0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 4.0),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total',
                                    style: TextStyle(fontSize: 20.0),
                                  ),
                                  Text(
                                    '\$ ${totalPaid.toStringAsFixed(2)}',
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                ],
                              ),
                              const Divider(
                                color: Colors.grey,
                                thickness: 2.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Order Total',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.grey),
                                  ),
                                  Text(
                                    '\$ ${totalPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 16.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Shipping cost',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.grey),
                                  ),
                                  Text(
                                    '\$ 10',
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15.0)),
                            child: Column(
                              children: [
                                RadioListTile(
                                    value: 1,
                                    groupValue: selectedValue,
                                    title: const Text('Cash on Delivery'),
                                    subtitle: const Text('pay at home'),
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedValue = value!;
                                      });
                                    }),
                                RadioListTile(
                                    value: 2,
                                    groupValue: selectedValue,
                                    title: const Text(
                                        'Pay via Visa / Master card'),
                                    subtitle: Row(
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.ccVisa,
                                          color: AppColor.appPrimaryDark,
                                        ),
                                        const SizedBox(
                                          width: 4.0,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.ccMastercard,
                                          color: AppColor.appPrimaryDark,
                                        ),
                                      ],
                                    ),
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedValue = value!;
                                      });
                                    }),
                                RadioListTile(
                                    value: 3,
                                    groupValue: selectedValue,
                                    title: const Text('Pay via paypal'),
                                    subtitle: Row(
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.ccPaypal,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(width: 15.0),
                                        Icon(
                                          FontAwesomeIcons.paypal,
                                          color: Colors.blue,
                                        ),
                                      ],
                                    ),
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedValue = value!;
                                      });
                                    })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
