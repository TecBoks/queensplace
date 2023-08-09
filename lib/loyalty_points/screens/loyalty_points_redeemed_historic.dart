import 'package:flutter/material.dart';
import 'package:bequeen/loyalty_points/repository/loyalty_points_bloc.dart';
import 'package:bequeen/utils/skeleton_loader.dart';

class LoyaltyPointsRedeemedHistoric extends StatefulWidget {
  final dynamic userAuth;
  const LoyaltyPointsRedeemedHistoric({Key? key, required this.userAuth})
      : super(key: key);

  @override
  State<LoyaltyPointsRedeemedHistoric> createState() =>
      _LoyaltyPointsRedeemedHistoricState();
}

class _LoyaltyPointsRedeemedHistoricState
    extends State<LoyaltyPointsRedeemedHistoric> {
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
                          stream: loyaltyPointsBloc
                              .getRedeemedPoints(widget.userAuth["uid"]),
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
                Text(
                    "Fecha: ${redeemedPoint['year']}/${convert(redeemedPoint['month'])}/${convert(redeemedPoint['day'])} ${convert(redeemedPoint['hour'])}:${convert(redeemedPoint['minutes'])}",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('Puntos canjeados: ${redeemedPoint['redeemedPoints']}'),
                Text('Descuento: L ${redeemedPoint['qty']}'),
                Text('Estado: ${redeemedPoint['state']}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: (redeemedPoint['state'] == "Pendiente")
                            ? Colors.red
                            : Colors.green)),
              ])),
        ]));
  }

  convert(int number) {
    if (number > 10) {
      return "$number";
    } else {
      return "0$number";
    }
  }
}
