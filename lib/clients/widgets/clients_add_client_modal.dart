import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/clients/repository/clients_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:motion_toast/motion_toast.dart';

class ClientsAddClientModal extends StatefulWidget {
  const ClientsAddClientModal({Key? key}) : super(key: key);

  @override
  State<ClientsAddClientModal> createState() => _ClientsAddClientModalState();
}

class _ClientsAddClientModalState extends State<ClientsAddClientModal> {
  TextEditingController ctrlName = TextEditingController(text: '');
  TextEditingController ctrlEmail = TextEditingController(text: '');
  TextEditingController ctrlPhone = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Agregar un nuevo cliente:'),
        content: SizedBox(
            width: (media.width > 800)
                ? MediaQuery.of(context).size.width / 3
                : MediaQuery.of(context).size.width / 1,
            height: 350,
            child: Column(children: [
              TextField(
                  controller: ctrlName,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0)),
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      labelText: '* Nombre:',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
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
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      labelText: 'Correo:',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(7.0),
                      ))),
              const SizedBox(height: 10),
              TextField(
                  controller: ctrlPhone,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                  ],
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0)),
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      labelText: '* Teléfono Celular:',
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(7.0),
                      ))),
              const SizedBox(height: 5),
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
                if (ctrlName.text.isEmpty || ctrlPhone.text.isEmpty) {
                  MotionToast.error(
                          title: const Text("Opps"),
                          description: const Text(
                              '¡Los campos con (*) son obligatorios!'))
                      .show(context);
                } else {
                  authBloc.setIsLoading(true);
                  clientsBloc
                      .createClient(
                          ctrlName.text, ctrlEmail.text, ctrlPhone.text)
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
