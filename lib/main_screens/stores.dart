import 'package:MON_PARFUM/main_screens/visit_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/appbar_widgets.dart';

class StoresScreen extends StatelessWidget {
  const StoresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const AppBarTitle(
          title: 'Stores',
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('suppliers').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data!.docs.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: 25.0,
                    crossAxisSpacing: 25.0,
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => VisitStore(
                                    supplierId: snapshot.data!.docs[index]
                                        ['sId'],
                                  )));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                            height: 80.0,
                            width: 100.0,
                            child: Image.network(
                                snapshot.data!.docs[index]['storeLogo'])),
                        Text(
                          snapshot.data!.docs[index]['storeName']
                              .toString()
                              .toLowerCase(),
                          style: GoogleFonts.sansita(fontSize: 20.0),
                        ),
                      ],
                    ),
                  );
                });
          }

          return const Center(
            child: Text('No Stores'),
          );
        },
      ),
    );
  }
}
