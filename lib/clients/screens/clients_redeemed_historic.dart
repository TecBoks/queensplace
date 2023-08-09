import 'package:flutter/material.dart';
import 'package:bequeen/clients/repository/clients_bloc.dart';
import 'package:bequeen/utils/skeleton_loader.dart';

class ClientsRedeemedHistoric extends StatefulWidget {
  final String clientUid;
  const ClientsRedeemedHistoric({Key? key, required this.clientUid})
      : super(key: key);

  @override
  State<ClientsRedeemedHistoric> createState() =>
      _ClientsRedeemedHistoricState();
}

class _ClientsRedeemedHistoricState extends State<ClientsRedeemedHistoric> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return _body(context, media);
  }

  Widget _body(context, Size media) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: Row(children: const <Widget>[])),
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
                      const SizedBox(height: 10),
                      const Center(
                          child: Text("Historial de Puntos Canjeados",
                              style: TextStyle(
                                  fontSize: 20,
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
                          stream:
                              clientsBloc.getRedeemedPoints(widget.clientUid),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List redeemedPoints = snapshot.data.docs;
                              if (redeemedPoints.isEmpty) {
                                return const Center(
                                    child:
                                        Text('¡Aún no existe ningún canje!'));
                              } else {
                                return Container(
                                    padding: const EdgeInsets.all(10),
                                    width: (media.width > 800)
                                        ? MediaQuery.of(context).size.width /
                                            1.1
                                        : MediaQuery.of(context).size.width,
                                    child: _buildListRedeemedPoints(
                                        listRedeemedPoints(redeemedPoints),
                                        context));
                              }
                            } else {
                              return const SkeletonLoader();
                            }
                          })
                    ]),
                  )))),
        ));
  }

  listRedeemedPoints(redeemedPoints) {
    List<dynamic> newRedeemedPoints = [];
    if (redeemedPoints.length > 0) {
      for (var item in redeemedPoints) {
        newRedeemedPoints.add(item.data());
      }
    }
    // newRedeemedPoints.sort((a, b) => a["sort"].compareTo(b["sort"]));
    return newRedeemedPoints;
  }

  Widget _buildListRedeemedPoints(List<dynamic> redeemedPoints, context) {
    return ListView.builder(
        itemCount: redeemedPoints.length,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
              child: _clientsCard(redeemedPoints[index], context),
              onTap: () {});
        });
  }

  Widget _clientsCard(redeemedPoint, context) {
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
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
                Text('Estado: ${redeemedPoint['state']}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (redeemedPoint['state'] == "Pendiente")
                            ? Colors.red
                            : Colors.green)),
                Text(
                    "Fecha: ${redeemedPoint['year']}/${convert(redeemedPoint['month'])}/${convert(redeemedPoint['day'])} ${convert(redeemedPoint['hour'])}:${convert(redeemedPoint['minutes'])}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Puntos canjeados: ${redeemedPoint['redeemedPoints']}'),
                Text('Descuento: L ${redeemedPoint['qty']}'),
                Text('Correlativo: ${redeemedPoint['correlative']}',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Comentario: ${redeemedPoint['comment']}'),
              ])),
          (redeemedPoint['state'] == "Pendiente")
              ? InputChip(
                  backgroundColor: Colors.black,
                  onPressed: () => approveRedeem(context, redeemedPoint),
                  elevation: 2,
                  label: const Text('Aprobar',
                      style: TextStyle(color: Colors.yellow)))
              : Container(),
        ]));
  }

  approveRedeem(context, redeem) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text("¡Advertencia!"),
              content: Text(
                  "¿Seguro que quieres aprobar los puntos canjeados en la fechas ${redeem['year']}/${convert(redeem['month'])}/${convert(redeem['day'])} ${convert(redeem['hour'])}:${convert(redeem['minutes'])}?"),
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
                      clientsBloc.updateRedeemPoints(redeem);
                      Navigator.pop(context);
                    },
                    child: const Text('Aprobar',
                        style: TextStyle(color: Colors.blue)))
              ]);
        });
  }

  convert(int number) {
    if (number > 10) {
      return "$number";
    } else {
      return "0$number";
    }
  }
}
