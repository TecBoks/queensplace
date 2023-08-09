import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/auth/screens/auth_login.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bequeen/utils/loading.dart';
import 'package:bequeen/utils/session_handler.dart';

class AuthVerifyEmail extends StatefulWidget {
  final String? email;
  const AuthVerifyEmail({Key? key, required this.email}) : super(key: key);

  @override
  State<AuthVerifyEmail> createState() => _AuthVerifyEmailState();
}

class _AuthVerifyEmailState extends State<AuthVerifyEmail> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  User? user;
  final storage = Hive.box("queensPlaceTecBoks");

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    sendEmail(context);
  }

  sendEmail(context) async {
    await user!.reload();
    try {
      user!.sendEmailVerification();
    } catch (e) {
      _buildDialog(context,
          "Demasiados intentos realizados para este correo, intentelo de nuevo más tarde.");
    }
    authBloc.setIsLoading(false);
  }

  checkEmailVerified() {
    user!.reload();
    if (user!.emailVerified) {
      user!.reload();
      authBloc.setIsLoading(false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const SessionHandler()),
          (Route<dynamic> route) => false);
    } else {
      authBloc.setIsLoading(false);
      _buildDialog(
          context, 'Aún no se ha verificado el correo, intente de nuevo.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      _buildUI(),
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

  Widget _buildUI() {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          const Center(
                              child: Text('Verificación De Correo',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w900))),
                          const Center(
                              child: Icon(Icons.mark_email_unread_outlined,
                                  size: 120, color: Colors.blue)),
                          Center(
                              child: Container(
                                  margin: const EdgeInsets.all(25),
                                  child: Text(
                                      "Se envió un correo con el link (URL) a ${widget.email} para verificar el correo electrónico.\nNota: Siempre verifica en correos no deseados o Spam el correo enviado.",
                                      textAlign: TextAlign.center))),
                          InputChip(
                              backgroundColor: Colors.black,
                              onPressed: () {
                                authBloc.setIsLoading(true);
                                checkEmailVerified();
                              },
                              elevation: 2,
                              label: const Text('Ingresar',
                                  style: TextStyle(color: Colors.white))),
                          InputChip(
                              onPressed: () {
                                authBloc.setIsLoading(true);
                                sendEmail(context);
                              },
                              elevation: 2,
                              label: const Text(
                                  'Reenviar Correo De Verificación')),
                          GestureDetector(
                              child: const Text('Cerrar Sesión',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.w700)),
                              onTap: () {
                                authBloc.signOut();
                                storage.clear();
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const AuthLogin()),
                                    (Route<dynamic> route) => false);
                              })
                        ])))));
  }

  _buildDialog(context, msj) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Text(msj),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.black,
                        shape: const StadiumBorder()),
                    onPressed: () {
                      authBloc.setIsLoading(false);
                      Navigator.pop(context);
                    },
                    child: const Text('Entendido',
                        style: TextStyle(color: Colors.white)))
              ]);
        });
  }

  hideAlertDialog(context) {
    Navigator.pop(context);
  }
}
