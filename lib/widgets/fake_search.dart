import 'package:MON_PARFUM/utilities/app_color.dart';
import 'package:flutter/material.dart';

import '../minor_screens/search.dart';

class FakeSearch extends StatelessWidget {
  const FakeSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SearchScreen()));
      },
      child: Container(
        height: 35.0,
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColor.appPrimaryFaded,
              width: 1.4,
            ),
            borderRadius: BorderRadius.circular(25.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0),
                  child: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  'search',
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
              ],
            ),
            Container(
              height: 32.0,
              width: 75.0,
              decoration: BoxDecoration(
                  color: AppColor.appPrimary,
                  borderRadius: BorderRadius.circular(25.0)),
              child: const Center(
                child: Text(
                  'Search',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
