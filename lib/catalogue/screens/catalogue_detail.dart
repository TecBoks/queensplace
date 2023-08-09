import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/catalogue/repository/catalogue_bloc.dart';
import 'package:bequeen/catalogue/widgets/catalogue_add_detail_modal.dart';
import 'package:bequeen/catalogue/widgets/catalogue_detail_modal_images.dart';
import 'package:bequeen/utils/loading.dart';
import 'package:bequeen/utils/skeleton_loader.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

class CatalogueDetail extends StatefulWidget {
  final dynamic userAuth;
  final dynamic catalogue;
  CatalogueDetail({Key? key, required this.catalogue, required this.userAuth})
      : super(key: key);

  @override
  State<CatalogueDetail> createState() => _CatalogueDetailState();
}

class _CatalogueDetailState extends State<CatalogueDetail> {
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
    return Stack(children: <Widget>[
      _body(context, media),
      StreamBuilder(
          stream: authBloc.loadingStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            loading = snapshot.data ?? false;
            return loading
                ? const Loading(
                    colorVariable: Color.fromRGBO(255, 255, 255, 0.7))
                : Container();
          })
    ]);
  }

  Widget _body(context, Size media) {
    return Scaffold(
        floatingActionButton:
            (widget.userAuth['email'] == 'queenplacesps@gmail.com')
                ? FloatingActionButton(
                    onPressed: () => _buildAddDialog(context),
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.add_circle, color: Colors.white))
                : Container(),
        backgroundColor: Colors.white,
        appBar:
            AppBar(title: Row(children: [Text("${widget.catalogue['name']}")])),
        body: Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          child: Builder(
              builder: (context) => SingleChildScrollView(
                  controller: scrollController,
                  child: Center(
                      child: Container(
                    padding: const EdgeInsets.all(10),
                    width: (media.width > 800)
                        ? MediaQuery.of(context).size.width / 1.2
                        : MediaQuery.of(context).size.width,
                    child: Column(children: [
                      const SizedBox(height: 10),
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
                          stream: (widget.userAuth["type"] == "worker")
                              ? catalogueBloc.getCatalogueDetail(
                                  limit, widget.catalogue["uid"])
                              : catalogueBloc.getCatalogueDetailClient(
                                  limit, widget.catalogue["uid"]),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List catalogue = snapshot.data.docs;
                              if (catalogue.isEmpty) {
                                return Column(children: [
                                  (widget.userAuth['email'] ==
                                          'queenplacesps@gmail.com')
                                      ? InputChip(
                                          backgroundColor: Colors.red,
                                          onPressed: () =>
                                              _buildDeleteDialog(context, 0),
                                          elevation: 2,
                                          label: const Text('Eliminar Catálogo',
                                              style: TextStyle(
                                                  color: Colors.white)))
                                      : Container(),
                                  (widget.userAuth['email'] ==
                                          'queenplacesps@gmail.com')
                                      ? const SizedBox(height: 10)
                                      : Container(),
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
                                  (widget.userAuth['email'] ==
                                          'queenplacesps@gmail.com')
                                      ? InputChip(
                                          backgroundColor: Colors.red,
                                          onPressed: () => _buildDeleteDialog(
                                              context, catalogue.length),
                                          elevation: 2,
                                          label: const Text('Eliminar Catálogo',
                                              style: TextStyle(
                                                  color: Colors.white)))
                                      : Container(),
                                  (widget.userAuth['email'] ==
                                          'queenplacesps@gmail.com')
                                      ? const SizedBox(height: 10)
                                      : Container(),
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
                                      width: (media.width > 800)
                                          ? MediaQuery.of(context).size.width /
                                              1.1
                                          : MediaQuery.of(context).size.width,
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

  Widget _buildListCatalogue(List<dynamic> catalogue, media, context) {
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
                        const SizedBox(height: 3),
                        (widget.userAuth['email'] == 'queenplacesps@gmail.com')
                            ? InputChip(
                                backgroundColor: (catalogue['state'])
                                    ? Colors.blue
                                    : Colors.green,
                                onPressed: () {
                                  authBloc.setIsLoading(true);
                                  var newUpdate = catalogue;
                                  newUpdate["state"] =
                                      (catalogue['state']) ? false : true;
                                  catalogueBloc
                                      .updateCatalogueDetail(newUpdate)
                                      .then((value) {
                                    authBloc.setIsLoading(false);
                                  });
                                },
                                elevation: 2,
                                label: Text(
                                    (catalogue['state'])
                                        ? 'Desactivar'
                                        : 'Activar',
                                    style: TextStyle(color: Colors.white)))
                            : Container(),
                        const SizedBox(height: 5),
                        (widget.userAuth['email'] == 'queenplacesps@gmail.com')
                            ? InputChip(
                                backgroundColor: Colors.red,
                                onPressed: () => _buildDeleteDetailDialog(
                                    context, catalogue),
                                elevation: 2,
                                label: const Text('Eliminar',
                                    style: TextStyle(color: Colors.white)))
                            : Container(),
                      ]))),
            ]),
          ]),
        ));
  }

  Future _buildPhotoDetailDialog(BuildContext context, catalogue) {
    return showDialog(
        context: context,
        builder: (context) {
          return CatalogueDetailModalImages(
              catalogue: catalogue, isLogged: true);
        });
  }

  Future _buildAddDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return CatalogueAddDetailModal(catalogue: widget.catalogue);
        });
  }

  Future _buildDeleteDialog(BuildContext context, int lengthList) {
    return showDialog(
        context: context,
        builder: (context) {
          bool isloading = false;
          return StreamBuilder(
              stream: authBloc.loadingStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                isloading = snapshot.data ?? false;
                return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text("¡Advertencia!"),
                    content:
                        Text("¿Seguro que quieres eliminar este catálogo?"),
                    actions: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 2,
                              backgroundColor: Colors.blue,
                              shape: const StadiumBorder()),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar',
                              style: TextStyle(color: Colors.white))),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              elevation: 2,
                              backgroundColor: Colors.white,
                              shape: const StadiumBorder()),
                          onPressed: () {
                            if (!isloading) {
                              if (lengthList > 0) {
                                MotionToast.error(
                                        title: const Text("Opps"),
                                        description: const Text(
                                            '¡Para eliminar este catálogo no debe tener ninguna imagen!'))
                                    .show(context);
                              } else {
                                authBloc.setIsLoading(true);
                                catalogueBloc
                                    .deleteCatalogue(widget.catalogue["uid"],
                                        '${widget.catalogue['pathImage']}.${widget.catalogue['photoExtension']}')
                                    .then((value) {
                                  Navigator.pop(context);
                                  authBloc.setIsLoading(false);
                                  Navigator.pop(context);
                                });
                              }
                            }
                          },
                          label: Text("Eliminar",
                              style: TextStyle(color: Colors.blue)),
                          icon: isloading
                              ? Container(
                                  width: 10,
                                  height: 10,
                                  margin: EdgeInsets.only(left: 5),
                                  child: CircularProgressIndicator(
                                      strokeWidth: 0.8,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.blue)))
                              : Container()),
                    ]);
              });
        });
  }

  Future _buildDeleteDetailDialog(BuildContext context, photo) {
    return showDialog(
        context: context,
        builder: (context) {
          bool isloading = false;
          return StreamBuilder(
              stream: authBloc.loadingStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                isloading = snapshot.data ?? false;
                return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text("¡Advertencia!"),
                    content:
                        Text("¿Seguro que quieres eliminar ${photo["name"]}?"),
                    actions: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 2,
                              backgroundColor: Colors.blue,
                              shape: const StadiumBorder()),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar',
                              style: TextStyle(color: Colors.white))),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              elevation: 2,
                              backgroundColor: Colors.white,
                              shape: const StadiumBorder()),
                          onPressed: () {
                            if (!isloading) {
                              authBloc.setIsLoading(true);
                              catalogueBloc
                                  .deleteCatalogueDetail(
                                      photo["uid"], photo['images'])
                                  .then((value) {
                                Navigator.pop(context);
                                authBloc.setIsLoading(false);
                              });
                            }
                          },
                          label: Text("Eliminar",
                              style: TextStyle(color: Colors.blue)),
                          icon: isloading
                              ? Container(
                                  width: 10,
                                  height: 10,
                                  margin: EdgeInsets.only(left: 5),
                                  child: CircularProgressIndicator(
                                      strokeWidth: 0.8,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.blue)))
                              : Container()),
                    ]);
              });
        });
  }
}
