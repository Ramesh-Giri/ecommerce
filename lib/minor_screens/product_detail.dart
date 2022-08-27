import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../widgets/product_item.dart';
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
    return Scaffold(
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.store)),
                IconButton(
                    onPressed: () {}, icon: const Icon(Icons.shopping_cart)),
              ],
            ),
            YellowButton(label: 'ADD TO CART', onTap: () {}, widthRation: 0.4)
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                      left: 0.0,
                      top: 20.0,
                      right: 0.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back_ios_new),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.yellow,
                            child: Center(
                              child: IconButton(
                                icon: const Icon(Icons.share),
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                      )),
                ],
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
              _productDetailHeader(label: '  Item Description  '),
              Text(
                widget.product['productDescription'],
                textScaleFactor: 1.1,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade800),
              ),
              _productDetailHeader(label: '  Recommended Items  '),
              SizedBox(
                child: StreamBuilder(
                    stream: productStream,
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
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
                            'No Product for this category',
                            style: GoogleFonts.acme(
                                fontSize: 26.0,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5),
                            textAlign: TextAlign.center,
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: StaggeredGridView.countBuilder(
                            padding: const EdgeInsets.only(bottom: 28.0),
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) => ProductItem(
                                  product: snapshot.data!.docs[index],
                                ),
                            staggeredTileBuilder: (context) =>
                                const StaggeredTile.fit(1)),
                      );
                    }),
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
              color: Colors.yellow.shade900,
            ),
          ),
          Expanded(
            child: Divider(
              thickness: 2.0,
              color: Colors.yellow.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
