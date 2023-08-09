import 'package:bequeen/catalogue/repository/catalogue_bloc.dart';
import 'package:bequeen/catalogue/screens/catalogue_detail.dart';
import 'package:bequeen/catalogue/widgets/catalogue_add_modal.dart';
import 'package:bequeen/profile/screens/profile_home.dart';
import 'package:bequeen/utils/global_search_bar.dart';
import 'package:bequeen/utils/side_menu.dart';
import 'package:bequeen/utils/side_menu_responsive.dart';
import 'package:bequeen/utils/skeleton_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hovering/hovering.dart';

class CatalogueHome extends StatefulWidget {
  CatalogueHome({Key? key}) : super(key: key);

  @override
  State<CatalogueHome> createState() => _CatalogueHomeState();
}

class _CatalogueHomeState extends State<CatalogueHome> {
  ScrollController scrollController = ScrollController();
  var userAuth = {};
  final storage = Hive.box("queensPlaceTecBoks");
  String filter = "";

  @override
  Widget build(BuildContext context) {
    userAuth = (storage.get('userAuth') == null) ? {} : storage.get('userAuth');
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
            width: MediaQuery.of(context).size.width / 1.1,
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
                        child: Text('Catálogo',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                            textAlign: TextAlign.center))
                  ])),
              const SizedBox(height: 10),
              GlobalSearchBar(
                  changeFilter: changeFilter,
                  icon: Container(),
                  title: '¿Que buscas?'),
              StreamBuilder(
                  stream: catalogueBloc.getCatalogue(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<DocumentSnapshot> catalogue = snapshot.data.docs;
                      if (catalogue.isEmpty) {
                        return const Center(
                            child: Text('¡Aún no existe ningún catálogo!'));
                      } else {
                        return Container(
                            padding: const EdgeInsets.all(10),
                            width: (media.width > 800)
                                ? MediaQuery.of(context).size.width / 1.1
                                : MediaQuery.of(context).size.width,
                            child: _buildListCatalogue(
                                listCatalogue(catalogue), context, media));
                      }
                    } else {
                      return const SkeletonLoader();
                    }
                  })
            ])));
  }

  listCatalogue(catalogue) {
    List<dynamic> newCatalogue = [];
    if (catalogue.length > 0) {
      for (var item in catalogue) {
        if (filter == '') {
          newCatalogue.add(item.data());
        } else if (item
            .data()['name']
            .toString()
            .toLowerCase()
            .contains(filter.toLowerCase())) {
          newCatalogue.add(item.data());
        }
      }
    }
    return newCatalogue;
  }

  Widget _buildListCatalogue(List<dynamic> catalogue, context, Size media) {
    return ListView.builder(
        itemCount: catalogue.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: _catalogueCard(catalogue[index], context, media),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CatalogueDetail(
                            catalogue: catalogue[index], userAuth: userAuth)));
              });
        });
  }

  Widget _catalogueCard(catalogue, context, Size media) {
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
        child: (media.width > 800)
            ? Row(children: [
                Container(
                    width: 150,
                    height: 150,
                    margin: EdgeInsets.only(right: 17),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Colors.grey.shade200, width: 1),
                        color: Colors.white),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FadeInImage(
                            placeholder:
                                AssetImage('assets/shopping-loader.gif'),
                            image: NetworkImage(catalogue['urlImage']),
                            fit: BoxFit.cover))),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text("${catalogue['name']}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      (catalogue['description'] == "")
                          ? Container()
                          : Text('${catalogue['description']}'),
                    ])),
                const SizedBox(width: 15),
                Icon(Icons.arrow_forward_ios, color: Colors.black)
              ])
            : Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Center(
                    child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: Colors.grey.shade200, width: 1),
                            color: Colors.grey.shade200),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: FadeInImage(
                                placeholder:
                                    AssetImage('assets/shopping-loader.gif'),
                                image: NetworkImage(catalogue['urlImage']),
                                fit: BoxFit.cover)))),
                const SizedBox(height: 15),
                Row(children: [
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                        Text("${catalogue['name']}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        (catalogue['description'] == "")
                            ? Container()
                            : Text('${catalogue['description']}',
                                textAlign: TextAlign.center),
                      ])),
                ]),
                const SizedBox(height: 15),
              ]));
  }

  Future _buildAddDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return CatalogueAddModal();
        });
  }

  changeFilter(text) {
    setState(() {
      filter = text;
    });
  }
}
