import 'package:bequeen/auth/screens/auth_login.dart';
import 'package:bequeen/web_site/widgets/web_site_products.dart';
import 'package:flutter/material.dart';

class WebSiteSideMenu extends StatefulWidget {
  final Function? scrollToTop;
  final Function? setItemAboutUsKey;
  final Function? setItemWhyUsKey;
  final Function? setItemLocationKey;
  final Function? setItemContactKey;
  const WebSiteSideMenu(
      {Key? key,
      this.scrollToTop,
      this.setItemAboutUsKey,
      this.setItemWhyUsKey,
      this.setItemLocationKey,
      this.setItemContactKey})
      : super(key: key);

  @override
  State<WebSiteSideMenu> createState() => _WebSiteSideMenuState();
}

class _WebSiteSideMenuState extends State<WebSiteSideMenu> {
  @override
  Widget build(BuildContext context) {
    return _container(context);
  }

  Widget _container(context) {
    return Drawer(
        child: ListView(children: [
      ListTile(
          title: const Text('Inicio'),
          leading: const Icon(Icons.home),
          onTap: () {
            widget.scrollToTop!();
            Navigator.pop(context);
          }),
      ListTile(
          title: const Text('Servicios'),
          leading: const Icon(Icons.store),
          onTap: () {
            widget.setItemAboutUsKey!();
            Navigator.pop(context);
          }),
      ListTile(
          title: const Text('Catálogo'),
          leading: const Icon(Icons.shopping_cart),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => WebSiteProducts()))),
      ListTile(
          title: const Text('Nosotros'),
          leading: const Icon(Icons.point_of_sale),
          onTap: () {
            widget.setItemWhyUsKey!();
            Navigator.pop(context);
          }),
      ListTile(
          title: const Text('Ubicación'),
          leading: const Icon(Icons.location_on),
          onTap: () {
            widget.setItemLocationKey!();
            Navigator.pop(context);
          }),
      ListTile(
          title: const Text('Contactanos'),
          leading: const Icon(Icons.work_outlined),
          onTap: () {
            widget.setItemContactKey!();
            Navigator.pop(context);
          }),
      InputChip(
          backgroundColor: Colors.yellow.shade700,
          onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const AuthLogin()),
              (Route<dynamic> route) => false),
          elevation: 2,
          label: const Text('Ingresar', style: TextStyle(color: Colors.white)))
    ]));
  }
}
