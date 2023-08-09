import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/home/repository/home_bloc.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

class HomeAddAppointmentModal extends StatefulWidget {
  final DateTime dateTime;
  final int timeIndex;
  final int timeIndexHour;
  final dynamic timeValue;
  final List<dynamic> workers;
  final int indexColorCard;
  const HomeAddAppointmentModal({
    Key? key,
    required this.dateTime,
    required this.workers,
    required this.timeIndex,
    required this.timeIndexHour,
    required this.timeValue,
    required this.indexColorCard,
  }) : super(key: key);

  @override
  State<HomeAddAppointmentModal> createState() =>
      _HomeAddAppointmentModalState();
}

class _HomeAddAppointmentModalState extends State<HomeAddAppointmentModal> {
  ScrollController scrollController = ScrollController();
  List<dynamic> services = [];
  List<dynamic> clients = [];
  List<dynamic> workersSelected = [];
  Map<String, dynamic> serviceMap = {};
  Map<String, dynamic> workerMap = {};
  Map<String, dynamic> clientMap = {};

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      homeBloc.getServices().then((value) {
        homeBloc.getClients().then((value2) {
          setState(() {
            services = value;
            clients = value2;
          });
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    String date = DateFormat('yyyy-MM-dd').format(widget.dateTime);
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Agregar una nueva cita:'),
        content: SizedBox(
            width: (media.width > 800)
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width / 1,
            height: 420,
            child: Scrollbar(
                thumbVisibility: true,
                controller: scrollController,
                child: Builder(
                  builder: (context) => SingleChildScrollView(
                      controller: scrollController,
                      child: Column(children: [
                        Text(
                            "Fecha: $date ${widget.timeValue["hour"]}:${widget.timeValue["minutes"]}"),
                        const SizedBox(height: 20),
                        const Center(child: Text("* Servicios")),
                        DropdownSearch<dynamic>(
                            items: services,
                            itemAsString: (item) => "${item['name']}",
                            popupProps: PopupProps.dialog(
                                fit: FlexFit.loose,
                                showSearchBox: true,
                                emptyBuilder: (context, searchEntry) =>
                                    const Center(
                                        child: Text(
                                            "¡No se encontró ningún servicio!"))),
                            onChanged: (value) {
                              List workersItem = [];
                              for (var item in widget.workers) {
                                if (item["services"] != null ||
                                    item["services"].isNotEmpty) {
                                  int exist = item["services"].indexWhere(
                                      (e) => e["uid"] == value["uid"]);
                                  if (exist != -1) {
                                    workersItem.add(item);
                                  }
                                }
                              }
                              setState(() {
                                serviceMap.addAll(value);
                                workersSelected = workersItem;
                              });
                            }),
                        const SizedBox(height: 10),
                        const Center(child: Text("* Colaboradores")),
                        DropdownSearch<dynamic>(
                            items: workersSelected,
                            itemAsString: (item) => "${item['name']}",
                            popupProps: PopupProps.dialog(
                                showSearchBox: true,
                                emptyBuilder: (context, searchEntry) =>
                                    const Center(
                                        child: Text(
                                            "¡No se encontró ningún colaborador!"))),
                            onChanged: (value) {
                              setState(() {
                                workerMap.addAll(value);
                              });
                            }),
                        const SizedBox(height: 10),
                        const Center(child: Text("* Clientes")),
                        DropdownSearch<dynamic>(
                            items: clients,
                            itemAsString: (item) => "${item['name']}",
                            popupProps: PopupProps.dialog(
                                showSearchBox: true,
                                emptyBuilder: (context, searchEntry) =>
                                    const Center(
                                        child: Text(
                                            "¡No se encontró ningún cliente!"))),
                            onChanged: (value) {
                              setState(() {
                                clientMap.addAll(value);
                              });
                            }),
                      ])),
                ))),
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
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: Colors.white,
                  shape: const StadiumBorder()),
              onPressed: () {
                if (serviceMap.isEmpty ||
                    workerMap.isEmpty ||
                    clientMap.isEmpty) {
                  MotionToast.error(
                          title: const Text("Opps"),
                          description: const Text(
                              '¡Los campos con (*) son obligatorios!'))
                      .show(context);
                } else {
                  authBloc.setIsLoading(true);
                  var date = DateTime.now();
                  String dateF = DateFormat('yyyy-MM-dd H:mm:00').format(date);
                  String dateSort =
                      DateFormat('yyyyMMdd').format(widget.dateTime);
                  String datePush =
                      DateFormat('yyyy/MM/dd').format(widget.dateTime);
                  String hour = (int.parse(widget.timeValue["hour"]) < 10)
                      ? "0${widget.timeValue["hour"]}"
                      : widget.timeValue["hour"];
                  String minutes = widget.timeValue["minutes"];
                  var appointments = {
                    "clientName": clientMap["name"],
                    "clientToken": clientMap["token"],
                    "clientUid": clientMap["uid"],
                    "colorCard": widget.indexColorCard,
                    "createdAT": dateF,
                    "day": widget.dateTime.day,
                    "month": widget.dateTime.month,
                    "serviceCost": serviceMap["cost"],
                    "serviceDuration": serviceMap["duration"],
                    "serviceDurationHour": serviceMap["durationHour"],
                    "serviceDurationMinutes": serviceMap["durationMinutes"],
                    "serviceName": serviceMap["name"],
                    "serviceUid": serviceMap["uid"],
                    "sort": int.parse("$dateSort$hour$minutes"),
                    "datePush": "$datePush $hour:$minutes",
                    "endDate": int.parse(
                        "$dateSort${serviceMap["durationHour"]}${serviceMap["durationMinutes"]}"),
                    "state": "Pendiente",
                    "timeIndex": widget.timeIndex,
                    "workerName": workerMap["name"],
                    "workerToken": workerMap["token"],
                    "workerUid": workerMap["uid"],
                    "year": widget.dateTime.year,
                  };
                  homeBloc.createAppointment(appointments).then((value) {
                    if (workerMap["token"].isEmpty) {
                      if (clientMap["token"].isEmpty) {
                        authBloc.setIsLoading(false);
                        Navigator.pop(context);
                      } else {
                        homeBloc
                            .sendPushNotification(
                                clientMap["token"],
                                "Nueva Cita $datePush $hour:$minutes",
                                "Servicio: ${serviceMap["name"]}, Atención: ${workerMap["name"]}")
                            .then((value) {
                          authBloc.setIsLoading(false);
                          Navigator.pop(context);
                        });
                      }
                    } else {
                      homeBloc
                          .sendPushNotification(
                              workerMap["token"],
                              "Nueva Cita $datePush $hour:$minutes",
                              "Servicio: ${serviceMap["name"]}, Cliente: ${clientMap["name"]}")
                          .then((value) {
                        if (clientMap["token"].isEmpty) {
                          authBloc.setIsLoading(false);
                          Navigator.pop(context);
                        } else {
                          homeBloc
                              .sendPushNotification(
                                  clientMap["token"],
                                  "Nueva Cita $datePush $hour:$minutes",
                                  "Servicio: ${serviceMap["name"]}, Atención: ${workerMap["name"]}")
                              .then((value) {
                            authBloc.setIsLoading(false);
                            Navigator.pop(context);
                          });
                        }
                      });
                    }
                  });
                }
              },
              child:
                  const Text('Agregar', style: TextStyle(color: Colors.blue))),
        ]);
  }
}
