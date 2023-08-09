import 'package:bequeen/home/screens/home_lower.dart';
import 'package:bequeen/loyalty_points/screens/loyalty_points_admin.dart';
import 'package:flutter/material.dart';
import 'package:bequeen/auth/screens/auth_login.dart';
import 'package:bequeen/clients/screens/clients_home.dart';
import 'package:bequeen/home/screens/home.dart';
import 'package:bequeen/loyalty_points/screens/loyalty_points_home.dart';
import 'package:bequeen/profile/screens/profile_home.dart';
import 'package:bequeen/services/screens/services_home.dart';
import 'package:bequeen/workers/screens/workers_home.dart';

class SideMenu extends StatefulWidget {
  final double size;
  final dynamic userAuth;
  const SideMenu({Key? key, required this.size, required this.userAuth})
      : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _container(context);
  }

  Widget _container(context) {
    return SizedBox(
      width: widget.size,
      child: Drawer(
          child: ListView(children: [
        ListTile(
            title: Text(widget.size > 60 ? 'Citas' : ''),
            leading: const Icon(Icons.assignment_late),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => (widget.userAuth['email'] ==
                              'queenplacesps@gmail.com')
                          ? Home()
                          : HomeLower()),
                  (Route<dynamic> route) => false);
            }),
        (widget.userAuth['email'] == 'queenplacesps@gmail.com')
            ? ListTile(
                title: Text(widget.size > 60 ? 'Colaboradores' : ''),
                leading: const Icon(Icons.work_history),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WorkersHome()),
                      (Route<dynamic> route) => false);
                })
            : Container(),
        (widget.userAuth['email'] == 'queenplacesps@gmail.com' ||
                widget.userAuth['email'] == 'sharongaleas@hotmail.com')
            ? ListTile(
                title: Text(widget.size > 60 ? 'Clientes' : ''),
                leading: const Icon(Icons.group),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ClientsHome()),
                      (Route<dynamic> route) => false);
                })
            : Container(),
        (widget.userAuth['email'] == 'queenplacesps@gmail.com')
            ? ListTile(
                title: Text(widget.size > 60 ? 'Servicios' : ''),
                leading: const Icon(Icons.cleaning_services),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ServicesHome()),
                      (Route<dynamic> route) => false);
                })
            : Container(),
        (widget.userAuth['type'] == 'client' ||
                widget.userAuth['email'] == 'queenplacesps@gmail.com' ||
                widget.userAuth['email'] == 'sharongaleas@hotmail.com')
            ? ListTile(
                title: Text(widget.size > 60 ? 'Puntos de Lealtad' : ''),
                leading: const Icon(Icons.loyalty_outlined),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (widget.userAuth['email'] ==
                                      'queenplacesps@gmail.com' ||
                                  widget.userAuth['email'] ==
                                      'sharongaleas@hotmail.com')
                              ? LoyaltyPointsAdmin()
                              : const LoyaltyPointsHome()),
                      (Route<dynamic> route) => false);
                })
            : Container(),
        // (widget.userAuth['email'] == 'queenplacesps@gmail.com' ||
        //         widget.userAuth['type'] == 'client')
        //     ? ListTile(
        //         title: Text(widget.size > 60 ? 'Catálogo' : ''),
        //         leading: const Icon(Icons.shopping_cart),
        //         onTap: () {
        //           Navigator.pushAndRemoveUntil(
        //               context,
        //               MaterialPageRoute(builder: (context) => CatalogueHome()),
        //               (Route<dynamic> route) => false);
        //         })
        //     : Container(),
        ListTile(
            title: Text(widget.size > 60 ? 'Mi Perfil' : ''),
            leading: const Icon(Icons.person),
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileHome()),
                  (Route<dynamic> route) => false);
            }),
        const SizedBox(height: 20),
        ListTile(
            title: Text(widget.size > 60 ? 'Ver términos y privacidad' : ''),
            leading: const Icon(Icons.rule_folder),
            onTap: () {
              // Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => Home()),
              //     (Route<dynamic> route) => false);
            }),
        widget.size > 60
            ? Container(
                margin: const EdgeInsets.only(
                    top: 20, bottom: 10, left: 30, right: 30),
                padding: const EdgeInsets.all(10),
                child: InputChip(
                    backgroundColor: const Color.fromRGBO(228, 8, 0, 1),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AuthLogin()),
                          (Route<dynamic> route) => false);
                    },
                    elevation: 2,
                    label: const Text('Cerrar Sesión',
                        style: TextStyle(color: Colors.white))))
            : GestureDetector(
                child: const Icon(Icons.logout, color: Colors.red),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthLogin()),
                      (Route<dynamic> route) => false);
                }),
      ])),
    );
  }
}
