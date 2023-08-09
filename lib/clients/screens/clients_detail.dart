import 'package:bequeen/loyalty_points/screens/loyalty_points_admin_detail.dart';
import 'package:flutter/material.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/clients/repository/clients_bloc.dart';
import 'package:bequeen/utils/loading.dart';
import 'package:bequeen/utils/skeleton_loader.dart';

class ClientsDetail extends StatefulWidget {
  final dynamic client;
  const ClientsDetail({Key? key, required this.client}) : super(key: key);

  @override
  State<ClientsDetail> createState() => _ClientsDetailState();
}

class _ClientsDetailState extends State<ClientsDetail> {
  ScrollController scrollController = ScrollController();
  bool loading = false;
  int limit = 20;
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
        appBar:
            AppBar(title: Row(children: [Text("${widget.client["name"]}")])),
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
                                child: Text('Cliente',
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 22),
                                    textAlign: TextAlign.center))
                          ])),
                      const SizedBox(height: 10),
                      (widget.client['email'] == "")
                          ? Container()
                          : Text('Correo: ${widget.client['email']}'),
                      (widget.client['phone'] == "")
                          ? Container()
                          : Text('Contacto: ${widget.client['phone']}'),
                      const SizedBox(height: 10),
                      InputChip(
                          backgroundColor: Colors.green,
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      LoyaltyPointsAdminDetail(
                                          client: widget.client))),
                          elevation: 2,
                          label: const Text('Administrar Puntos de Lealtad',
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
                          stream: clientsBloc.getAppointments(
                              widget.client["uid"], limit),
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
                          }),
                    ]),
                  )))),
        ));
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
