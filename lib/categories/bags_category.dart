import 'package:flutter/material.dart';
import 'package:multi_store_app/utilities/categ_list.dart';

import '../widgets/category_widgets.dart';

class BagsCategory extends StatefulWidget {
  const BagsCategory({Key? key}) : super(key: key);

  @override
  State<BagsCategory> createState() => _BagsCategoryState();
}

class _BagsCategoryState extends State<BagsCategory> {
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
                  const CategoryHeaderLabel(
                    label: 'Bags',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 75.0,
                      crossAxisSpacing: 15.0,
                      children: List.generate(bags.length - 1, (index) {
                        return SubCategoryItem(
                            mainCategoryName: 'bags',
                            subCategoryName: bags[index + 1],
                            assetName: 'images/bags/bags$index.jpg',
                            subCategoryLabel: bags[index + 1]);
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SliderBar(
            mainCategoryName: 'Bags',
          )
        ],
      ),
    );
  }
}
