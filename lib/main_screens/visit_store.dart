import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../utilities/app_color.dart';
import '../widgets/product_item.dart';

class VisitStore extends StatefulWidget {
  final String supplierId;

  const VisitStore({Key? key, required this.supplierId}) : super(key: key);

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool following = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference users =
        FirebaseFirestore.instance.collection('suppliers');

    final Stream<QuerySnapshot> productStream = FirebaseFirestore.instance
        .collection('products')
        .where('sId', isEqualTo: widget.supplierId)
        .snapshots();

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.supplierId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
              child: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              toolbarHeight: 110,
              backgroundColor: const Color(0xff3D3BAB),
              title: Row(
                children: [
                  Container(
                    height: 80.0,
                    width: 80.0,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: Colors.white),
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        data['storeLogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['storeName'].toUpperCase(),
                        style: const TextStyle(fontSize: 20.0),
                      ),
                      if (data['isFlagged'] != null && data['isFlagged'])
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 2.0),
                          margin: const EdgeInsets.symmetric(vertical: 2.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.flag,
                                color: Colors.red,
                                size: 16.0,
                              ),
                              Text(
                                'Flagship store',
                                style: TextStyle(
                                    fontSize: 12.0, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      data['sId'] == FirebaseAuth.instance.currentUser!.uid
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 35.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                      color: AppColor.appPrimaryFaded,
                                      borderRadius: BorderRadius.circular(25.0),
                                      border: Border.all(
                                          width: 3.0, color: Colors.black)),
                                  child: MaterialButton(
                                    onPressed: () {},
                                    textColor: Colors.white,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: const [
                                        Text('Edit'),
                                        Icon(Icons.edit)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 35.0,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                      color: AppColor.appPrimaryFaded
                                          .withGreen(10),
                                      borderRadius: BorderRadius.circular(25.0),
                                      border: Border.all(
                                          width: 3.0, color: Colors.black)),
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        following = !following;
                                      });
                                    },
                                    textColor: Colors.white,
                                    child: Text(
                                        following ? 'following' : 'FOLLOW'),
                                  ),
                                ),
                              ],
                            )
                    ],
                  )
                ],
              ),
            ),
            body: StreamBuilder(
                stream: productStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  if (snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        'This store \n\n has no items yet',
                        style: GoogleFonts.sansita(
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

        return const Material(child: Text("loading"));
      },
    );
  }
}
