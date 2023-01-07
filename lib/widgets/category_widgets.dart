import 'package:flutter/material.dart';

import '../minor_screens/sub_category_products.dart';

class SliderBar extends StatelessWidget {
  final String mainCategoryName;

  const SliderBar({Key? key, required this.mainCategoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        right: 0.0,
        bottom: 0.0,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.78,
          width: MediaQuery.of(context).size.height * 0.03,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 40.0),
            decoration: BoxDecoration(
                color: Colors.brown.withOpacity(0.2),
                borderRadius: BorderRadius.circular(50.0)),
            child: RotatedBox(
              quarterTurns: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    mainCategoryName == "Beauty" ? '' : '<<',
                    style: style,
                  ),
                  Text(
                    mainCategoryName.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.brown,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 10.0),
                  ),
                  Text(
                    mainCategoryName == "Men" ? '' : '>>',
                    style: style,
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class SubCategoryItem extends StatelessWidget {
  final String mainCategoryName;
  final String subCategoryName;
  final String assetName;
  final String subCategoryLabel;

  const SubCategoryItem(
      {Key? key,
      required this.mainCategoryName,
      required this.subCategoryName,
      required this.assetName,
      required this.subCategoryLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategoryProducts(
                      mainCategoryName: mainCategoryName,
                      subCategoryName: subCategoryName,
                    )));
      },
      child: Column(
        children: [
          SizedBox(
            height: 50.0,
            width: 50.0,
            child: Image(
              image: AssetImage(assetName),
            ),
          ),
          Text(
            subCategoryLabel.toUpperCase(),
            style: const TextStyle(fontSize: 12.0),
          )
        ],
      ),
    );
  }
}

const style = TextStyle(
    color: Colors.brown,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    letterSpacing: 10.0);

class CategoryHeaderLabel extends StatelessWidget {
  const CategoryHeaderLabel({Key? key, required this.label}) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        label,
        style: const TextStyle(
            fontSize: 24.0, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }
}
