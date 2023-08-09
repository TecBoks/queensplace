import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/loyalty_points/repository/loyalty_points_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:intl/intl.dart';

class LoyaltyPointsAddPointsModal extends StatefulWidget {
  final dynamic userAuth;
  final Function refreshUser;
  LoyaltyPointsAddPointsModal(
      {Key? key, required this.refreshUser, required this.userAuth})
      : super(key: key);

  @override
  State<LoyaltyPointsAddPointsModal> createState() =>
      _LoyaltyPointsAddPointsModalState();
}

class _LoyaltyPointsAddPointsModalState
    extends State<LoyaltyPointsAddPointsModal> {
  TextEditingController ctrlPoints = TextEditingController(text: '0');
  TextEditingController ctrlComment = TextEditingController(text: '');
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
              title: const Text('Añadir Puntos:'),
              content: SizedBox(
                  width: (media.width > 800)
                      ? MediaQuery.of(context).size.width / 3
                      : MediaQuery.of(context).size.width / 1,
                  height: 340,
                  child: Column(children: [
                    const SizedBox(height: 5),
                    TextField(
                        controller: ctrlPoints,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                        ],
                        onChanged: ((value) => setState(() {})),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0)),
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            labelText: '* Ingresar los puntos:',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(7.0),
                            ))),
                    const SizedBox(height: 10),
                    TextField(
                        controller: ctrlComment,
                        maxLines: 2,
                        keyboardType: TextInputType.text,
                        onChanged: ((value) => setState(() {})),
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(7.0)),
                            labelStyle: TextStyle(color: Colors.grey[700]),
                            labelText: '* Comentario:',
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 1.0),
                              borderRadius: BorderRadius.circular(7.0),
                            ))),
                  ])),
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
                        if (ctrlPoints.text.isEmpty ||
                            double.parse(ctrlPoints.text) == 0) {
                          MotionToast.info(
                                  title: const Text("Opps"),
                                  description: const Text(
                                      '¡Ingrese la cantidad de puntos que quiere añadir!'))
                              .show(context);
                        } else {
                          var newUser = widget.userAuth;
                          newUser["accumulatedPoints"] =
                              widget.userAuth['accumulatedPoints'] +
                                  double.parse(ctrlPoints.text);
                          var date = DateTime.now();
                          String dateSort =
                              DateFormat('yyyyMMddHHmm').format(date);
                          var sort = int.parse(dateSort);
                          loyaltyPointsBloc
                              .addAcumulativePoints(
                                  ctrlComment.text,
                                  double.parse(ctrlPoints.text),
                                  date.year,
                                  date.month,
                                  date.day,
                                  date.hour,
                                  date.minute,
                                  sort,
                                  newUser)
                              .then((value) {
                            widget.refreshUser();
                            Navigator.pop(context);
                          });
                        }
                      }
                    },
                    label: const Text('Añadir',
                        style: TextStyle(color: Colors.blue)),
                    icon: loading
                        ? Container(
                            width: 10,
                            height: 10,
                            margin: EdgeInsets.only(left: 5),
                            child: CircularProgressIndicator(
                                strokeWidth: 0.8,
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    Colors.blue)))
                        : Container())
              ]);
        });
  }
}
