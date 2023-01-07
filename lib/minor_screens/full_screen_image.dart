import 'package:flutter/material.dart';

import '../utilities/app_color.dart';
import '../widgets/appbar_widgets.dart';

class FullScreenImage extends StatefulWidget {
  final List<dynamic> images;

  const FullScreenImage({Key? key, required this.images}) : super(key: key);

  @override
  State<FullScreenImage> createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  final _controller = PageController();
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: const AppBarBackButton(),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Center(
              child: Text(
            '${selectedIndex + 1}/${widget.images.length.toString()} ',
            style: const TextStyle(fontSize: 24.0, letterSpacing: 8.0),
          )),
          SizedBox(
            height: size.height * 0.6,
            child: PageView(
              onPageChanged: (value) => setState(() {
                selectedIndex = value;
              }),
              controller: _controller,
              children: images(),
            ),
          ),
          SizedBox(
            height: size.height * 0.2,
            child: imageView(),
          )
        ],
      ),
    );
  }

  List<Widget> images() {
    return List.generate(
        widget.images.length,
        (index) => InteractiveViewer(
            transformationController: TransformationController(),
            child: Image.network(widget.images[index])));
  }

  Widget imageView() {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.images.length,
        itemBuilder: (context, index) => GestureDetector(
              onTap: () => _controller.jumpToPage(index),
              child: Container(
                  margin: const EdgeInsets.all(8.0),
                  width: 120.0,
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 2.0,
                          color: selectedIndex == index
                              ? AppColor.appPrimary
                              : Colors.transparent),
                      borderRadius: BorderRadius.circular(15.0)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      widget.images[index],
                      fit: BoxFit.cover,
                    ),
                  )),
            ));
  }
}
