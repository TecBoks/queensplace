import 'dart:io';
import 'dart:typed_data';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/catalogue/repository/catalogue_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class CatalogueAddModal extends StatefulWidget {
  CatalogueAddModal({Key? key}) : super(key: key);

  @override
  State<CatalogueAddModal> createState() => _CatalogueAddModalState();
}

class _CatalogueAddModalState extends State<CatalogueAddModal> {
  ScrollController scrollController = ScrollController();
  TextEditingController ctrlName = TextEditingController(text: '');
  TextEditingController ctrlDescription = TextEditingController(text: '');
  late Uint8List fileBytes;
  late File fileMovil;
  String fileName = "";
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
              title: const Text('Agregar un nuevo catálogo:'),
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
                                        labelText: '* Descripción:',
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black, width: 1.0),
                                          borderRadius:
                                              BorderRadius.circular(7.0),
                                        ))),
                                SizedBox(height: 10),
                                (fileName == '')
                                    ? Container()
                                    : Container(child: Text(fileName)),
                                SizedBox(height: 10),
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        elevation: 2,
                                        backgroundColor: Colors.white,
                                        shape: StadiumBorder()),
                                    onPressed: () async {
                                      FilePickerResult? result =
                                          await FilePicker.platform.pickFiles(
                                              allowedExtensions: [
                                            'jpeg',
                                            'jpg',
                                            'png'
                                          ],
                                              type: FileType.custom);
                                      if (result != null) {
                                        if (kIsWeb) {
                                          setState(() {
                                            fileBytes =
                                                result.files.first.bytes!;
                                            fileName = result.files.first.name;
                                          });
                                        } else {
                                          setState(() {
                                            fileMovil =
                                                File(result.files.first.path!);
                                            fileName = result.files.first.name;
                                          });
                                        }
                                      }
                                    },
                                    child: Text('Adjuntar Imagen',
                                        style:
                                            TextStyle(color: Colors.black87))),
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
                        if (ctrlName.text.isEmpty ||
                            ctrlDescription.text.isEmpty) {
                          MotionToast.error(
                                  title: const Text("Opps"),
                                  description: const Text(
                                      '¡Los campos con (*) son obligatorios!'))
                              .show(context);
                        } else {
                          if (kIsWeb) {
                            authBloc.setIsLoading(true);
                            catalogueBloc
                                .createCatalogueWeb(ctrlName.text,
                                    ctrlDescription.text, fileBytes, fileName)
                                .then((value) {
                              authBloc.setIsLoading(false);
                              Navigator.pop(context);
                            });
                          } else {
                            authBloc.setIsLoading(true);
                            catalogueBloc
                                .createCatalogueMovil(ctrlName.text,
                                    ctrlDescription.text, fileMovil, fileName)
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
}
