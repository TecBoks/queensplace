import 'dart:async';
import 'package:flutter/services.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:bequeen/services/repository/services_bloc.dart';
import 'package:motion_toast/motion_toast.dart';

class ServicesAddServiceModal extends StatefulWidget {
  const ServicesAddServiceModal({Key? key}) : super(key: key);

  @override
  State<ServicesAddServiceModal> createState() =>
      _ServicesAddServiceModalState();
}

class _ServicesAddServiceModalState extends State<ServicesAddServiceModal> {
  ScrollController scrollController = ScrollController();
  TextEditingController ctrlName = TextEditingController(text: '');
  TextEditingController ctrlPrice = TextEditingController(text: '');
  int delayHours = 0;
  int delayMinutes = 0;
  late Timer timer;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Agregar un nuevo servicio:'),
        content: SizedBox(
            width: (media.width > 950)
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 1,
            height: 350,
            child: Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: Builder(
                  builder: (context) => SingleChildScrollView(
                      controller: scrollController,
                      child: Container(
                        margin: EdgeInsets.only(right: 15),
                        child: Column(children: [
                          TextField(
                              controller: ctrlName,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0)),
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700]),
                                  labelText: '* Nombre:',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ))),
                          const SizedBox(height: 10),
                          TextField(
                              controller: ctrlPrice,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9.]"))
                              ],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0)),
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700]),
                                  labelText: '* Precio:',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ))),
                          const SizedBox(height: 10),
                          const Center(child: Text("Duración del servicio:")),
                          (media.width > 950)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                      hourCtrl(context),
                                      const SizedBox(width: 20),
                                      minuteCtrl(context)
                                    ])
                              : Column(children: [
                                  hourCtrl(context),
                                  const SizedBox(height: 20),
                                  minuteCtrl(context)
                                ]),
                          const SizedBox(height: 5),
                        ]),
                      ))),
            )),
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
                if (ctrlName.text.isEmpty || ctrlPrice.text.isEmpty) {
                  MotionToast.error(
                          title: const Text("Opps"),
                          description: const Text(
                              '¡Los campos con (*) son obligatorios!'))
                      .show(context);
                } else {
                  if (delayHours < 1) {
                    if (delayMinutes < 1) {
                      MotionToast.error(
                              title: const Text("Opps"),
                              description: const Text(
                                  '¡La selección de la duración es obligatoria!'))
                          .show(context);
                    } else {
                      authBloc.setIsLoading(true);
                      servicesBloc
                          .createService(
                              ctrlName.text,
                              (delayHours * 60) + delayMinutes,
                              double.parse(ctrlPrice.text))
                          .then((value) {
                        authBloc.setIsLoading(false);
                        Navigator.pop(context);
                      });
                    }
                  } else {
                    authBloc.setIsLoading(true);
                    servicesBloc
                        .createService(
                            ctrlName.text,
                            (delayHours * 60) + delayMinutes,
                            double.parse(ctrlPrice.text))
                        .then((value) {
                      authBloc.setIsLoading(false);
                      Navigator.pop(context);
                    });
                  }
                }
              },
              child:
                  const Text('Agregar', style: TextStyle(color: Colors.blue))),
        ]);
  }

  Widget hourCtrl(context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      GestureDetector(
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        offset: const Offset(0, 4),
                        blurRadius: 4),
                  ]),
              child: const Icon(Icons.arrow_upward)),
          onTap: () {
            setState(() {
              delayHours++;
            });
          }),
      const SizedBox(width: 5),
      Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.white),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, 4),
                    blurRadius: 4),
              ]),
          child: Column(children: [
            const Text("Horas"),
            Text((delayHours < 10) ? '0$delayHours' : '$delayHours'),
          ])),
      const SizedBox(width: 10),
      GestureDetector(
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        offset: const Offset(0, 4),
                        blurRadius: 4),
                  ]),
              child: const Icon(Icons.arrow_downward)),
          onTap: () {
            if (delayHours > 0) {
              setState(() {
                delayHours--;
              });
            }
          }),
    ]);
  }

  Widget minuteCtrl(context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      GestureDetector(
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        offset: const Offset(0, 4),
                        blurRadius: 4),
                  ]),
              child: const Icon(Icons.arrow_upward)),
          onTap: () {
            if (delayMinutes < 45) {
              setState(() {
                delayMinutes = delayMinutes + 15;
              });
            } else {
              setState(() {
                delayMinutes = 0;
              });
            }
          }),
      const SizedBox(width: 5),
      Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: Colors.white),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    offset: const Offset(0, 4),
                    blurRadius: 4),
              ]),
          child: Column(children: [
            const Text("Minutos"),
            Text((delayMinutes < 10) ? '0$delayMinutes' : '$delayMinutes'),
          ])),
      const SizedBox(width: 5),
      GestureDetector(
          child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        offset: const Offset(0, 4),
                        blurRadius: 4),
                  ]),
              child: const Icon(Icons.arrow_downward)),
          onTap: () {
            if (delayMinutes > 0) {
              setState(() {
                delayMinutes = delayMinutes - 15;
              });
            } else {
              setState(() {
                delayMinutes = 45;
              });
            }
          }),
    ]);
  }
}
