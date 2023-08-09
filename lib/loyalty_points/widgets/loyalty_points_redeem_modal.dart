import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bequeen/loyalty_points/repository/loyalty_points_bloc.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

class LoyaltyPointsRedeemModal extends StatefulWidget {
  final dynamic userAuth;
  final String availablePoints;
  final Function refreshUser;
  const LoyaltyPointsRedeemModal(
      {Key? key,
      required this.userAuth,
      required this.availablePoints,
      required this.refreshUser})
      : super(key: key);

  @override
  State<LoyaltyPointsRedeemModal> createState() =>
      _LoyaltyPointsRedeemModalState();
}

class _LoyaltyPointsRedeemModalState extends State<LoyaltyPointsRedeemModal> {
  TextEditingController ctrlPoints = TextEditingController(text: '0');
  TextEditingController ctrlComment = TextEditingController(text: '');
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    double totalMoney =
        (ctrlPoints.text.isEmpty) ? 0 : double.parse(ctrlPoints.text) * 0.05;
    Size media = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: authBloc.loadingStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          loading = snapshot.data ?? false;
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text('Canjear Puntos:'),
              content: SizedBox(
                  width: (media.width > 800)
                      ? MediaQuery.of(context).size.width / 3
                      : MediaQuery.of(context).size.width / 1,
                  height: 360,
                  child: Column(children: [
                    const SizedBox(height: 5),
                    Center(
                        child: Text(
                            "Puntos Disponibles: ${widget.availablePoints}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold))),
                    const SizedBox(height: 10),
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
                    Center(
                        child: Text(
                            "Tus Puntos equivalen a: L ${totalMoney.toStringAsFixed(2)}")),
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
                    const SizedBox(height: 5),
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
                                      '¡Ingrese la cantidad de puntos que quiere canjear!'))
                              .show(context);
                        } else if (double.parse(ctrlPoints.text) >
                            double.parse(widget.availablePoints)) {
                          MotionToast.info(
                                  title: const Text("Opps"),
                                  description: const Text(
                                      '¡La cantidad de puntos debe ser menor o igual a los puntos disponibles!'))
                              .show(context);
                        } else {
                          var newUser = widget.userAuth;
                          var date = DateTime.now();
                          String dateSort =
                              DateFormat('yyyyMMddHHmm').format(date);
                          String dateCorrelative =
                              DateFormat('yyMMddHHmmss').format(date);
                          var sort = int.parse(dateSort);
                          newUser["redeemedPoints"] =
                              double.parse("${newUser["redeemedPoints"]}") +
                                  double.parse(ctrlPoints.text);
                          loyaltyPointsBloc
                              .redeemPoints(
                                  ctrlComment.text,
                                  dateCorrelative,
                                  double.parse(ctrlPoints.text),
                                  totalMoney,
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
                    label: const Text('Canjear',
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
