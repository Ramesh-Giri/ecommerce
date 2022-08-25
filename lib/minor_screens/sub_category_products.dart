import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../widgets/appbar_widgets.dart';
import '../widgets/product_item.dart';

class SubCategoryProducts extends StatelessWidget {
  const SubCategoryProducts(
      {Key? key, required this.mainCategoryName, required this.subCategoryName})
      : super(key: key);

  final String subCategoryName;
  final String mainCategoryName;

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('products')
        .where('mainCategory', isEqualTo: mainCategoryName)
        .where('subCategory', isEqualTo: subCategoryName)
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
        title: AppBarTitle(title: subCategoryName),
      ),
      body: StreamBuilder(
          stream: productStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                  staggeredTileBuilder: (context) =>
                      const StaggeredTile.fit(1)),
            );
          }),
    );
  }
}
