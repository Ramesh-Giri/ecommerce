import 'package:flutter/material.dart';

import '../widgets/appbar_widgets.dart';

class SubCategoryProducts extends StatelessWidget {
  const SubCategoryProducts(
      {Key? key, required this.mainCategoryName, required this.subCategoryName})
      : super(key: key);

  final String subCategoryName;
  final String mainCategoryName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
        title: AppBarTitle(title: subCategoryName),
      ),
      body: Center(
        child: Text(
          mainCategoryName,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
