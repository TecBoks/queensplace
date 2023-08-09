import 'package:bequeen/web_site/widgets/web_site_mision_vision.dart';
import 'package:flutter/material.dart';

class WebSiteAboutUs extends StatefulWidget {
  WebSiteAboutUs({Key? key}) : super(key: key);

  @override
  State<WebSiteAboutUs> createState() => _WebSiteAboutUsState();
}

class _WebSiteAboutUsState extends State<WebSiteAboutUs> {
  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Column(children: [
      const SizedBox(height: 20),
      Center(
          child: Text("Nosotros",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.yellow.shade700,
                  fontWeight: FontWeight.bold))),
      Center(
          child: Container(
              width: 80,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.yellow.shade700))),
      const SizedBox(height: 40),
      (media.width > 800)
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                    height: 450,
                    width: 450,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        image: DecorationImage(
                            fit: BoxFit.fitHeight,
                            image: AssetImage("assets/image1.jpg")))),
              ]),
              Column(children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width / 2.2,
                    child: const Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc facilisis congue erat tempor placerat. Integer suscipit ullamcorper tristique. Pellentesque vitae ultrices lorem, id maximus ipsum. Proin tincidunt sed nulla vitae imperdiet. Nullam mollis egestas efficitur. Morbi congue nulla nec lorem ornare, a vulputate velit accumsan. Ut id lacus ligula. Donec mollis, nibh a volutpat ornare, ante arcu auctor augue, sagittis ornare metus diam vel orci. Nam mi enim, malesuada in nisl at, consequat laoreet ex. Praesent pulvinar sem at dictum maximus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus euismod tincidunt orci. Vivamus ultrices sed purus tincidunt gravida. Etiam eget congue mauris.")),
                const SizedBox(height: 10),
                SizedBox(
                    width: 170,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            elevation: 2,
                            backgroundColor: Colors.yellow.shade700,
                            shape: const StadiumBorder()),
                        onPressed: () {
                          _buildDialog(context);
                        },
                        child: const SizedBox(
                            height: 45,
                            width: double.infinity,
                            child: Center(
                              child: Text("Misión Y Visión",
                                  style: TextStyle(color: Colors.white)),
                            )))),
                const SizedBox(height: 10),
              ]),
            ])
          : Column(children: [
              Container(
                  margin: const EdgeInsets.all(20),
                  child: const Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc facilisis congue erat tempor placerat. Integer suscipit ullamcorper tristique. Pellentesque vitae ultrices lorem, id maximus ipsum. Proin tincidunt sed nulla vitae imperdiet. Nullam mollis egestas efficitur. Morbi congue nulla nec lorem ornare, a vulputate velit accumsan. Ut id lacus ligula. Donec mollis, nibh a volutpat ornare, ante arcu auctor augue, sagittis ornare metus diam vel orci. Nam mi enim, malesuada in nisl at, consequat laoreet ex. Praesent pulvinar sem at dictum maximus. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus euismod tincidunt orci. Vivamus ultrices sed purus tincidunt gravida. Etiam eget congue mauris.")),
              const SizedBox(height: 10),
              SizedBox(
                  width: 170,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Colors.yellow.shade700,
                          shape: const StadiumBorder()),
                      onPressed: () {
                        _buildDialog(context);
                      },
                      child: const SizedBox(
                          height: 45,
                          width: double.infinity,
                          child: Center(
                            child: Text("Misión Y Visión",
                                style: TextStyle(color: Colors.white)),
                          )))),
              const SizedBox(height: 10),
            ]),
    ]);
  }

  Future _buildDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return WebSiteMisionVision();
        });
  }
}
