import 'package:bequeen/catalogue/repository/catalogue_bloc.dart';
import 'package:bequeen/catalogue/widgets/catalogue_detail_modal_images.dart';
import 'package:bequeen/utils/skeleton_loader.dart';
import 'package:flutter/material.dart';

class WebSiteProductsDetails extends StatefulWidget {
  final dynamic catalogue;
  WebSiteProductsDetails({Key? key, required this.catalogue}) : super(key: key);

  @override
  State<WebSiteProductsDetails> createState() => _WebSiteProductsDetailsState();
}

class _WebSiteProductsDetailsState extends State<WebSiteProductsDetails> {
  ScrollController scrollController = ScrollController();
  bool loading = false;
  int limit = 20;
  String filter = "";

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.offset ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          limit = limit * 2;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return _body(context, media);
  }

  Widget _body(context, Size media) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
                child: const Icon(Icons.arrow_back, color: Colors.black),
                onTap: () => Navigator.pop(context)),
            title: Row(children: [Text("${widget.catalogue['name']}")])),
        body: Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          child: Builder(
              builder: (context) => SingleChildScrollView(
                  controller: scrollController,
                  child: Center(
                      child: Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(children: [
                      Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(children: [
                            Expanded(
                                child: Container(
                                    width: 200,
                                    height: 130,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.transparent),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: FadeInImage(
                                            placeholder: AssetImage(
                                                'assets/shopping-loader.gif'),
                                            image: NetworkImage(
                                                widget.catalogue['urlImage']),
                                            fit: BoxFit.contain))))
                          ])),
                      const SizedBox(height: 10),
                      Text('${widget.catalogue['description']}',
                          textAlign: TextAlign.center),
                      const SizedBox(height: 10),
                      StreamBuilder(
                          stream: catalogueBloc.getCatalogueDetailClient(
                              limit, widget.catalogue["uid"]),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List catalogue = snapshot.data.docs;
                              if (catalogue.isEmpty) {
                                return Column(children: [
                                  const Center(
                                      child: Text("Catálogo",
                                          style: TextStyle(
                                              fontSize: 35,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))),
                                  Center(
                                      child: Container(
                                          width: 80,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.black))),
                                  const SizedBox(height: 10),
                                  const Center(
                                      child:
                                          Text('¡Aún no existe ninguna foto!')),
                                ]);
                              } else {
                                return Column(children: [
                                  const Center(
                                      child: Text("Catálogo",
                                          style: TextStyle(
                                              fontSize: 35,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold))),
                                  Center(
                                      child: Container(
                                          width: 80,
                                          height: 10,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.black))),
                                  const SizedBox(height: 10),
                                  Container(
                                      padding: const EdgeInsets.all(10),
                                      width: MediaQuery.of(context).size.width,
                                      child: _buildListCatalogue(
                                          listCatalogue(catalogue),
                                          media,
                                          context)),
                                ]);
                              }
                            } else {
                              return const SkeletonLoader();
                            }
                          }),
                      const SizedBox(height: 40),
                    ]),
                  )))),
        ));
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
    newCatalogue.length;
    return newCatalogue;
  }

  Widget _buildListCatalogue(List<dynamic> catalogue, Size media, context) {
    return GridView.builder(
        itemCount: catalogue.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: _catalogueCard(catalogue[index], context, media),
              onTap: () => _buildPhotoDetailDialog(context, catalogue[index]));
        },
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (media.width > 800) ? 4 : 2));
  }

  Widget _catalogueCard(catalogue, context, Size media) {
    return Card(
        elevation: 6,
        margin: (media.width > 700)
            ? const EdgeInsets.all(15)
            : const EdgeInsets.all(5),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(catalogue['images'][0]['urlImage']),
                  fit: BoxFit.cover)),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Row(children: [
              Expanded(
                  child: Container(
                      color: Color.fromRGBO(255, 255, 255, 0.98),
                      padding: EdgeInsets.all(5),
                      child: Column(children: [
                        Column(children: [
                          Text("${catalogue['name']}",
                              overflow: TextOverflow.ellipsis),
                        ]),
                      ]))),
            ]),
          ]),
        ));
  }

  Future _buildPhotoDetailDialog(BuildContext context, photo) {
    return showDialog(
        context: context,
        builder: (context) {
          return CatalogueDetailModalImages(catalogue: photo, isLogged: false);
        });
  }
}
