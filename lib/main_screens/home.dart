import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../gallery/men_gallery.dart';
import '../widgets/fake_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const FakeSearch(),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.yellow,
            indicatorWeight: 2.0,
            tabs: [
              RepeatTab(title: 'Mens'),
              RepeatTab(title: 'Women'),
              RepeatTab(title: 'Shoes'),
              RepeatTab(title: 'Bags'),
              RepeatTab(title: 'Electronics'),
              RepeatTab(title: 'Accessories'),
              RepeatTab(title: 'Home & Gardens'),
              RepeatTab(title: 'Kids'),
              RepeatTab(title: 'Beauty'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MenGalleryScreen(),
            Center(child: Text('Womens\' Screen')),
            Center(child: Text('Shoes Screen')),
            Center(child: Text('Bags Screen')),
            Center(child: Text('Electronics Screen')),
            Center(child: Text('Accessories Screen')),
            Center(child: Text('Home & Gardens Screen')),
            Center(child: Text('Kids Screen')),
            Center(child: Text('Beauty Screen')),
          ],
        ),
      ),
    );
  }
}

class RepeatTab extends StatelessWidget {
  const RepeatTab({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        title,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
