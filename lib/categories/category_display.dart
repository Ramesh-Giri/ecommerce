import 'package:flutter/material.dart';

import '../utilities/categ_list.dart';
import '../widgets/category_widgets.dart';

class CategoryDisplayScreen extends StatelessWidget {
  final String categoryName;

  const CategoryDisplayScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            left: 0.0,
            bottom: 0.0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 75.0,
                      crossAxisSpacing: 15.0,
                      children: List.generate(men.length, (index) {
                        return SubCategoryItem(
                            mainCategoryName: categoryName.toLowerCase(),
                            subCategoryName: men[index],
                            assetName:
                                'images/${categoryName.toLowerCase()}/${categoryName.toLowerCase()}$index.jpg',
                            subCategoryLabel: men[index]);
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
          SliderBar(
            mainCategoryName: categoryName.toUpperCase(),
          )
        ],
      ),
    );
  }
}
