import 'package:bequeen/catalogue/repository/catalogue_bloc.dart';
import 'package:bequeen/utils/skeleton_loader.dart';
import 'package:bequeen/web_site/widgets/web_site_products_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WebSiteProducts extends StatefulWidget {
  WebSiteProducts({Key? key}) : super(key: key);

  @override
  State<WebSiteProducts> createState() => _WebSiteProductsState();
}

class _WebSiteProductsState extends State<WebSiteProducts> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
                child: const Icon(Icons.arrow_back, color: Colors.black),
                onTap: () => Navigator.pop(context)),
            title: Row(children: [])),
        body: SafeArea(
          child: Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: Builder(
                  builder: (context) => SingleChildScrollView(
                      controller: scrollController,
                      child: _container(context, media)))),
        ));
  }

  Widget _container(context, Size media) {
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
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
                            width: MediaQuery.of(context).size.width,
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
        newCatalogue.add(item.data());
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
                        builder: (context) => WebSiteProductsDetails(
                            catalogue: catalogue[index])));
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
}
