import 'package:flutter/material.dart';

class WebSiteMisionVision extends StatefulWidget {
  WebSiteMisionVision({Key? key}) : super(key: key);

  @override
  State<WebSiteMisionVision> createState() => _WebSiteMisionVisionState();
}

class _WebSiteMisionVisionState extends State<WebSiteMisionVision> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Expanded(child: Container()),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: Colors.white,
                  shape: const StadiumBorder()),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.close, color: Colors.red)),
        ]),
        content: SizedBox(
            width: (media.width > 800)
                ? MediaQuery.of(context).size.width / 2.5
                : MediaQuery.of(context).size.width / 1,
            height: MediaQuery.of(context).size.height / 2.5,
            child: Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                trackVisibility: true,
                child: Builder(
                  builder: (context) => SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: Column(children: [
                          const Center(
                              child: Text("Misión",
                                  style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                          Center(
                              child: Container(
                                  width: 60,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.yellow.shade700))),
                          const SizedBox(height: 10),
                          const Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc facilisis congue erat tempor placerat. Integer suscipit ullamcorper tristique. Pellentesque vitae ultrices lorem, id maximus ipsum. Proin tincidunt sed nulla vitae imperdiet. Nullam mollis egestas efficitur. Morbi congue nulla nec lorem ornare, a vulputate velit accumsan. Ut id lacus ligula. Donec mollis, nibh a volutpat ornare, ante arcu auctor augue, sagittis ornare metus diam vel orci. Nam mi enim, malesuada in nisl at, consequat laoreet ex. Praesent pulvinar sem at dictum maximus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus euismod tincidunt orci. Vivamus ultrices sed purus tincidunt gravida. Etiam eget congue mauris.'),
                          const SizedBox(height: 10),
                          const Center(
                              child: Text("Visión",
                                  style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))),
                          Center(
                              child: Container(
                                  width: 60,
                                  height: 6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.yellow.shade700))),
                          const Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc facilisis congue erat tempor placerat. Integer suscipit ullamcorper tristique. Pellentesque vitae ultrices lorem, id maximus ipsum. Proin tincidunt sed nulla vitae imperdiet. Nullam mollis egestas efficitur. Morbi congue nulla nec lorem ornare, a vulputate velit accumsan. Ut id lacus ligula. Donec mollis, nibh a volutpat ornare, ante arcu auctor augue, sagittis ornare metus diam vel orci. Nam mi enim, malesuada in nisl at, consequat laoreet ex. Praesent pulvinar sem at dictum maximus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus euismod tincidunt orci. Vivamus ultrices sed purus tincidunt gravida. Etiam eget congue mauris.'),
                        ]),
                      )),
                ))));
  }
}
