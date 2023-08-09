import 'package:flutter/material.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/utils/loading.dart';
import 'package:bequeen/utils/skeleton_loader.dart';
import 'package:bequeen/workers/repository/workers_bloc.dart';
import 'package:bequeen/workers/widgets/workers_detail_add_services_modal.dart';

class WorkersDetail extends StatefulWidget {
  final dynamic worker;
  const WorkersDetail({Key? key, required this.worker}) : super(key: key);

  @override
  State<WorkersDetail> createState() => _WorkersDetailState();
}

class _WorkersDetailState extends State<WorkersDetail> {
  ScrollController scrollController = ScrollController();
  bool loading = false;
  int limit = 20;
  List services = [];
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
    if (widget.worker["services"] != null) {
      services = widget.worker["services"];
    }
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
    return Stack(children: <Widget>[
      _body(context, media),
      StreamBuilder(
          stream: authBloc.loadingStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            loading = snapshot.data ?? false;
            return loading
                ? const Loading(
                    colorVariable: Color.fromRGBO(255, 255, 255, 0.7))
                : Container();
          })
    ]);
  }

  Widget _body(context, Size media) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Row(children: [Text("${widget.worker["name"]}")])),
        body: Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          child: Builder(
              builder: (context) => SingleChildScrollView(
                  controller: scrollController,
                  child: Center(
                      child: Container(
                    padding: const EdgeInsets.all(10),
                    width: (media.width > 800)
                        ? MediaQuery.of(context).size.width / 1.2
                        : MediaQuery.of(context).size.width,
                    child: Column(children: [
                      Container(
                          height: 40,
                          margin: const EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                              color: Colors.black87,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(children: [
                            Expanded(
                                child: Text(
                                    'Colaborador',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 22),
                                    textAlign: TextAlign.center))
                          ])),
                      const SizedBox(height: 10),
                      Text('Correo: ${widget.worker['email']}'),
                      const SizedBox(height: 5),
                      Text('Contacto: ${widget.worker['phone']}'),
                      const SizedBox(height: 5),
                      Text('Cumpleaños: ${widget.worker['birthDay']}'),
                      const SizedBox(height: 10),
                      const Center(
                          child: Text("Servicios",
                              style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                      Center(
                          child: Container(
                              width: 80,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black))),
                      const SizedBox(height: 10),
                      (widget.worker["services"] == null ||
                              widget.worker["services"].isEmpty)
                          ? Container()
                          : _buildListServices(
                              widget.worker["services"], context),
                      const SizedBox(height: 10),
                      InputChip(
                          backgroundColor: Colors.blue,
                          onPressed: () => _buildAddDialog(context),
                          elevation: 2,
                          label: const Text('Añadir Servicio',
                              style: TextStyle(color: Colors.white))),
                      const SizedBox(height: 10),
                      const Center(
                          child: Text("Citas",
                              style: TextStyle(
                                  fontSize: 50,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold))),
                      Center(
                          child: Container(
                              width: 80,
                              height: 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black))),
                      const SizedBox(height: 10),
                      StreamBuilder(
                          stream: workersBloc.getAppointments(
                              widget.worker["uid"], limit),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List appo = snapshot.data.docs;
                              if (appo.isEmpty) {
                                return const Center(
                                    child:
                                        Text('¡Aún no existe ninguna cita!'));
                              } else {
                                return Container(
                                    padding: const EdgeInsets.all(10),
                                    width: (media.width > 800)
                                        ? MediaQuery.of(context).size.width /
                                            1.1
                                        : MediaQuery.of(context).size.width,
                                    child: _buildListAppo(
                                        listAppo(appo), context));
                              }
                            } else {
                              return const SkeletonLoader();
                            }
                          })
                    ]),
                  )))),
        ));
  }

  Widget _buildListServices(List<dynamic> services, context) {
    return ListView.builder(
        itemCount: services.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
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
                      Text("Servicio: ${services[index]["name"]}"),
                      Text(
                          'Duración: ${services[index]['durationHour']} hora(s) ${services[index]['durationMinutes']} minutos'),
                    ])),
                GestureDetector(
                    child: const Icon(Icons.delete, color: Colors.red),
                    onTap: () {
                      authBloc.setIsLoading(true);
                      var data = widget.worker;
                      data["services"].removeWhere((element) =>
                          element["uid"] == services[index]["uid"]);
                      workersBloc.updateDataUser(data).then((value) {
                        authBloc.setIsLoading(false);
                        setState(() {});
                      });
                    }),
                const SizedBox(width: 15),
              ]));
        });
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

  Future _buildAddDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return WorkersDetailAddServicesModal(
              worker: widget.worker, refreshScreen: refreshScreen);
        });
  }

  refreshScreen() {
    setState(() {});
  }
}
