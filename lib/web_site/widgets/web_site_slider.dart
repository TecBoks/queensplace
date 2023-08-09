import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = ["assets/1.jpg", "assets/2.jpg", "assets/3.jpg"];

class WebSiteSlider extends StatefulWidget {
  WebSiteSlider({Key? key}) : super(key: key);

  @override
  State<WebSiteSlider> createState() => _WebSiteSliderState();
}

class _WebSiteSliderState extends State<WebSiteSlider> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Stack(children: [
      CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: false,
              height: media.height - 75,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              })),
      Positioned.fill(
          child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 25,
                  height: 25,
                  margin: const EdgeInsets.symmetric(
                      vertical: 100.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                          width: 1,
                          color: (_current == entry.key)
                              ? Colors.black
                              : Colors.white),
                      shape: BoxShape.circle,
                      color: (_current == entry.key)
                          ? Colors.white
                          : Colors.black),
                ),
              );
            }).toList()),
      )),
    ]);
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            color: Colors.black,
            width: double.infinity,
            child: Image.asset(item, fit: BoxFit.fitHeight),
          ))
      .toList();
}
