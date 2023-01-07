import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../widgets/appbar_widgets.dart';
import '../widgets/product_item.dart';

class ManageProducts extends StatelessWidget {
  ManageProducts({Key? key}) : super(key: key);

  final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
      .collection('products')
      .where('sId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const AppBarTitle(
          title: 'Manage Products',
        ),
        leading: const AppBarBackButton(),
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
              return Text(
                'No Product for this category',
                style: GoogleFonts.sansita(
                    fontSize: 26.0,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5),
                textAlign: TextAlign.center,
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
