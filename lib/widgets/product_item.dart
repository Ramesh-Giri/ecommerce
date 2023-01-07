import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../minor_screens/product_detail.dart';
import '../providers/product.dart';
import '../providers/wishlist.dart';

class ProductItem extends StatelessWidget {
  final dynamic product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                    product: product,
                  ))),
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0)),
              child: Container(
                constraints:
                    const BoxConstraints(maxHeight: 250, minHeight: 100.0),
                child: Image.network(product['productImages'][0]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['productName'],
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 16.0, fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product['price'].toStringAsFixed(2) + ' \$',
                        style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.red,
                            fontWeight: FontWeight.w600),
                      ),
                      product['sId'] == FirebaseAuth.instance.currentUser!.uid
                          ? IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.red,
                              ))
                          : IconButton(
                              onPressed: () {
                                context
                                            .read<WishList>()
                                            .getWishListItems
                                            .firstWhereOrNull((prod) =>
                                                prod.documentId ==
                                                product['productId']) !=
                                        null
                                    ? context
                                        .read<WishList>()
                                        .removeItem(product['productId'])
                                    : context.read<WishList>().addWishListItem(
                                        Product(
                                            name: product['productName'],
                                            price: product['price'],
                                            quantity: product['inStock'],
                                            availableQuantity:
                                                product['inStock'],
                                            imageUrls: product['productImages'],
                                            documentId: product['productId'],
                                            suppId: product['sId']));
                              },
                              icon: Icon(
                                context
                                            .watch<WishList>()
                                            .getWishListItems
                                            .firstWhereOrNull((prod) =>
                                                prod.documentId ==
                                                product['productId']) !=
                                        null
                                    ? Icons.favorite
                                    : Icons.favorite_border_outlined,
                                color: Colors.red,
                              ))
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
