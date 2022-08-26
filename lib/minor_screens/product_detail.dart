import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: Swiper(
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
                  'USD ' + widget.product['price'].toStringAsFixed(2) + ' \$',
                  style: const TextStyle(
                      fontSize: 18.0,
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
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              widget.product['quantity'].toString() +
                  ' pieces available in stock',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
