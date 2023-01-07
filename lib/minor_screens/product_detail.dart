import 'package:MON_PARFUM/providers/wishlist.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../main_screens/cart.dart';
import '../main_screens/visit_store.dart';
import '../providers/cart_provider.dart';
import '../providers/product.dart';
import '../utilities/app_color.dart';
import '../widgets/alert_dialog.dart';
import '../widgets/appbar_widgets.dart';
import '../widgets/product_item.dart';
import '../widgets/snackbar.dart';
import '../widgets/yellow_button.dart';
import 'full_screen_image.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  Stream<QuerySnapshot>? productStream;

  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    productStream = FirebaseFirestore.instance
        .collection('products')
        .where('mainCategory', isEqualTo: widget.product['mainCategory'])
        .where('subCategory', isEqualTo: widget.product['subCategory'])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    var customerRef = FirebaseFirestore.instance.collection('customers');
    var sellerRef = FirebaseFirestore.instance.collection('suppliers');

    var anonymousCustomerRef =
        FirebaseFirestore.instance.collection('anonymous');

    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        bottomSheet: FutureBuilder(
            future: FirebaseAuth.instance.currentUser!.isAnonymous
                ? anonymousCustomerRef
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .get()
                : customerRef.doc(FirebaseAuth.instance.currentUser!.uid).get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Error loading data'));
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                return const SizedBox();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VisitStore(
                                            supplierId:
                                                widget.product['sId'])));
                              },
                              icon: const Icon(Icons.store)),
                          Stack(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CartScreen(
                                                  back: AppBarBackButton(),
                                                )));
                                  },
                                  icon: const Icon(Icons.shopping_cart)),
                              if (context.watch<Cart>().getItems.isNotEmpty)
                                Positioned(
                                    right: 0.0,
                                    top: 0.0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 0.0),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10.0)),
                                      child: Text(
                                        context
                                            .watch<Cart>()
                                            .getItems
                                            .length
                                            .toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ))
                            ],
                          ),
                        ],
                      ),
                      widget.product['inStock'] > 0
                          ? YellowButton(
                              label: 'ADD TO CART',
                              onTap: () {
                                context.read<Cart>().getItems.firstWhereOrNull(
                                            (product) =>
                                                product.documentId ==
                                                widget.product['productId']) !=
                                        null
                                    ? MessageHandler.showSnackBar(_scaffoldKey,
                                        'This item is already in your cart')
                                    : context.read<Cart>().addItem(Product(
                                        name: widget.product['productName'],
                                        price: widget.product['price'],
                                        quantity: 1,
                                        availableQuantity:
                                            widget.product['inStock'],
                                        imageUrls:
                                            widget.product['productImages'],
                                        documentId: widget.product['productId'],
                                        suppId: widget.product['sId']));
                              },
                              widthRation: 0.4)
                          : const Text(
                              'Out of Stock',
                              style: TextStyle(color: Colors.red),
                            )
                    ],
                  ),
                );
              }

              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.purple,
              ));
            }),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  InkWell(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FullScreenImage(
                                images: widget.product['productImages']))),
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: Swiper(
                          loop: false,
                          pagination: const SwiperPagination(
                              builder: SwiperPagination.fraction),
                          itemBuilder: (context, index) {
                            return Image(
                              image: NetworkImage(
                                widget.product['productImages'][index],
                              ),
                            );
                          },
                          itemCount: widget.product['productImages'].length),
                    ),
                  ),
                  Positioned(
                      left: 10.0,
                      top: 35.0,
                      child: CircleAvatar(
                        backgroundColor: AppColor.appPrimary,
                        child: Center(
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back_ios_new,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      )),
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                          color: AppColor.appPrimaryFaded.withOpacity(0.4),
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              bottomLeft: Radius.circular(15.0))),
                      child: Center(
                        child: Text(
                          'SPECIALITY : ${widget.product['subCategory'].toUpperCase()}',
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      widget.product['productName'],
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'USD ' +
                              widget.product['price'].toStringAsFixed(2) +
                              ' \$',
                          style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.red,
                              fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                            onPressed: () {
                              context
                                          .read<WishList>()
                                          .getWishListItems
                                          .firstWhereOrNull((product) =>
                                              product.documentId ==
                                              widget.product['productId']) !=
                                      null
                                  ? context
                                      .read<WishList>()
                                      .removeItem(widget.product['productId'])
                                  : context.read<WishList>().addWishListItem(
                                      Product(
                                          name: widget.product['productName'],
                                          price: widget.product['price'],
                                          quantity: 1,
                                          availableQuantity:
                                              widget.product['inStock'],
                                          imageUrls:
                                              widget.product['productImages'],
                                          documentId:
                                              widget.product['productId'],
                                          suppId: widget.product['sId']));
                            },
                            icon: Icon(
                              context
                                          .watch<WishList>()
                                          .getWishListItems
                                          .firstWhereOrNull((product) =>
                                              product.documentId ==
                                              widget.product['productId']) !=
                                      null
                                  ? Icons.favorite
                                  : Icons.favorite_border_outlined,
                              color: Colors.red,
                            ))
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    FutureBuilder(
                        future: sellerRef.doc(widget.product['sId']).get(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error loading data'));
                          }
                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return const SizedBox();
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VisitStore(
                                              supplierId: data['sId'],
                                            )));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  'Seller: ${data['storeName']}',
                                  style: const TextStyle(
                                      color: Colors.blue,
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            );
                          }

                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.purple,
                          ));
                        }),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      widget.product['inStock'] < 1
                          ? 'Product out of stock'
                          : widget.product['inStock'].toString() +
                              ' pieces available in stock',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: widget.product['inStock'] < 1
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                    _productDetailHeader(label: '  Item Description  '),
                    Text(
                      widget.product['productDescription'],
                      textScaleFactor: 1.1,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey.shade800),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    FutureBuilder(
                        future: FirebaseAuth.instance.currentUser!.isAnonymous
                            ? anonymousCustomerRef
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get()
                            : customerRef
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .get(),
                        builder: (context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError) {
                            return const Center(
                                child: Text('Error loading data'));
                          }
                          if (snapshot.hasData && !snapshot.data!.exists) {
                            return const SizedBox();
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            Map<String, dynamic> data =
                                snapshot.data!.data() as Map<String, dynamic>;

                            return data.containsKey('isAdmin') &&
                                    data['isAdmin']
                                ? Row(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            MyAlertDialog.showMyDialog(context,
                                                title: 'Remote item?',
                                                description:
                                                    'Are you sure to remove this item?',
                                                tapNo: () {
                                              Navigator.pop(context);
                                            }, tapYes: () {
                                              DocumentReference
                                                  documentReference =
                                                  FirebaseFirestore.instance
                                                      .collection('products')
                                                      .doc(widget.product[
                                                          'productId']);
                                              documentReference.update({
                                                'isDeleted': true,
                                                'deleteReason':
                                                    'violation of rule'
                                              });

                                              Navigator.pop(context);
                                            });
                                          },
                                          child: const Text(
                                            'Remove this product',
                                            style: TextStyle(color: Colors.red),
                                          )),
                                    ],
                                  )
                                : const SizedBox();
                          }

                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.purple,
                          ));
                        }),
                    const SizedBox(
                      height: 16.0,
                    ),
                    SizedBox(
                      child: StreamBuilder(
                          stream: productStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                child: Text(
                                  'No Product for this category',
                                  style: GoogleFonts.sansita(
                                      fontSize: 26.0,
                                      color: Colors.blueGrey,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.5),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }

                            if (snapshot.data!.docs.length > 1) {
                              return Column(
                                children: [
                                  _productDetailHeader(
                                      label: '  Recommended Items  '),
                                  SingleChildScrollView(
                                    child: StaggeredGridView.countBuilder(
                                        padding:
                                            const EdgeInsets.only(bottom: 28.0),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        crossAxisCount: 2,
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (context, index) {
                                          if (snapshot.data!.docs[index]
                                                  ['productId'] !=
                                              widget.product['productId']) {
                                            return ProductItem(
                                              product:
                                                  snapshot.data!.docs[index],
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        },
                                        staggeredTileBuilder: (context) =>
                                            const StaggeredTile.fit(1)),
                                  ),
                                ],
                              );
                            } else {
                              return const SizedBox();
                            }
                          }),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _productDetailHeader({required final String label}) {
    return SizedBox(
      height: 60.0,
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 2.0,
              color: Colors.yellow.shade900,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w600,
              color: AppColor.appPrimary,
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 2.0,
              color: AppColor.appPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
