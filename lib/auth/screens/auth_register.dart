import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/auth/screens/auth_login.dart';
import 'package:bequeen/utils/loading.dart';
import 'package:bequeen/utils/session_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

class AuthRegister extends StatefulWidget {
  const AuthRegister({Key? key}) : super(key: key);

  @override
  State<AuthRegister> createState() => _AuthRegisterState();
}

class _AuthRegisterState extends State<AuthRegister> {
  final storage = Hive.box("queensPlaceTecBoks");
  bool loading = false;
  TextEditingController ctrlName = TextEditingController(text: "");
  TextEditingController ctrlEmail = TextEditingController(text: "");
  TextEditingController ctrlPassword = TextEditingController(text: "");
  TextEditingController ctrlBirthDate = TextEditingController(text: "");
  TextEditingController ctrlPhone = TextEditingController(text: "");
  bool isPasswordHidden = true;

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Stack(children: <Widget>[
      _buildUI(media),
      StreamBuilder(
          stream: authBloc.loadingStream,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            loading = snapshot.data ?? false;
            return loading
                ? const Loading(
                    colorVariable: Color.fromRGBO(255, 255, 255, 0.4))
                : Container();
          })
    ]);
  }

  Widget _buildUI(Size media) {
    var date = DateTime.now();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
                child: const Icon(Icons.arrow_back, color: Colors.black),
                onTap: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const AuthLogin()),
                    (Route<dynamic> route) => false)),
            title: Row(children: const <Widget>[])),
        body: SafeArea(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
              child: SizedBox(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                const SizedBox(height: 15),
                const Center(
                    child: Text("Registrate",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                            fontSize: 36),
                        textAlign: TextAlign.center)),
                SizedBox(
                  width: (media.width > 800)
                      ? MediaQuery.of(context).size.width / 3
                      : MediaQuery.of(context).size.width / 1.1,
                  child: Column(children: [
                    Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        margin: const EdgeInsets.only(top: 20),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(children: [
                          textField(
                              "* Nombres y Apellidos:",
                              const Icon(Icons.person),
                              const Icon(Icons.person),
                              false,
                              false,
                              'text',
                              ctrlName),
                          const SizedBox(height: 12),
                          textField(
                              "* Correo:",
                              const Icon(Icons.email),
                              const Icon(Icons.email),
                              false,
                              false,
                              'email',
                              ctrlEmail),
                          const SizedBox(height: 12),
                          textField(
                              '* Contraseña:',
                              const Icon(Icons.lock_outline),
                              (isPasswordHidden == true)
                                  ? const Icon(Icons.visibility_off,
                                      color: Colors.grey)
                                  : const Icon(Icons.visibility,
                                      color: Colors.grey),
                              true,
                              isPasswordHidden,
                              'text',
                              ctrlPassword),
                          const SizedBox(height: 12),
                          textField(
                              "Celular (Opcional):",
                              const Icon(Icons.phone),
                              const Icon(Icons.phone),
                              false,
                              false,
                              'number',
                              ctrlPhone),
                          const SizedBox(height: 12),
                          Container(
                              margin: const EdgeInsets.only(top: 5),
                              padding: const EdgeInsets.only(
                                  top: 3, left: 5, bottom: 3, right: 20),
                              decoration: BoxDecoration(
                                  color: Colors.white60,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1, color: Colors.grey.shade200),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        offset: const Offset(0, 4),
                                        blurRadius: 4),
                                  ]),
                              child: DateTimeField(
                                  controller: ctrlBirthDate,
                                  resetIcon: const Icon(Icons.close),
                                  decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.date_range),
                                      focusedBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      hintText: 'Fecha de nacimiento (Opcional):'),
                                  format: DateFormat("yyyy/MM/dd"),
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
                        ])),
                    const SizedBox(height: 15),
                    GestureDetector(
                        child: const Text(
                            "¿Ya estás en Queen's Place? Inicia Sesión",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                            textAlign: TextAlign.center),
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AuthLogin()),
                              (Route<dynamic> route) => false);
                        }),
                    const SizedBox(height: 15),
                    Container(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: Colors.black,
                                shape: const StadiumBorder()),
                            onPressed: () async {
                              if (ctrlEmail.text.isNotEmpty &&
                                  ctrlPassword.text.isNotEmpty &&
                                  ctrlName.text.isNotEmpty) {
                                authBloc.setIsLoading(true);
                                try {
                                  await authBloc
                                      .createUserWithEmailAndPassword(
                                          ctrlEmail.text, ctrlPassword.text)
                                      .then((result) {
                                    authBloc
                                        .createUserFirestore(
                                            ctrlBirthDate.text,
                                            ctrlEmail.text,
                                            ctrlName.text,
                                            ctrlPhone.text)
                                        .then((value) {
                                      storage.put('userAuth', {
                                        'name': ctrlName.text,
                                        'email': ctrlEmail.text,
                                        'photoURL': "",
                                        'phone': ctrlPhone.text,
                                        'birthDay': ctrlBirthDate.text,
                                        'uid': ctrlEmail.text,
                                        'accumulatedPoints': 0,
                                        'redeemedPoints': 0,
                                        'type': 'client'
                                      });
                                      Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SessionHandler()),
                                          (Route<dynamic> route) => false);
                                    });
                                    authBloc.setIsLoading(false);
                                  });
                                  authBloc.setIsLoading(false);
                                } on FirebaseAuthException catch (error) {
                                  authBloc.setIsLoading(false);
                                  return buildErrorDialog(
                                      context,
                                      (error.message ==
                                              'Password should be at least 6 characters')
                                          ? 'La contraseña debe tener al menos 6 caracteres'
                                          : error.message);
                                } on Exception catch (error) {
                                  authBloc.setIsLoading(false);
                                  return buildErrorDialog(
                                      context, error.toString());
                                }
                              } else {
                                MotionToast.error(
                                        title: const Text("Opps"),
                                        description: const Text(
                                            '¡Los campos con (*) son obligatorios!'))
                                    .show(context);
                              }
                            },
                            child: const SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                  child: Text('Registrate',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17))),
                            ))),
                    Container(
                        margin: const EdgeInsets.all(10),
                        child: const Text(
                            "Si continúas, aceptas los Términos del servicio de Queen's Place y confirmas que has leído nuestra Política de privacidad",
                            style: TextStyle(fontSize: 10),
                            textAlign: TextAlign.center))
                  ]),
                )
              ]))),
        )));
  }

  Future buildErrorDialog(BuildContext context, message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              // "¡El correo o la contraseña son incorrectos!"
              title: const Text('No se pudo hacer el registro:'),
              content: Text((message ==
                      "The email address is already in use by another account.")
                  ? "¡La dirección de correo electrónico ya está siendo utilizada por otra cuenta!"
                  : message),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.blue,
                        shape: const StadiumBorder()),
                    onPressed: () {
                      hideAlertDialog(context);
                    },
                    child: const Text('Ok!',
                        style: TextStyle(color: Colors.white)))
              ]);
        });
  }

  hideAlertDialog(context) {
    Navigator.pop(context);
  }

  Widget textField(String placeHolder, Icon icon, Icon iconRight, bool isIcon,
      obscureText, type, TextEditingController controller) {
    return Container(
        padding: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
            color: Colors.white60,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.grey.shade200),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  offset: const Offset(0, 4),
                  blurRadius: 4),
            ]),
        child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            onChanged: (value) {},
            inputFormatters: (type == 'text')
                ? []
                : (type == 'email')
                    ? [
                        FilteringTextInputFormatter.allow(
                            RegExp("[a-zA-ZñÑ0-9.@\$*/_#!%&^()-]"))
                      ]
                    : [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
            keyboardType: (type == 'text')
                ? TextInputType.text
                : (type == 'email')
                    ? TextInputType.emailAddress
                    : TextInputType.number,
            decoration: InputDecoration(
                prefixIcon: icon,
                suffixIcon: (!isIcon)
                    ? const SizedBox()
                    : GestureDetector(
                        child: iconRight,
                        onTap: () {
                          setState(() {
                            isPasswordHidden = !isPasswordHidden;
                          });
                        }),
                border: InputBorder.none,
                hintText: placeHolder)));
  }
}
