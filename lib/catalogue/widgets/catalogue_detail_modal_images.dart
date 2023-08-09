import 'package:flutter/material.dart';

class CatalogueDetailModalImages extends StatefulWidget {
  final dynamic catalogue;
  final bool isLogged;
  CatalogueDetailModalImages(
      {Key? key, required this.catalogue, required this.isLogged})
      : super(key: key);

  @override
  State<CatalogueDetailModalImages> createState() =>
      _CatalogueDetailModalImagesState();
}

class _CatalogueDetailModalImagesState
    extends State<CatalogueDetailModalImages> {
  int indexSelected = 0;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Container(
        decoration: BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.9)),
        child: Column(children: [
          SizedBox(height: 15),
          Row(children: [
            Expanded(child: Container()),
            GestureDetector(
                child: Icon(Icons.close, color: Colors.white, size: 30),
                onTap: () => Navigator.pop(context)),
            SizedBox(width: 15)
          ]),
          SizedBox(height: 15),
          Row(children: [
            Expanded(
                child: Column(children: [
              Text("${widget.catalogue['name']}",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              (widget.catalogue['description'] == "")
                  ? Container()
                  : Text('Descripción: ${widget.catalogue['description']}',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center),
              (!widget.isLogged)
                  ? Container()
                  : (widget.catalogue['description'] == "")
                      ? Container()
                      : Text('Precio: ${widget.catalogue['price']}',
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center),
            ]))
          ]),
          SizedBox(height: 15),
          Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width / 2,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: FadeInImage(
                      placeholder: AssetImage('assets/shopping-loader.gif'),
                      image: NetworkImage(widget.catalogue['images']
                          [indexSelected]['urlImage']),
                      fit: BoxFit.contain))),
          SizedBox(height: 15),
          (widget.catalogue['images'].length == 1)
              ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  pickImageCard(media, 0, context),
                ])
              : (widget.catalogue['images'].length == 2)
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      pickImageCard(media, 0, context),
                      SizedBox(width: 10),
                      pickImageCard(media, 1, context),
                    ])
                  : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      pickImageCard(media, 0, context),
                      SizedBox(width: 10),
                      pickImageCard(media, 1, context),
                      SizedBox(width: 10),
                      pickImageCard(media, 2, context),
                    ]),
          SizedBox(height: 20),
        ]));
  }

  Widget pickImageCard(Size media, index, context) {
    return GestureDetector(
        child: Container(
            width: (media.width > 800) ? 110 : 65,
            height: (media.width > 800) ? 110 : 65,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                    placeholder: AssetImage('assets/shopping-loader.gif'),
                    image: NetworkImage(
                        widget.catalogue['images'][index]['urlImage']),
                    fit: BoxFit.contain))),
        onTap: () {
          setState(() {
            indexSelected = index;
          });
        });
  }
}
