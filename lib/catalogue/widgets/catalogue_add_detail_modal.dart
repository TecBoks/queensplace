import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/catalogue/repository/catalogue_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';

class CatalogueAddDetailModal extends StatefulWidget {
  final dynamic catalogue;
  CatalogueAddDetailModal({Key? key, required this.catalogue})
      : super(key: key);

  @override
  State<CatalogueAddDetailModal> createState() =>
      _CatalogueAddDetailModalState();
}

class _CatalogueAddDetailModalState extends State<CatalogueAddDetailModal> {
  ScrollController scrollController = ScrollController();
  TextEditingController ctrlName = TextEditingController(text: '');
  TextEditingController ctrlDescription = TextEditingController(text: '');
  TextEditingController ctrlPrice = TextEditingController(text: '');
  List fileBytesList = [];
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: authBloc.loadingStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          loading = snapshot.data ?? false;
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text('Agregar nueva imagen:'),
              content: SizedBox(
                  width: (media.width > 950)
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width / 1,
                  height: 350,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: scrollController,
                    child: Builder(
                        builder: (context) => SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              margin: EdgeInsets.only(right: 15),
                              child: Column(children: [
                                TextField(
                                    controller: ctrlName,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.0)),
                                        labelStyle:
                                            TextStyle(color: Colors.grey[700]),
                                        labelText: '* Nombre:',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                        ))),
                                const SizedBox(height: 10),
                                TextField(
                                    controller: ctrlDescription,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.0)),
                                        labelStyle:
                                            TextStyle(color: Colors.grey[700]),
                                        labelText: 'Descripción:',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                        ))),
                                const SizedBox(height: 10),
                                TextField(
                                    controller: ctrlPrice,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(
                                          RegExp("[0-9.]"))
                                    ],
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(7.0)),
                                        labelStyle:
                                            TextStyle(color: Colors.grey[700]),
                                        labelText: 'Precio:',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                        ))),
                                SizedBox(height: 10),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                          child: pickImageCard(media, 0),
                                          onTap: () => pickImage()),
                                      GestureDetector(
                                          child: pickImageCard(media, 1),
                                          onTap: () => pickImage()),
                                      GestureDetector(
                                          child: pickImageCard(media, 2),
                                          onTap: () => pickImage()),
                                    ]),
                                const SizedBox(height: 5),
                              ]),
                            ))),
                  )),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.blue,
                        shape: const StadiumBorder()),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.white))),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    onPressed: () {
                      if (!loading) {
                        if (ctrlName.text.isEmpty) {
                          MotionToast.error(
                                  title: const Text("Opps"),
                                  description: const Text(
                                      '¡Los campos con (*) son obligatorios!'))
                              .show(context);
                        } else {
                          if (fileBytesList.isEmpty) {
                            MotionToast.error(
                                    title: const Text("Opps"),
                                    description: const Text(
                                        '¡Debe al menos elegir una imagen!'))
                                .show(context);
                          } else {
                            authBloc.setIsLoading(true);
                            catalogueBloc
                                .createCatalogueDetail(
                                    ctrlName.text,
                                    ctrlDescription.text,
                                    ctrlPrice.text,
                                    fileBytesList,
                                    kIsWeb,
                                    widget.catalogue['uid'])
                                .then((value) {
                              authBloc.setIsLoading(false);
                              Navigator.pop(context);
                            });
                          }
                        }
                      }
                    },
                    label:
                        Text("Agregar", style: TextStyle(color: Colors.blue)),
                    icon: loading
                        ? Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.only(left: 5),
                            child: CircularProgressIndicator(
                                strokeWidth: 0.8,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue)))
                        : Container()),
              ]);
        });
  }

  pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['jpeg', 'jpg', 'png'], type: FileType.custom);
    if (result != null) {
      if (kIsWeb) {
        setState(() {
          fileBytesList.add({
            'fileByte': result.files.first.bytes!,
            'fileName': result.files.first.name
          });
        });
      } else {
        setState(() {
          fileBytesList.add({
            'fileByte': File(result.files.first.path!),
            'fileName': result.files.first.name
          });
        });
      }
    }
  }

  Widget pickImageCard(Size media, index) {
    return Container(
        width: (media.width > 800) ? 110 : 65,
        height: (media.width > 800) ? 110 : 65,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey.shade200),
        child: (fileBytesList.length < (index + 1))
            ? Icon(Icons.image)
            : (kIsWeb)
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                        placeholder: AssetImage('assets/shopping-loader.gif'),
                        image: MemoryImage(fileBytesList[index]['fileByte']),
                        fit: BoxFit.contain))
                : ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: FadeInImage(
                        placeholder: AssetImage('assets/shopping-loader.gif'),
                        image: FileImage(fileBytesList[index]['fileByte']),
                        fit: BoxFit.contain)));
  }
}
