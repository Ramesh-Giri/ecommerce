import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../utilities/app_color.dart';

class ShippingOrders extends StatefulWidget {
  const ShippingOrders({Key? key}) : super(key: key);

  @override
  State<ShippingOrders> createState() => _ShippingOrdersState();
}

class _ShippingOrdersState extends State<ShippingOrders> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where('sId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .where('deliveryStatus', isEqualTo: 'shipping')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              'You have no\n\nactive orders yet',
              style: GoogleFonts.sansita(
                  fontSize: 26.0,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5),
              textAlign: TextAlign.center,
            ),
          );
        }

        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var orderItem = snapshot.data!.docs[index];
              return Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColor.appPrimaryFaded),
                    borderRadius: BorderRadius.circular(15.0)),
                child: ExpansionTile(
                  title: Container(
                    constraints: const BoxConstraints(maxHeight: 80.0),
                    width: double.infinity,
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 15.0),
                          constraints: const BoxConstraints(
                              maxHeight: 80, maxWidth: 80.0),
                          child: Image.network(orderItem['orderImage']),
                        ),
                        Flexible(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              orderItem['orderName'],
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      '\$ ${orderItem['orderPrice'].toStringAsFixed(2)}'),
                                  Text(
                                      ' X ${orderItem['orderQuantity'].toString()}'),
                                ],
                              ),
                            )
                          ],
                        ))
                      ],
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'See more...',
                        style: TextStyle(color: Colors.blue),
                      ),
                      Text(
                        orderItem['deliveryStatus'],
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: AppColor.appPrimaryFaded.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${orderItem['customerName']}',
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              'Phone No.: ${orderItem['phoneNumber']}',
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              'Email Address: ${orderItem['emailAddress']}',
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              'Address: ${orderItem['address']}',
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              'Payment Status: ${orderItem['paymentStatus']}',
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              'Delivery status: ${orderItem['deliveryStatus']}',
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Text(
                              'Order Date: ${DateFormat('yyyy-MM-dd').format(orderItem['orderDate'].toDate())}',
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            orderItem['deliveryStatus'] == 'delivered'
                                ? const Text('order already delivered!')
                                : Row(
                                    children: [
                                      const Text(
                                        'Change Delivery Status To:',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                      orderItem['deliveryStatus'] == 'preparing'
                                          ? TextButton(
                                              onPressed: () {},
                                              child: const Text('Shipping'))
                                          : TextButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection('orders')
                                                    .doc(orderItem['orderId'])
                                                    .update({
                                                  'deliveryStatus': 'delivered'
                                                });
                                              },
                                              child: const Text('Delivered'))
                                    ],
                                  ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
      },
    );
  }
}
