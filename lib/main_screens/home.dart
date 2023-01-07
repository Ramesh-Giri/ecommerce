import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../gallery/men_gallery.dart';
import '../gallery/shoes_gallery.dart';
import '../gallery/women_gallery.dart';
import '../utilities/app_color.dart';
import '../widgets/fake_search.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showAds = true;

  @override
  void initState() {
    super.initState();
    showAds = true;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade100.withOpacity(0.5),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          title: const FakeSearch(),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: AppColor.appPrimary,
            indicatorWeight: 2.0,
            tabs: const [
              RepeatTab(title: 'Mens'),
              RepeatTab(title: 'Women'),
              RepeatTab(title: 'Unisex'),
            ],
          ),
        ),
        body: Stack(
          children: [
            const TabBarView(
              children: [
                MenGalleryScreen(),
                WomenGalleryScreen(),
                UnisexGalleryScreen(),
              ],
            ),
            if (showAds)
              Positioned(
                bottom: 0.0,
                right: 0.0,
                left: 0.0,
                child: Stack(
                  children: [
                    const Card(
                      elevation: 10.0,
                      child: SizedBox(
                        height: 60.0,
                        child: Center(
                          child:
                              Text('Advertise with us at only \$20 per month'),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 5.0,
                        top: 5.0,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              showAds = false;
                            });
                          },
                          child: const Icon(
                            Icons.close,
                            size: 16.0,
                          ),
                        ))
                  ],
                ),
              ),
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
