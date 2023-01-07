import 'package:MON_PARFUM/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../minor_screens/place_order_screen.dart';
import '../providers/cart_provider.dart';
import '../utilities/app_color.dart';
import '../widgets/appbar_widgets.dart';

class CartScreen extends StatefulWidget {
  final Widget? back;

  const CartScreen({Key? key, this.back}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    double total = context.watch<Cart>().totalPrice;

    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            backgroundColor: Colors.white,
            title: const AppBarTitle(
              title: 'Cart',
            ),
            leading: widget.back,
            actions: [
              context.watch<Cart>().getItems.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(context,
                            title: 'Clear Cart?',
                            description: 'Are you sure to clear cart',
                            tapNo: () {
                          Navigator.pop(context);
                        }, tapYes: () {
                          context.read<Cart>().clearCart();
                          Navigator.pop(context);
                        });
                      },
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ))
                  : const SizedBox(),
            ],
          ),
          body: context.watch<Cart>().getCount < 1
              ? const EmptyCart()
              : const CartItems(),
          bottomSheet: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text(
                      'Total : \$ ',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(
                      total.toStringAsFixed(2),
                      style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ],
                ),
                Container(
                  height: 35.0,
                  width: MediaQuery.of(context).size.width * 0.45,
                  decoration: BoxDecoration(
                      color: AppColor.appPrimary.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(25)),
                  child: MaterialButton(
                    onPressed: total == 0.0
                        ? null
                        : () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PlaceOrderScreen()));
                          },
                    child: const Text(
                      'CHECK OUT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  const EmptyCart({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Empty cart !',
            style: TextStyle(fontSize: 30.0),
          ),
          const SizedBox(
            height: 50.0,
          ),
          Material(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(25.0),
            child: MaterialButton(
              minWidth: MediaQuery.of(context).size.width * 0.6,
              onPressed: () {
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushReplacementNamed(context, '/customer_home');
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(fontSize: 18.0, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CartItems extends StatelessWidget {
  const CartItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Cart>(
      builder: (context, cart, child) => ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.all(5.0),
          child: Card(
            child: SizedBox(
              height: 100.0,
              child: Row(
                children: [
                  SizedBox(
                    height: 100.0,
                    width: 120.0,
                    child: Image.network(cart.getItems[index].imageUrls.first),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            cart.getItems[index].name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade700),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                ' \$ ${cart.getItems[index].price.toStringAsFixed(2)}',
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                              Container(
                                height: 35.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(15.0)),
                                child: Row(
                                  children: [
                                    cart.getItems[index].quantity == 1
                                        ? IconButton(
                                            onPressed: () {
                                              cart.removeItem(
                                                  cart.getItems[index]);
                                            },
                                            icon: const Icon(
                                              Icons.delete_forever,
                                              size: 18.0,
                                            ))
                                        : IconButton(
                                            onPressed: () => cart.decrement(
                                                cart.getItems[index]),
                                            icon: const Icon(
                                              FontAwesomeIcons.minus,
                                              size: 18.0,
                                            )),
                                    Text(
                                      cart.getItems[index].quantity.toString(),
                                      style: GoogleFonts.sansita(
                                          fontSize: 20.0,
                                          color:
                                              cart.getItems[index].quantity ==
                                                      cart.getItems[index]
                                                          .availableQuantity
                                                  ? Colors.red
                                                  : Colors.black),
                                    ),
                                    IconButton(
                                        onPressed:
                                            cart.getItems[index].quantity ==
                                                    cart.getItems[index]
                                                        .availableQuantity
                                                ? null
                                                : () => cart.increment(
                                                    cart.getItems[index]),
                                        icon: const Icon(
                                          FontAwesomeIcons.plus,
                                          size: 18.0,
                                        ))
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        itemCount: cart.getCount,
      ),
    );
  }
}
