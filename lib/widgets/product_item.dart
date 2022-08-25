import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final dynamic product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.favorite_border_outlined,
                          color: Colors.red,
                        ))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
