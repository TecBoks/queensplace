import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/loyalty_points/repository/loyalty_points_bloc.dart';
import 'package:bequeen/loyalty_points/screens/loyalty_points_redeemed_historic.dart';
import 'package:bequeen/loyalty_points/widgets/loyalty_points_redeem_modal.dart';
import 'package:bequeen/profile/screens/profile_home.dart';
import 'package:bequeen/utils/side_menu.dart';
import 'package:bequeen/utils/side_menu_responsive.dart';

class LoyaltyPointsHome extends StatefulWidget {
  const LoyaltyPointsHome({Key? key}) : super(key: key);

  @override
  State<LoyaltyPointsHome> createState() => _LoyaltyPointsHomeState();
}

class _LoyaltyPointsHomeState extends State<LoyaltyPointsHome> {
  ScrollController scrollController = ScrollController();
  var userAuth = {};
  final storage = Hive.box("queensPlaceTecBoks");
  bool loading = false;
  var date = DateTime.now();

  @override
  void initState() {
    userAuth = (storage.get('userAuth') == null)
        ? {}
        : Map.from(storage.get('userAuth'));
    userAuth["accumulatedPoints"] = (userAuth['accumulatedPoints'] == null)
        ? 0
        : userAuth['accumulatedPoints'];
    userAuth["redeemedPoints"] = (userAuth['redeemedPoints'] == null)
        ? 0
        : userAuth['redeemedPoints'];
    authBloc.setIsLoading(false);
    // String month = (date.month > 9) ? "${date.month}" : "0${date.month}";
    // String day = (date.day > 9) ? "${date.day}" : "0${date.day}";
    // String hour = (date.hour > 9) ? "${date.hour}" : "0${date.hour}";
    // String minutes = (date.minute > 9) ? "${date.minute}" : "0${date.minute}";
    // Future.delayed(const Duration(milliseconds: 0), () {
    //   loyaltyPointsBloc.getTempPoints(userAuth["uid"]).then((value) {
    //     if (value.isNotEmpty) {
    //       for (var element in value) {
    //         if (int.parse("${date.year}$month$day$hour$minutes") >
    //             element["endDate"]) {
    //           var newUser = userAuth;
    //           newUser["accumulatedPoints"] =
    //               newUser["accumulatedPoints"] + element["points"];
    //           loyaltyPointsBloc.updateDataUser(element["uid"], newUser);
    //         }
    //       }
    //       refreshUser();
    //     }
    //   });
    // });
    super.initState();
  }

  refreshUser() {
    loyaltyPointsBloc.getDataUser(userAuth["uid"]).then((value) {
      storage.put('userAuth', value.data());
      setState(() {
        userAuth =
            (storage.get('userAuth') == null) ? {} : storage.get('userAuth');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Scaffold(
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
                        "Disfruta de los beneficios de ser parte de nosotros. ¡Un programa que premia tu fidelidad!",
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
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            LoyaltyPointsRedeemedHistoric(userAuth: userAuth))),
                elevation: 2,
                label: const Text('Historial Puntos Canjeados',
                    style: TextStyle(color: Colors.black))),
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
}
