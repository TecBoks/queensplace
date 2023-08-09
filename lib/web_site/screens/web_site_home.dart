import 'package:bequeen/auth/screens/auth_login.dart';
import 'package:bequeen/web_site/widgets/web_site_about_us.dart';
import 'package:bequeen/web_site/widgets/web_site_contact_us.dart';
import 'package:bequeen/web_site/widgets/web_site_location.dart';
import 'package:bequeen/web_site/widgets/web_site_products.dart';
import 'package:bequeen/web_site/widgets/web_site_side_menu.dart';
import 'package:bequeen/web_site/widgets/web_site_slider.dart';
import 'package:bequeen/web_site/widgets/web_site_slider_responsive.dart';
import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebSiteHome extends StatefulWidget {
  const WebSiteHome({Key? key}) : super(key: key);

  @override
  State<WebSiteHome> createState() => _WebSiteHomeState();
}

class _WebSiteHomeState extends State<WebSiteHome> {
  ScrollController scrollController = ScrollController();
  final itemAboutUsKey = GlobalKey();
  final itemWhyUsKey = GlobalKey();
  final itemLocationKey = GlobalKey();
  final itemContactUsKey = GlobalKey();
  bool showBackToTopButton = false;
  double scrollOffset = 0.0;

  @override
  void initState() {
    scrollController = ScrollController()
      ..addListener(() {
        setState(() {
          scrollOffset = scrollController.offset;
          if (scrollOffset >= 100) {
            showBackToTopButton = true;
          } else {
            showBackToTopButton = false;
          }
        });
      });
    super.initState();
  }

  scrollToTop() {
    scrollController.animateTo(0,
        duration: const Duration(milliseconds: 500), curve: Curves.linear);
  }

  setItemAboutUsKey() async {
    final contextS = itemAboutUsKey.currentContext!;
    await Scrollable.ensureVisible(contextS,
        duration: const Duration(milliseconds: 1000));
  }

  setItemWhyUsKey() async {
    final contextS = itemWhyUsKey.currentContext!;
    await Scrollable.ensureVisible(contextS,
        duration: const Duration(milliseconds: 1000));
  }

  setItemLocationKey() async {
    final contextS = itemLocationKey.currentContext!;
    await Scrollable.ensureVisible(contextS,
        duration: const Duration(milliseconds: 1000));
  }

  setItemContactUsKey() async {
    final contextS = itemContactUsKey.currentContext!;
    await Scrollable.ensureVisible(contextS,
        duration: const Duration(milliseconds: 1000));
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: (showBackToTopButton)
            ? FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () => scrollToTop(),
                child: const Icon(Icons.arrow_upward, color: Colors.white))
            : null,
        drawer: (media.width > 1000)
            ? null
            : WebSiteSideMenu(
                scrollToTop: scrollToTop,
                setItemWhyUsKey: setItemWhyUsKey,
                setItemAboutUsKey: setItemAboutUsKey,
                setItemLocationKey: setItemLocationKey,
                setItemContactKey: setItemContactUsKey),
        appBar: AppBar(
          toolbarHeight: 75,
          backgroundColor: const Color.fromRGBO(51, 51, 51, 1),
          iconTheme: const IconThemeData(color: Colors.white),
          title: Row(children: [
            GestureDetector(
                child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                        height: 50,
                        width: 140,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.contain,
                                image: AssetImage("assets/logo.png"))))),
                onTap: () => scrollToTop()),
            const SizedBox(width: 10),
            Expanded(child: Container()),
            (media.width > 1000)
                ? HoverWidget(
                    hoverChild: GestureDetector(
                        child: menuItem(
                            context,
                            "Inicio",
                            const Color.fromRGBO(33, 33, 33, 0.6),
                            Colors.white),
                        onTap: () {
                          scrollToTop();
                        }),
                    onHover: (value) {},
                    child: menuItem(
                        context, "Inicio", Colors.transparent, Colors.white))
                : Container(),
            (media.width > 1000)
                ? HoverWidget(
                    hoverChild: GestureDetector(
                        child: menuItem(
                            context,
                            "Servicios",
                            const Color.fromRGBO(33, 33, 33, 0.6),
                            Colors.white),
                        onTap: () {
                          setItemAboutUsKey();
                        }),
                    onHover: (value) {},
                    child: menuItem(
                        context, "Servicios", Colors.transparent, Colors.white))
                : Container(),
            (media.width > 1000)
                ? HoverWidget(
                    hoverChild: GestureDetector(
                        child: menuItem(
                            context,
                            "Catálogo",
                            const Color.fromRGBO(33, 33, 33, 0.6),
                            Colors.white),
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WebSiteProducts()))),
                    onHover: (value) {},
                    child: menuItem(
                        context, "Catálogo", Colors.transparent, Colors.white))
                : Container(),
            (media.width > 1000)
                ? HoverWidget(
                    hoverChild: GestureDetector(
                        child: menuItem(
                            context,
                            "Nosotros",
                            const Color.fromRGBO(33, 33, 33, 0.6),
                            Colors.white),
                        onTap: () {
                          setItemWhyUsKey();
                        }),
                    onHover: (value) {},
                    child: menuItem(
                        context, "Nosotros", Colors.transparent, Colors.white))
                : Container(),
            (media.width > 1000)
                ? HoverWidget(
                    hoverChild: GestureDetector(
                        child: menuItem(
                            context,
                            "Ubicación",
                            const Color.fromRGBO(33, 33, 33, 0.6),
                            Colors.white),
                        onTap: () {
                          setItemLocationKey();
                        }),
                    onHover: (value) {},
                    child: menuItem(
                        context, "Ubicación", Colors.transparent, Colors.white))
                : Container(),
            (media.width > 1000)
                ? HoverWidget(
                    hoverChild: GestureDetector(
                        child: menuItem(
                            context,
                            "Contactanos",
                            const Color.fromRGBO(33, 33, 33, 0.6),
                            Colors.white),
                        onTap: () {
                          setItemContactUsKey();
                        }),
                    onHover: (value) {},
                    child: menuItem(context, "Contactanos", Colors.transparent,
                        Colors.white))
                : Container(),
            (media.width > 1000)
                ? InputChip(
                    backgroundColor: Colors.yellow.shade700,
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthLogin()),
                        (Route<dynamic> route) => false),
                    elevation: 2,
                    label: const Text('Ingresar',
                        style: TextStyle(color: Colors.white)))
                : Container(),
          ]),
        ),
        body: SafeArea(
            child: Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          child: Builder(
              builder: (context) => SingleChildScrollView(
                  controller: scrollController,
                  child: Column(children: [
                    (media.width > 700)
                        ? Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(color: Colors.yellow),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  (media.width > 700)
                                      ? Container()
                                      : Text("Queen's Place"),
                                  SizedBox(width: 20),
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 2,
                                          backgroundColor: Colors.black,
                                          shape: const StadiumBorder()),
                                      onPressed: () => _launchURL(
                                          "https://play.google.com/store/apps/details?id=com.tecboks.bequeen"),
                                      label: Container(
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 10,
                                              bottom: 10),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Descarga la app en:",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10)),
                                                Text("Google Play",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                              ])),
                                      icon: Container(
                                          width: 40,
                                          margin: EdgeInsets.only(left: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Image.asset(
                                              'assets/google.png'))),
                                  SizedBox(width: 20),
                                  ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 2,
                                          backgroundColor: Colors.black,
                                          shape: const StadiumBorder()),
                                      onPressed: () => _launchURL(
                                          "https://apps.apple.com/hn/app/queens-place/id6446909432"),
                                      label: Container(
                                          margin: EdgeInsets.only(
                                              left: 20,
                                              right: 20,
                                              top: 10,
                                              bottom: 10),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Descarga la app en:",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10)),
                                                Text("App Store",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20)),
                                              ])),
                                      icon: Container(
                                          width: 30,
                                          margin: EdgeInsets.only(left: 20),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child:
                                              Image.asset('assets/apple.png'))),
                                ]))
                        : Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(30),
                            decoration: BoxDecoration(color: Colors.yellow),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  (media.width > 700)
                                      ? Container()
                                      : Text("Queen's Place",
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold)),
                                  SizedBox(height: 10),
                                  Card(
                                      child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(children: [
                                      ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 2,
                                              backgroundColor: Colors.black,
                                              shape: const StadiumBorder()),
                                          onPressed: () => _launchURL(
                                              "https://play.google.com/store/apps/details?id=com.tecboks.bequeen"),
                                          label: Container(
                                              margin: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Descarga la app en:",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10)),
                                                    Text("Google Play",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20)),
                                                  ])),
                                          icon: Container(
                                              width: 40,
                                              margin: EdgeInsets.only(left: 20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  'assets/google.png'))),
                                      SizedBox(height: 10),
                                      ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 2,
                                              backgroundColor: Colors.black,
                                              shape: const StadiumBorder()),
                                          onPressed: () => _launchURL(
                                              "https://apps.apple.com/hn/app/queens-place/id6446909432"),
                                          label: Container(
                                              margin: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Descarga la app en:",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10)),
                                                    Text("App Store",
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 20)),
                                                  ])),
                                          icon: Container(
                                              width: 30,
                                              margin: EdgeInsets.only(left: 20),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                              child: Image.asset(
                                                  'assets/apple.png'))),
                                    ]),
                                  )),
                                ])),
                    (media.width > 700)
                        ? WebSiteSlider()
                        : WebSiteSliderResponsive(),
                    // Container(
                    //     key: itemAboutUsKey,
                    //     width: double.infinity,
                    //     decoration: const BoxDecoration(
                    //         color: Color.fromRGBO(255, 255, 255, 0.94),
                    //         image: DecorationImage(
                    //             fit: BoxFit.cover,
                    //             image: AssetImage("assets/3.jpg"))),
                    //     child: const HomeAboutUs()),
                    Container(
                        key: itemWhyUsKey,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(255, 255, 255, 0.94)),
                        child: WebSiteAboutUs()),
                    Container(
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage("assets/belleza.jpg"))),
                        child: Container(
                            key: itemLocationKey,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Color.fromRGBO(0, 0, 0, 0.6)),
                            child: const WebSiteLocation())),
                    Container(
                        key: itemContactUsKey,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            color: Color.fromRGBO(33, 34, 34, 1)),
                        child: const WebSiteContactUs()),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(color: Colors.black),
                        child: Column(children: [
                          (media.width > 800)
                              ? Row(children: [
                                  const Spacer(),
                                  Column(children: [
                                    Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Container(
                                            height: 80,
                                            width: 200,
                                            decoration: const BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.contain,
                                                    image: AssetImage(
                                                        "assets/logo.png"))))),
                                    const SizedBox(height: 10),
                                    const Text('''Bo. Los Andes, 12 y 13 Calle, 
11 Ave, Casa23 Color Gris,
San Pedro Sula, Cortes
Cel: +504 9421-2537
''', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))
                                  ]),
                                  const Spacer(),
                                  Column(children: [
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                              child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  margin: const EdgeInsets.only(
                                                      left: 5),
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage(
                                                              'assets/facebook.png')))),
                                              onTap: () => _launchURL(
                                                  "https://www.facebook.com/bqueenhairhn")),
                                          const SizedBox(width: 10),
                                          GestureDetector(
                                              child: Container(
                                                  height: 40,
                                                  width: 40,
                                                  margin: const EdgeInsets.only(
                                                      left: 5),
                                                  decoration: const BoxDecoration(
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: AssetImage(
                                                              'assets/instagram.png')))),
                                              onTap: () => _launchURL(
                                                  "https://www.instagram.com/bqueenhairstudiohn/")),
                                        ]),
                                    const SizedBox(height: 10),
                                  ]),
                                  const Spacer(),
                                  Column(children: [
                                    const Text("MENU",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    GestureDetector(
                                        onTap: () => scrollToTop(),
                                        child:
                                            menuItemFooter(context, "INICIO")),
                                    GestureDetector(
                                        onTap: () => setItemAboutUsKey(),
                                        child: menuItemFooter(
                                            context, "Servicios")),
                                    GestureDetector(
                                        onTap: () => setItemWhyUsKey(),
                                        child: menuItemFooter(
                                            context, "Nosotros")),
                                    GestureDetector(
                                        onTap: () => setItemLocationKey(),
                                        child: menuItemFooter(
                                            context, "Ubicación")),
                                    GestureDetector(
                                        onTap: () => setItemContactUsKey(),
                                        child: menuItemFooter(
                                            context, "Contactanos")),
                                  ]),
                                  const Spacer(),
                                ])
                              : Column(children: [
                                  Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                          height: 80,
                                          width: 200,
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.contain,
                                                  image: AssetImage(
                                                      "assets/logo.png"))))),
                                  const SizedBox(height: 10),
                                  const Text('''Bo. Los Andes, 12 y 13 Calle, 
11 Ave, Casa23 Color Gris,
San Pedro Sula, Cortes
Cel: +504 9421-2537
''', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                                  const SizedBox(height: 10),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                            child: Container(
                                                height: 40,
                                                width: 40,
                                                margin: const EdgeInsets.only(
                                                    left: 5),
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                            'assets/facebook.png')))),
                                            onTap: () => _launchURL(
                                                "https://www.facebook.com/bqueenhairhn")),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                            child: Container(
                                                height: 40,
                                                width: 40,
                                                margin: const EdgeInsets.only(
                                                    left: 5),
                                                decoration: const BoxDecoration(
                                                    image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: AssetImage(
                                                            'assets/instagram.png')))),
                                            onTap: () => _launchURL(
                                                "https://www.instagram.com/bqueenhairstudiohn/")),
                                      ]),
                                  const SizedBox(height: 10),
                                ])
                        ])),
                    Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: const BoxDecoration(color: Colors.black87),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Copyright 2023 All Rights Reserved",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const Text(" | ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              GestureDetector(
                                  onTap: () =>
                                      _launchURL("https://www.tecboks.com/"),
                                  child: menuItemFooter(context, "By TECBOKS")),
                            ])),
                  ]))),
        )));
  }

  Widget menuItem(context, String title, Color color1, Color color2) {
    return Container(
        height: 70,
        color: color1,
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Center(child: Text(title, style: TextStyle(color: color2))));
  }

  Widget menuItemFooter(context, String title) {
    return HoverWidget(
        hoverChild: Text(title,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.yellow.shade700)),
        onHover: (value) {},
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white)));
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(Uri.encodeFull(url))) {
      await launchUrlString(Uri.encodeFull(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
