import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../widgets/product_item.dart';

class ShoesGalleryScreen extends StatefulWidget {
  const ShoesGalleryScreen({Key? key}) : super(key: key);

  @override
  State<ShoesGalleryScreen> createState() => _ShoesGalleryScreenState();
}

class _ShoesGalleryScreenState extends State<ShoesGalleryScreen> {
  final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
      .collection('products')
      .where('mainCategory', isEqualTo: 'shoes')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: productStream,
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
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => ProductItem(
                      product: snapshot.data!.docs[index],
                    ),
                staggeredTileBuilder: (context) => const StaggeredTile.fit(1)),
          );
        });
  }
}
