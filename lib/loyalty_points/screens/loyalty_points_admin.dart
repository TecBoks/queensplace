import 'package:bequeen/clients/widgets/clients_add_client_modal.dart';
import 'package:bequeen/loyalty_points/repository/loyalty_points_bloc.dart';
import 'package:bequeen/loyalty_points/screens/loyalty_points_admin_detail.dart';
import 'package:bequeen/utils/global_search_bar.dart';
import 'package:bequeen/utils/skeleton_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:bequeen/profile/screens/profile_home.dart';
import 'package:bequeen/utils/side_menu.dart';
import 'package:bequeen/utils/side_menu_responsive.dart';

class LoyaltyPointsAdmin extends StatefulWidget {
  LoyaltyPointsAdmin({Key? key}) : super(key: key);

  @override
  State<LoyaltyPointsAdmin> createState() => _LoyaltyPointsAdminState();
}

class _LoyaltyPointsAdminState extends State<LoyaltyPointsAdmin> {
  ScrollController scrollController = ScrollController();
  String filter = "";
  var userAuth = {};
  final storage = Hive.box("queensPlaceTecBoks");
  bool loading = false;
  var date = DateTime.now();

  @override
  void initState() {
    userAuth = (storage.get('userAuth') == null)
        ? {}
        : Map.from(storage.get('userAuth'));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
        floatingActionButton: (userAuth['email'] == 'queenplacesps@gmail.com')
            ? FloatingActionButton(
                onPressed: () => _buildAddDialog(context),
                backgroundColor: Colors.blue,
                child: const Icon(Icons.add_circle, color: Colors.white))
            : Container(),
        backgroundColor: Colors.white,
        drawer:
            (media.width > 800) ? null : SideMenuResponsive(userAuth: userAuth),
        appBar: AppBar(
            title: Row(children: <Widget>[
          Container(
              width: 40,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Image.asset('assets/task.png')),
          Expanded(child: Container()),
          (media.width > 800)
              ? GestureDetector(
                  child: Text('¡Hola ${userAuth['name']}!'),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileHome()),
                        (Route<dynamic> route) => false);
                  })
              : Container(),
          (media.width > 800)
              ? GestureDetector(
                  child: (userAuth['photoURL'] == null ||
                          userAuth['photoURL'] == '')
                      ? Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade300),
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/profile.jpg'))))
                      : Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade300),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(userAuth['photoURL'])))),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileHome()),
                        (Route<dynamic> route) => false);
                  })
              : Container()
        ])),
        body: Stack(children: [
          Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: Builder(
                  builder: (context) => SingleChildScrollView(
                      controller: scrollController,
                      child: _container(context, media)))),
          (media.width > 800)
              ? HoverWidget(
                  hoverChild: SideMenu(size: 200, userAuth: userAuth),
                  child: SideMenu(size: 60, userAuth: userAuth),
                  onHover: (value) {})
              : Container(),
        ]));
  }

  Widget _container(context, Size media) {
    return Container(
        padding: const EdgeInsets.only(right: 15),
        width: MediaQuery.of(context).size.width,
        child: Container(
            margin: EdgeInsets.only(left: (media.width > 700) ? 60 : 0),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              Container(
                  height: 40,
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: const [
                    Expanded(
                        child: Text('Administración Puntos de Lealtad',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                            textAlign: TextAlign.center))
                  ])),
              const SizedBox(height: 10),
              GlobalSearchBar(
                  changeFilter: changeFilter,
                  icon: Container(),
                  title: 'Ingresar número de celular:'),
              StreamBuilder(
                  stream: loyaltyPointsBloc.getClients(filter),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> clients = snapshot.data.docs;
                      if (clients.isEmpty) {
                        return const Center(
                            child: Text('¡Aún no existe ningún cliente!'));
                      } else {
                        return Container(
                            padding: const EdgeInsets.all(10),
                            width: (media.width > 800)
                                ? MediaQuery.of(context).size.width / 1.1
                                : MediaQuery.of(context).size.width,
                            child: _buildListClients(
                                listClients(clients), context));
                      }
                    } else {
                      return const SkeletonLoader();
                    }
                  })
            ])));
  }

  listClients(clients) {
    List<dynamic> newClients = [];
    if (clients.length > 0) {
      for (var item in clients) {
        newClients.add(item.data());
      }
    }
    return newClients;
  }

  Widget _buildListClients(List<dynamic> clients, context) {
    return ListView.builder(
        itemCount: clients.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: _clientsCard(clients[index], context),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoyaltyPointsAdminDetail(client: clients[index])));
              });
        });
  }

  Widget _clientsCard(client, context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 5, bottom: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(0, 2),
                  blurRadius: 5),
            ]),
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("${client['name']}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                (client['email'] == "")
                    ? Container()
                    : Text('Correo: ${client['email']}'),
                (client['phone'] == "")
                    ? Container()
                    : Text('Contacto: ${client['phone']}'),
              ])),
          const SizedBox(width: 15),
          Icon(Icons.arrow_forward_ios)
        ]));
  }

  Future _buildAddDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return const ClientsAddClientModal();
        });
  }

  changeFilter(text) {
    setState(() {
      filter = text;
    });
  }
}
