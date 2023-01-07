import 'package:MON_PARFUM/categories/unisex_category.dart';
import 'package:flutter/material.dart';

import '../categories/men_category.dart';
import '../categories/women_category.dart';
import '../widgets/fake_search.dart';

List<ItemsData> items = [
  ItemsData(label: 'Men'),
  ItemsData(label: 'Women'),
  ItemsData(label: 'Unisex'),
];

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();

    for (var item in items) {
      item.isSelected = false;
    }
    setState(() {
      items[0].isSelected = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        title: const FakeSearch(),
      ),
      body: Stack(
        children: [
          Positioned(bottom: 0.0, left: 0.0, child: sideNavigator(size)),
          Positioned(bottom: 0.0, right: 0.0, child: categoryView(size))
        ],
      ),
    );
  }

  Widget sideNavigator(Size size) {
    return SizedBox(
      height: size.height * 0.6,
      width: size.width * 0.2,
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                _pageController.animateToPage(index,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.easeIn);
              },
              child: Container(
                  color: items[index].isSelected
                      ? Colors.white
                      : Colors.grey.shade300,
                  height: 100.0,
                  child: Center(
                    child: Text(items[index].label),
                  )),
            );
          }),
    );
  }

  Widget categoryView(Size size) {
    return Container(
      height: size.height * 0.8,
      width: size.width * 0.8,
      color: Colors.white,
      child: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          for (var item in items) {
            item.isSelected = false;
          }
          setState(() {
            items[value].isSelected = true;
          });
        },
        scrollDirection: Axis.vertical,
        children: const [
          MenCategory(),
          WomenCategory(),
          UnisexCategory(),
        ],
      ),
    );
  }
}

class ItemsData {
  final String label;
  bool isSelected;

  ItemsData({required this.label, this.isSelected = false});
}
