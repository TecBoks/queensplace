import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/home/repository/home_bloc.dart';
import 'package:bequeen/home/widgets/home_add_appointment_modal.dart';
import 'package:bequeen/home/widgets/home_appo_color_card.dart';
import 'package:bequeen/profile/screens/profile_home.dart';
import 'package:bequeen/utils/side_menu.dart';
import 'package:bequeen/utils/side_menu_responsive.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ScrollController scrollController = ScrollController();
  var userAuth = {};
  final storage = Hive.box("queensPlaceTecBoks");
  TextEditingController ctrlDate = TextEditingController(text: '');
  List<dynamic> timeline = [];
  List<dynamic> workers = [];
  bool loading = false;
  var date = DateTime.now();
  List<PopupMenuItem<dynamic>> popupMenuItems = [
    const PopupMenuItem(
        value: {"name": "Todos Los Colaboradores"},
        child: Text("Todos Los Colaboradores"))
  ];
  dynamic initialValue = {"name": "Todos Los Colaboradores"};
  dynamic filter = {"name": "Todos Los Colaboradores"};

  @override
  void initState() {
    userAuth = (storage.get('userAuth') == null) ? {} : storage.get('userAuth');
    print(userAuth);
    authBloc.setIsLoading(false);
    ctrlDate =
        TextEditingController(text: DateFormat('yyyy-MM-dd').format(date));
    setSchedule(date);
    Future.delayed(const Duration(milliseconds: 0), () {
      if (userAuth['email'] == 'queenplacesps@gmail.com') {
        homeBloc.getWorkers().then((value) {
          setState(() {
            workers = value;
            if (value.isNotEmpty) {
              for (var element in value) {
                popupMenuItems.add(PopupMenuItem(
                    value: element, child: Text(element["name"])));
              }
            }
          });
        });
      }
    });
    super.initState();
  }

  setSchedule(DateTime value) {
    var day = DateFormat("E").format(value);
    if (day == 'Sun') {
      setState(() {
        date = value;
        timeline = [
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
        ];
      });
    } else if (day == "Thu" || day == "Fri" || day == "Sat") {
      setState(() {
        date = value;
        timeline = [
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
      });
    } else {
      setState(() {
        date = value;
        timeline = [
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
        ];
      });
    }
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
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                    width: (media.width > 800)
                        ? MediaQuery.of(context).size.width / 1.6
                        : MediaQuery.of(context).size.width / 1.4,
                    margin: const EdgeInsets.only(top: 5, left: 10),
                    padding: const EdgeInsets.only(
                        top: 3, left: 5, bottom: 3, right: 20),
                    decoration: BoxDecoration(
                        color: Colors.white60,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(width: 1, color: Colors.grey),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              offset: const Offset(0, 4),
                              blurRadius: 4),
                        ]),
                    child: DateTimeField(
                        controller: ctrlDate,
                        resetIcon: const Icon(Icons.close),
                        decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.date_range),
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                            hintText: '* Fechas disponibles:'),
                        format: DateFormat("yyyy-MM-dd"),
                        onChanged: (value) {
                          var dateNow = DateTime.now();
                          var date = DateTime(
                              value!.year,
                              value.month,
                              value.day,
                              dateNow.hour,
                              dateNow.minute,
                              dateNow.second);
                          setSchedule(date);
                        },
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              locale: const Locale('es'),
                              firstDate: DateTime.now(),
                              initialDate: DateTime.now(),
                              lastDate: DateTime(2123));
                        })),
                const SizedBox(width: 10),
                (userAuth['email'] == 'queenplacesps@gmail.com')
                    ? PopupMenuButton(
                        initialValue: initialValue,
                        child: const Center(
                            child: Icon(Icons.filter_list_rounded)),
                        onSelected: (dynamic value) {
                          setState(() {
                            filter = value;
                          });
                        },
                        itemBuilder: (context) {
                          return popupMenuItems;
                        })
                    : Container()
              ]),
              const SizedBox(height: 15),
              StreamBuilder(
                  stream: homeBloc.getGlobalAppointments(
                      date.year, date.month, date.day),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    var appo = [];
                    if (snapshot.hasData) {
                      int lengthAppo = snapshot.data.docs.length;
                      appo = listAppo(snapshot.data.docs);
                      if (timeline.isEmpty) {
                        return const Center(
                            child: Text("Cerrado",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)));
                      } else {
                        return SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: _buildListTimeList(
                                timeline, appo, lengthAppo, context, media));
                      }
                    } else {
                      if (timeline.isEmpty) {
                        return const Center(
                            child: Text("Cerrado",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)));
                      } else {
                        return SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            child: Center(
                                child: _buildListTimeList(
                                    timeline, appo, 0, context, media)));
                      }
                    }
                  }),
            ])));
  }

  listAppo(appo) {
    List<dynamic> newAppo = [];
    if (appo.length > 0) {
      for (var item in appo) {
        if (filter["name"] == "Todos Los Colaboradores") {
          newAppo.add(item.data());
        } else if (item.data()["workerUid"] == filter["uid"]) {
          newAppo.add(item.data());
        }
      }
    }
    newAppo.sort((a, b) => a["colorCard"].compareTo(b["colorCard"]));
    return newAppo;
  }

  Widget _buildListTimeList(List<dynamic> timeList, List<dynamic> appo,
      int lengthAppo, context, Size media) {
    return ListView.builder(
        itemCount: timeList.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1, color: Colors.grey.shade300))),
                  child: timeListCards(timeList, timeList[index], index,
                      listAppoFilter(appo, index), context, media, lengthAppo)),
              onTap: () {});
        });
  }

  listAppoFilter(appo, index) {
    List<dynamic> newAppo = [];
    if (appo.length > 0) {
      for (var item in appo) {
        var duration = item['serviceDuration'] / 15;
        if ((duration + item["timeIndex"]) > index) {
          if (index >= item["timeIndex"]) {
            newAppo.add(item);
          }
        }
      }
    }
    return newAppo;
  }

  Widget timeListCards(List timeList, time, int index, List appo, context,
      Size media, int globalAppoLength) {
    return TimelineTile(
        axis: TimelineAxis.vertical,
        isFirst: (index == 0) ? true : false,
        isLast: ((index + 1) == timeList.length) ? true : false,
        indicatorStyle: IndicatorStyle(
            width: 25,
            color: Colors.black,
            padding: const EdgeInsets.all(2),
            iconStyle: IconStyle(color: Colors.white, iconData: Icons.circle)),
        alignment: TimelineAlign.manual,
        lineXY: (media.width > 800) ? 0.08 : 0.17,
        endChild: Row(children: [
          Expanded(
              child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  child: (appo.isEmpty)
                      ? Container()
                      : SizedBox(
                          width: 300,
                          height: (media.width > 800)
                              ? 105 * double.parse("${appo.length}")
                              : 155 * double.parse("${appo.length}"),
                          child: ListView.builder(
                              itemCount: appo.length,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder:
                                  (BuildContext context, int indexAppo) {
                                return GestureDetector(
                                    child: Container(
                                        padding: const EdgeInsets.all(5),
                                        margin: const EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: homeAppoColorCard(
                                                appo[indexAppo]["colorCard"])),
                                        child: Row(children: [
                                          Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                Text(
                                                    "Servicio: ${appo[indexAppo]["serviceName"]}",
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                                Text(
                                                    "Atención: ${appo[indexAppo]["workerName"]}",
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                                Text(
                                                    "Cliente: ${appo[indexAppo]["clientName"]}",
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                                Text(
                                                    'Duración: ${appo[indexAppo]['serviceDurationHour']} hora(s) ${appo[indexAppo]['serviceDurationMinutes']} minutos',
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                              ])),
                                          const SizedBox(width: 10),
                                          (userAuth['email'] ==
                                                  'queenplacesps@gmail.com')
                                              ? GestureDetector(
                                                  child: Container(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      decoration:
                                                          const BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  Colors.white),
                                                      child: const Icon(
                                                          Icons.delete,
                                                          color: Colors.red)),
                                                  onTap: () => deleteAppo(
                                                      context, appo[indexAppo]))
                                              : Container()
                                        ])),
                                    onTap: () {});
                              }),
                        ))),
          (userAuth['email'] != 'queenplacesps@gmail.com')
              ? Container()
              : (date.isAfter(DateTime.now()))
                  ? GestureDetector(
                      child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey.shade800),
                          child: const Icon(Icons.add, color: Colors.white)),
                      onTap: () {
                        _buildAddDialog(context, date, index, time,
                            int.parse(time["hour"]), globalAppoLength + 1);
                      })
                  : (int.parse(time["hour"]) >= date.hour)
                      ? GestureDetector(
                          child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey.shade800),
                              child:
                                  const Icon(Icons.add, color: Colors.white)),
                          onTap: () {
                            _buildAddDialog(context, date, index, time,
                                int.parse(time["hour"]), globalAppoLength + 1);
                          })
                      : Container()
        ]),
        startChild: Text("${time["hour"]}:${time["minutes"]} - ${time["to"]}"));
  }

  deleteAppo(context, appo) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text("¡Advertencia!"),
              content: Text(
                  "¿Seguro que quieres eliminar la cita del cliente ${appo["clientName"]} a las ${appo["year"]}/${appo["month"]}/${appo["day"]} ${timeline[appo["timeIndex"]]["hour"]}:${timeline[appo["timeIndex"]]["minutes"]}?"),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.blue,
                        shape: const StadiumBorder()),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar',
                        style: TextStyle(color: Colors.white))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    onPressed: () {
                      if (appo["workerToken"].isEmpty) {
                        if (appo["clientToken"].isEmpty) {
                          homeBloc.deleteAppoinment(appo['uid']);
                        } else {
                          homeBloc
                              .sendPushNotification(
                                  appo["clientToken"],
                                  "Cita Cancelada ${appo["datePush"]}",
                                  "Servicio: ${appo["serviceName"]}, Atención: ${appo["workerName"]}")
                              .then((value) {
                            homeBloc.deleteAppoinment(appo['uid']);
                          });
                        }
                      } else {
                        homeBloc
                            .sendPushNotification(
                                appo["workerToken"],
                                "Cita Cancelada ${appo["datePush"]}",
                                "Servicio: ${appo["serviceName"]}, Cliente: ${appo["clientName"]}")
                            .then((value) {
                          if (appo["clientToken"].isEmpty) {
                            homeBloc.deleteAppoinment(appo['uid']);
                          } else {
                            homeBloc
                                .sendPushNotification(
                                    appo["clientToken"],
                                    "Cita Cancelada ${appo["datePush"]}",
                                    "Servicio: ${appo["serviceName"]}, Atención: ${appo["workerName"]}")
                                .then((value) {
                              homeBloc.deleteAppoinment(appo['uid']);
                            });
                          }
                        });
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Eliminar',
                        style: TextStyle(color: Colors.blue)))
              ]);
        });
  }

  Future _buildAddDialog(BuildContext context, DateTime dateTime, int timeIndex,
      dynamic timeValue, int timeIndexHour, int indexColorCard) {
    return showDialog(
        context: context,
        builder: (context) {
          return HomeAddAppointmentModal(
              dateTime: dateTime,
              timeIndex: timeIndex,
              timeIndexHour: timeIndexHour,
              timeValue: timeValue,
              workers: workers,
              indexColorCard: indexColorCard);
        });
  }
}
