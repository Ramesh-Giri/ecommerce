import 'package:MON_PARFUM/minor_screens/product_detail.dart';
import 'package:MON_PARFUM/utilities/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey.shade300,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
          title: CupertinoSearchTextField(
            autofocus: true,
            backgroundColor: Colors.white,
            onChanged: (value) {
              setState(() {
                searchInput = value;
              });
            },
          ),
        ),
        body: searchInput == ''
            ? Center(
                child: Container(
                height: 30.0,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    color: AppColor.appPrimaryFaded,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Search for anything...',
                      style: TextStyle(color: Colors.white),
                    )
                  ],
                ),
              ))
            : StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Material(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final list = <dynamic>[];
                  final result = snapshot.data!.docs
                      .where((e) => e['productName'].toLowerCase().contains(
                            searchInput.toLowerCase(),
                          ));

                  var categorySearch = snapshot.data!.docs
                      .where((e) => e['mainCategory'].toLowerCase().contains(
                            searchInput.toLowerCase(),
                          ));

                  var subCategorySearch = snapshot.data!.docs
                      .where((e) => e['subCategory'].toLowerCase().contains(
                            searchInput.toLowerCase(),
                          ));
                  list.addAll(result);
                  list.addAll(categorySearch);
                  list.addAll(subCategorySearch);

                  return ListView(
                    children: list.map((e) => SearchModel(e: e)).toList(),
                  );
                },
              ));
  }
}

class SearchModel extends StatelessWidget {
  final dynamic e;

  const SearchModel({Key? key, required this.e}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProductDetailScreen(
                    product: e,
                  ))),
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            height: 100.0,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12.0)),
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: SizedBox(
                      height: 100.0,
                      width: 100.0,
                      child: Image(
                        image: NetworkImage(e['productImages'][0]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Flexible(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        e['productName'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        e['productDescription'],
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            right: 20.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                  color: AppColor.appPrimaryDark.withOpacity(0.8).withGreen(10),
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      bottomLeft: Radius.circular(16.0))),
              height: 30.0,
              child: Center(
                child: Text(
                  '${e['mainCategory'.toString()]}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
