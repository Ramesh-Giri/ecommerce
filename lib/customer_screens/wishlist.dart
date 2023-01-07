import 'package:MON_PARFUM/providers/wishlist.dart';
import 'package:MON_PARFUM/widgets/alert_dialog.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/product.dart';
import '../widgets/appbar_widgets.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            elevation: 0.0,
            centerTitle: true,
            leading: const AppBarBackButton(),
            backgroundColor: Colors.white,
            title: const AppBarTitle(
              title: 'WishList',
            ),
            actions: [
              context.watch<WishList>().getWishListItems.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        MyAlertDialog.showMyDialog(context,
                            title: 'Clear WishList?',
                            description: 'Are you sure to clear cart',
                            tapNo: () {
                          Navigator.pop(context);
                        }, tapYes: () {
                          context.read<WishList>().clearWishList();
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
          body: context.watch<WishList>().getCount < 1
              ? const EmptyWishList()
              : const WishListItems(),
        ),
      ),
    );
  }
}

class EmptyWishList extends StatelessWidget {
  const EmptyWishList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Empty Wishlist !',
            style: TextStyle(fontSize: 30.0),
          ),
        ],
      ),
    );
  }
}

class WishListItems extends StatelessWidget {
  const WishListItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WishList>(
      builder: (context, wishList, child) => ListView.builder(
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
                    child: Image.network(
                        wishList.getWishListItems[index].imageUrls.first),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            wishList.getWishListItems[index].name,
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
                                wishList.getWishListItems[index].price
                                    .toStringAsFixed(2),
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    wishList.removeItem(wishList
                                        .getWishListItems[index].documentId);
                                  },
                                  icon: const Icon(Icons.delete_forever)),
                              const SizedBox(
                                width: 10.0,
                              ),
                              if (context
                                      .read<Cart>()
                                      .getItems
                                      .firstWhereOrNull((product) =>
                                          product.documentId ==
                                          wishList.getWishListItems[index]
                                              .documentId) ==
                                  null)
                                IconButton(
                                    onPressed: () {
                                      context.read<Cart>().addItem(Product(
                                          name: wishList
                                              .getWishListItems[index].name,
                                          price: wishList
                                              .getWishListItems[index].price,
                                          quantity: 1,
                                          availableQuantity: wishList
                                              .getWishListItems[index].quantity,
                                          imageUrls: wishList
                                              .getWishListItems[index]
                                              .imageUrls,
                                          documentId: wishList
                                              .getWishListItems[index]
                                              .documentId,
                                          suppId: wishList
                                              .getWishListItems[index].suppId));

                                      context.read<WishList>().removeItem(
                                          wishList.getWishListItems[index]
                                              .documentId);
                                    },
                                    icon: const Icon(Icons.add_shopping_cart))
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
        itemCount: wishList.getCount,
      ),
    );
  }
}
