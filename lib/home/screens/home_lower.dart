import 'package:flutter/material.dart';
import 'package:hovering/hovering.dart';
import 'package:bequeen/home/repository/home_bloc.dart';
import 'package:bequeen/profile/screens/profile_home.dart';
import 'package:bequeen/utils/side_menu.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bequeen/utils/side_menu_responsive.dart';
import 'package:bequeen/utils/skeleton_loader.dart';

class HomeLower extends StatefulWidget {
  const HomeLower({Key? key}) : super(key: key);

  @override
  State<HomeLower> createState() => _HomeLowerState();
}

class _HomeLowerState extends State<HomeLower> {
  ScrollController scrollController = ScrollController();
  int limit = 20;
  var userAuth = {};
  final storage = Hive.box("queensPlaceTecBoks");
  bool loading = false;
  List<dynamic> timeline = [
    {"hour": "8", "minutes": "00", "to": "8:15"},
    {"hour": "8", "minutes": "15", "to": "8:30"},
    {"hour": "8", "minutes": "30", "to": "8:45"},
    {"hour": "8", "minutes": "45", "to": "9:00"},
    {"hour": "9", "minutes": "00", "to": "9:15"},
    {"hour": "9", "minutes": "15", "to": "9:30"},
    {"hour": "9", "minutes": "30", "to": "9:45"},
    {"hour": "9", "minutes": "45", "to": "10:00"},
    {"hour": "10", "minutes": "00", "to": "10:15"},
    {"hour": "10", "minutes": "15", "to": "10:30"},
    {"hour": "10", "minutes": "30", "to": "10:45"},
    {"hour": "10", "minutes": "45", "to": "11:00"},
    {"hour": "11", "minutes": "00", "to": "11:15"},
    {"hour": "11", "minutes": "15", "to": "11:30"},
    {"hour": "11", "minutes": "30", "to": "11:45"},
    {"hour": "11", "minutes": "45", "to": "12:00"},
    {"hour": "12", "minutes": "00", "to": "12:15"},
    {"hour": "12", "minutes": "15", "to": "12:30"},
    {"hour": "12", "minutes": "30", "to": "12:45"},
    {"hour": "12", "minutes": "45", "to": "13:00"},
    {"hour": "13", "minutes": "00", "to": "13:15"},
    {"hour": "13", "minutes": "15", "to": "13:30"},
    {"hour": "13", "minutes": "30", "to": "13:45"},
    {"hour": "13", "minutes": "45", "to": "14:00"},
    {"hour": "14", "minutes": "00", "to": "14:15"},
    {"hour": "14", "minutes": "15", "to": "14:30"},
    {"hour": "14", "minutes": "30", "to": "14:45"},
    {"hour": "14", "minutes": "45", "to": "15:00"},
    {"hour": "15", "minutes": "00", "to": "15:15"},
    {"hour": "15", "minutes": "15", "to": "15:30"},
    {"hour": "15", "minutes": "30", "to": "15:45"},
    {"hour": "15", "minutes": "45", "to": "16:00"},
    {"hour": "16", "minutes": "00", "to": "16:15"},
    {"hour": "16", "minutes": "15", "to": "16:30"},
    {"hour": "16", "minutes": "30", "to": "16:45"},
    {"hour": "16", "minutes": "45", "to": "17:00"},
    {"hour": "17", "minutes": "00", "to": "17:15"},
    {"hour": "17", "minutes": "15", "to": "17:30"},
    {"hour": "17", "minutes": "30", "to": "17:45"},
    {"hour": "17", "minutes": "45", "to": "18:00"},
    {"hour": "18", "minutes": "00", "to": "18:15"},
    {"hour": "18", "minutes": "15", "to": "18:30"},
    {"hour": "18", "minutes": "30", "to": "18:45"},
    {"hour": "18", "minutes": "45", "to": "19:00"},
  ];

  @override
  void initState() {
    userAuth = (storage.get('userAuth') == null) ? {} : storage.get('userAuth');
    print(userAuth);
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
                      child: _container(context)))),
          (media.width > 800)
              ? HoverWidget(
                  hoverChild: SideMenu(size: 200, userAuth: userAuth),
                  child: SideMenu(size: 60, userAuth: userAuth),
                  onHover: (value) {})
              : Container(),
        ]));
  }

  Widget _container(context) {
    Size media = MediaQuery.of(context).size;
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
                        child: Text('Citas',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                            textAlign: TextAlign.center))
                  ])),
              const SizedBox(height: 10),
              StreamBuilder(
                  stream: homeBloc.getAppointmentsClientWorker(
                      userAuth["uid"], limit, userAuth["type"]),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List appo = snapshot.data.docs;
                      if (appo.isEmpty) {
                        return const Center(
                            child: Text('¡Aún no existe ninguna cita!'));
                      } else {
                        return Container(
                            padding: const EdgeInsets.all(10),
                            width: (media.width > 800)
                                ? MediaQuery.of(context).size.width / 1.1
                                : MediaQuery.of(context).size.width,
                            child: _buildListAppo(listAppo(appo), context));
                      }
                    } else {
                      return const SkeletonLoader();
                    }
                  })
            ])));
  }

  listAppo(appo) {
    List<dynamic> newAppo = [];
    if (appo.length > 0) {
      for (var item in appo) {
        newAppo.add(item.data());
      }
    }
    // newAppo.sort((a, b) => a["sort"].compareTo(b["sort"]));
    return newAppo;
  }

  Widget _buildListAppo(List<dynamic> appo, context) {
    return ListView.builder(
        itemCount: appo.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: _appoCard(appo[index], context),
              onTap: () {
                // print(companies[index]);
              });
        });
  }

  Widget _appoCard(appo, context) {
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
        child: Row(children: [
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Text("Servicio: ${appo["serviceName"]}"),
                Text("Atención: ${appo["workerName"]}"),
                Text("Cliente: ${appo["clientName"]}"),
                Text(
                    "Fecha: ${appo["year"]}/${appo["month"]}/${appo["day"]} ${timeline[appo["timeIndex"]]["hour"]}:${timeline[appo["timeIndex"]]["minutes"]}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                    'Duración: ${appo['serviceDurationHour']} hora(s) ${appo['serviceDurationMinutes']} minutos'),
              ])),
          const SizedBox(width: 15),
        ]));
  }
}
