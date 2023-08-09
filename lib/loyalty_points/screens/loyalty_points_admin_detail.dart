import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/clients/screens/clients_acumulative_points.dart';
import 'package:bequeen/clients/screens/clients_redeemed_historic.dart';
import 'package:bequeen/loyalty_points/repository/loyalty_points_bloc.dart';
import 'package:bequeen/loyalty_points/widgets/loyalty_point_add_points_modal.dart';
import 'package:bequeen/loyalty_points/widgets/loyalty_points_redeem_modal.dart';
import 'package:flutter/material.dart';

class LoyaltyPointsAdminDetail extends StatefulWidget {
  final dynamic client;
  LoyaltyPointsAdminDetail({Key? key, required this.client}) : super(key: key);

  @override
  State<LoyaltyPointsAdminDetail> createState() =>
      _LoyaltyPointsAdminDetailState();
}

class _LoyaltyPointsAdminDetailState extends State<LoyaltyPointsAdminDetail> {
  ScrollController scrollController = ScrollController();
  var userAuth = {};
  bool loading = false;
  var date = DateTime.now();

  @override
  void initState() {
    userAuth = widget.client;
    userAuth["accumulatedPoints"] = (userAuth['accumulatedPoints'] == null)
        ? 0
        : userAuth['accumulatedPoints'];
    userAuth["redeemedPoints"] =
        (userAuth['redeemedPoints'] == null) ? 0 : userAuth['redeemedPoints'];
    authBloc.setIsLoading(false);
    String month = (date.month > 9) ? "${date.month}" : "0${date.month}";
    String day = (date.day > 9) ? "${date.day}" : "0${date.day}";
    String hour = (date.hour > 9) ? "${date.hour}" : "0${date.hour}";
    String minutes = (date.minute > 9) ? "${date.minute}" : "0${date.minute}";
    Future.delayed(const Duration(milliseconds: 0), () {
      loyaltyPointsBloc.getTempPoints(userAuth["uid"]).then((value) {
        if (value.isNotEmpty) {
          for (var element in value) {
            if (int.parse("${date.year}$month$day$hour$minutes") >
                element["endDate"]) {
              var newUser = userAuth;
              newUser["accumulatedPoints"] =
                  newUser["accumulatedPoints"] + element["points"];
              loyaltyPointsBloc.updateDataUser(element["uid"], newUser);
            }
          }
          refreshUser();
        }
      });
    });
    super.initState();
  }

  refreshUser() {
    loyaltyPointsBloc.getDataUser(userAuth["uid"]).then((value) {
      setState(() {
        userAuth = value.data() as Map;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar:
            AppBar(title: Row(children: [Text("${widget.client["name"]}")])),
        body: Scrollbar(
            thumbVisibility: true,
            controller: scrollController,
            child: Builder(
                builder: (context) => SingleChildScrollView(
                    controller: scrollController,
                    child: _container(context, media)))));
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
                      child: Text('Puntos de Lealtad',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                          textAlign: TextAlign.center))
                ])),
            const SizedBox(height: 10),
            Center(
                child: Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: const Text(
                        "Nota: Los puntos de la cita se agregan automaticamente, ya para las otras areas Por Eje. el consumo en Cafetería si se debe agregar manualmente mediante el boton Añadir Puntos.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)))),
            const SizedBox(height: 10),
            const Center(
                child: Text("L 1.00 = 1 PL = ¡Descuentos!",
                    style: TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(height: 10),
            (media.width > 800)
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Card(
                        color: Colors.red,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(children: [
                              const Text("Puntos Acumulados",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 10),
                              Text("${userAuth["accumulatedPoints"]}",
                                  style: const TextStyle(color: Colors.white)),
                            ]))),
                    Card(
                        color: Colors.blue,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(children: [
                              const Text("Puntos Canjeados",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 10),
                              Text("${userAuth["redeemedPoints"]}",
                                  style: const TextStyle(color: Colors.white)),
                            ]))),
                    Card(
                        color: Colors.green,
                        child: Container(
                            padding: const EdgeInsets.all(10),
                            child: Column(children: [
                              const Text("Puntos Disponibles",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 10),
                              Text(
                                  "${userAuth["accumulatedPoints"] - userAuth["redeemedPoints"]}",
                                  style: const TextStyle(color: Colors.white)),
                            ]))),
                  ])
                : Container(
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Card(
                              color: Colors.red,
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(children: [
                                    const Text("Puntos Acumulados",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    Text("${userAuth["accumulatedPoints"]}",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ]))),
                          Card(
                              color: Colors.blue,
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(children: [
                                    const Text("Puntos Canjeados",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    Text("${userAuth["redeemedPoints"]}",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ]))),
                          Card(
                              color: Colors.green,
                              child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(children: [
                                    const Text("Puntos Disponibles",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                    const SizedBox(height: 10),
                                    Text(
                                        "${userAuth["accumulatedPoints"] - userAuth["redeemedPoints"]}",
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ]))),
                        ])),
            const SizedBox(height: 40),
            InputChip(
                backgroundColor: Colors.grey.shade200,
                onPressed: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => LoyaltyPointsRedeemedHistoric(
                  //             userAuth: userAuth)));
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClientsRedeemedHistoric(
                              clientUid: userAuth['uid'])));
                },
                elevation: 2,
                label: const Text('Historial Puntos Canjeados',
                    style: TextStyle(color: Colors.black))),
            InputChip(
                backgroundColor: Colors.white,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ClientsAcumulativePoints(
                              clientUid: userAuth['uid'])));
                },
                elevation: 2,
                label: const Text('Historial Puntos Acumulados',
                    style: TextStyle(color: Colors.red))),
            const SizedBox(height: 40),
            Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                constraints: const BoxConstraints(maxWidth: 600),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.black87,
                        shape: const StadiumBorder()),
                    onPressed: () => _buildAddDialog(context,
                        "${userAuth["accumulatedPoints"] - userAuth["redeemedPoints"]}"),
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                          child: Text('Canjear Puntos',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17))),
                    ))),
            const SizedBox(height: 10),
            Container(
                margin: const EdgeInsets.only(left: 10, right: 10),
                constraints: const BoxConstraints(maxWidth: 600),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.green,
                        shape: const StadiumBorder()),
                    onPressed: () => _buildAddPointsDialog(context),
                    child: const SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: Center(
                          child: Text('Añadir Puntos',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17))),
                    ))),
          ]),
        ));
  }

  Future _buildAddDialog(BuildContext context, String availablePoints) {
    return showDialog(
        context: context,
        builder: (context) {
          return LoyaltyPointsRedeemModal(
              userAuth: userAuth,
              availablePoints: availablePoints,
              refreshUser: refreshUser);
        });
  }

  Future _buildAddPointsDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return LoyaltyPointsAddPointsModal(
              userAuth: userAuth, refreshUser: refreshUser);
        });
  }
}
