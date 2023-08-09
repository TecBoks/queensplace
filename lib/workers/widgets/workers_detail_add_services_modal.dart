import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/workers/repository/workers_bloc.dart';
import 'package:motion_toast/motion_toast.dart';

class WorkersDetailAddServicesModal extends StatefulWidget {
  final dynamic worker;
  final dynamic refreshScreen;
  const WorkersDetailAddServicesModal(
      {Key? key, required this.worker, required this.refreshScreen})
      : super(key: key);

  @override
  State<WorkersDetailAddServicesModal> createState() =>
      _WorkersDetailAddServicesModalState();
}

class _WorkersDetailAddServicesModalState
    extends State<WorkersDetailAddServicesModal> {
  Map<String, dynamic> serviceMap = {};
  List<dynamic> services = [];

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 0), () {
      workersBloc.getServices().then((value) {
        if (widget.worker["services"] == null ||
            widget.worker["services"].isEmpty) {
          setState(() {
            services = value;
          });
        } else {
          List servicesFilter = value;
          for (var item in widget.worker["services"]) {
            servicesFilter
                .removeWhere((element) => element["uid"] == item["uid"]);
          }
          setState(() {
            services = servicesFilter;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Agregar un nuevo servicio:'),
        content: SizedBox(
            width: (media.width > 800)
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width / 1,
            height: 150,
            child: Column(children: [
              const Center(child: Text("Servicios")),
              const SizedBox(height: 5),
              DropdownSearch<dynamic>(
                  items: services,
                  itemAsString: (item) => "${item['name']}",
                  popupProps: PopupProps.dialog(
                      showSearchBox: true,
                      emptyBuilder: (context, searchEntry) => const Center(
                          child: Text("¡No se encontró ningún servicio!"))),
                  onChanged: (value) {
                    setState(() {
                      serviceMap.addAll(value);
                    });
                  }),
            ])),
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
                if (serviceMap.isEmpty) {
                  MotionToast.error(
                          title: const Text("Opps"),
                          description: const Text(
                              '¡Los campos con (*) son obligatorios!'))
                      .show(context);
                } else {
                  authBloc.setIsLoading(true);
                  var data = widget.worker;
                  List servicesSelected = [];
                  if (widget.worker["services"] == null ||
                      widget.worker["services"].isEmpty) {
                    servicesSelected = [];
                  } else {
                    servicesSelected = widget.worker["services"];
                  }
                  servicesSelected.add(serviceMap);
                  data["services"] = servicesSelected;
                  workersBloc.updateDataUser(data).then((value) {
                    authBloc.setIsLoading(false);
                    widget.refreshScreen();
                    Navigator.pop(context);
                  });
                }
              },
              child:
                  const Text('Agregar', style: TextStyle(color: Colors.blue))),
        ]);
  }
}
