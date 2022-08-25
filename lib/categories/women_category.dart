import 'package:flutter/material.dart';
import 'package:multi_store_app/utilities/categ_list.dart';

import '../widgets/category_widgets.dart';

class WomenCategory extends StatefulWidget {
  const WomenCategory({Key? key}) : super(key: key);

  @override
  State<WomenCategory> createState() => _WomenCategoryState();
}

class _WomenCategoryState extends State<WomenCategory> {
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
                    label: 'Women',
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.68,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 75.0,
                      crossAxisSpacing: 15.0,
                      children: List.generate(women.length - 1, (index) {
                        return SubCategoryItem(
                            mainCategoryName: 'women',
                            subCategoryName: women[index + 1],
                            assetName: 'images/women/women$index.jpg',
                            subCategoryLabel: women[index + 1]);
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
          const SliderBar(
            mainCategoryName: 'Women',
          )
        ],
      ),
    );
  }
}
