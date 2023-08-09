import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imgList = ["assets/1.jpg", "assets/2.jpg", "assets/3.jpg"];

class WebSiteSliderResponsive extends StatefulWidget {
  WebSiteSliderResponsive({Key? key}) : super(key: key);

  @override
  State<WebSiteSliderResponsive> createState() =>
      _WebSiteSliderResponsiveState();
}

class _WebSiteSliderResponsiveState extends State<WebSiteSliderResponsive> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      CarouselSlider(
          items: imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 2.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              })),
      Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 12.0,
                height: 12.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        width: 1,
                        color: (_current == entry.key)
                            ? Colors.black
                            : Colors.white),
                    color:
                        (_current == entry.key) ? Colors.white : Colors.black),
              ),
            );
          }).toList()),
    ]);
  }

  final List<Widget> imageSliders = imgList
      .map((item) => Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(0, 2),
                      blurRadius: 5),
                ]),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Stack(children: <Widget>[
                  Image.asset(item, fit: BoxFit.fitHeight, width: 1000.0),
                ])),
          ))
      .toList();
}
