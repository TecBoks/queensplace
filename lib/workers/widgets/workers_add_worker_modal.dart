import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:bequeen/workers/repository/workers_bloc.dart';
import 'package:motion_toast/motion_toast.dart';

class WorkersAddWorkerModal extends StatefulWidget {
  const WorkersAddWorkerModal({Key? key}) : super(key: key);

  @override
  State<WorkersAddWorkerModal> createState() => _WorkersAddWorkerModalState();
}

class _WorkersAddWorkerModalState extends State<WorkersAddWorkerModal> {
  ScrollController scrollController = ScrollController();
  TextEditingController ctrlName = TextEditingController(text: '');
  TextEditingController ctrlEmail = TextEditingController(text: '');
  TextEditingController ctrlPhone = TextEditingController(text: '');
  TextEditingController ctrlBirthDate = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    var date = DateTime.now();
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Agregar un nuevo colaborador:'),
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
                              controller: ctrlEmail,
                              keyboardType: TextInputType.emailAddress,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-ZñÑ0-9.@\$*/_#!%&^()-]"))
                              ],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0)),
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700]),
                                  labelText: '* Correo:',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ))),
                          const SizedBox(height: 10),
                          TextField(
                              controller: ctrlPhone,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]"))
                              ],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0)),
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700]),
                                  labelText: '* Teléfono Celular:',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ))),
                          const SizedBox(height: 10),
                          Container(
                              margin: const EdgeInsets.only(top: 5),
                              padding: const EdgeInsets.only(
                                  top: 3, left: 5, bottom: 3, right: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(width: 1, color: Colors.grey)),
                              child: DateTimeField(
                                  controller: ctrlBirthDate,
                                  resetIcon: const Icon(Icons.close),
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.date_range),
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      hintText: '* Fecha de nacimiento:'),
                                  format: DateFormat("yyyy-MM-dd"),
                                  onShowPicker: (context, currentValue) {
                                    return showDatePicker(
                                        context: context,
                                        locale: const Locale('es'),
                                        firstDate: DateTime(1900),
                                        initialDate: DateTime.utc(
                                            date.year - 18, date.month),
                                        lastDate: DateTime.utc(
                                            date.year - 18, 12, 31));
                                  })),
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
                if (ctrlEmail.text.isEmpty &&
                    ctrlPhone.text.isEmpty &&
                    ctrlBirthDate.text.isEmpty &&
                    ctrlName.text.isEmpty) {
                  MotionToast.error(
                          title: const Text("Opps"),
                          description: const Text(
                              '¡Los campos con (*) son obligatorios!'))
                      .show(context);
                } else {
                  authBloc.setIsLoading(true);
                  workersBloc
                      .createWorker(ctrlBirthDate.text, ctrlEmail.text,
                          ctrlName.text, ctrlPhone.text)
                      .then((value) {
                    authBloc.setIsLoading(false);
                    Navigator.pop(context);
                  });
                }
              },
              child:
                  const Text('Agregar', style: TextStyle(color: Colors.blue))),
        ]);
  }
}
