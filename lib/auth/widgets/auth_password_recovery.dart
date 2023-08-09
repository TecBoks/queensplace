import 'package:flutter/material.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';

class AuthPasswordRecovery extends StatefulWidget {
  final TextEditingController email;
  const AuthPasswordRecovery({Key? key, required this.email}) : super(key: key);

  @override
  State<AuthPasswordRecovery> createState() => _AuthPasswordRecoveryState();
}

class _AuthPasswordRecoveryState extends State<AuthPasswordRecovery> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: const Text('¿Olvidaste tu contraseña?',
            style:
                TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center),
        onTap: () {
          _passwordRecovery(context);
        });
  }

  _passwordRecovery(context) {
    showDialog(
        context: context,
        builder: (context) {
          if (widget.email.text.isEmpty) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: const Text(
                    "No hay correo electrónico para realizar el proceso de cambio de contraseña."),
                actions: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Colors.black,
                          shape: const StadiumBorder()),
                      onPressed: () {
                        hideAlertDialog(context);
                      },
                      child: const Text('Ok!',
                          style: TextStyle(color: Colors.white)))
                ]);
          } else {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                content: Text(
                    "Se enviará un correo electrónico a ${widget.email.text} para realizar el proceso de cambio de contraseña.\nNota: Siempre verifica en correos no deseados o Spam el correo enviado."),
                actions: <Widget>[
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Colors.black,
                          shape: const StadiumBorder()),
                      onPressed: () {
                        hideAlertDialog(context);
                      },
                      child: const Text('Cancelar',
                          style: TextStyle(color: Colors.white))),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 2,
                          backgroundColor: Colors.white,
                          shape: const StadiumBorder()),
                      onPressed: () {
                        sendRecoveryPassword(context);
                      },
                      child: const Text('Enviar',
                          style: TextStyle(color: Colors.black)))
                ]);
          }
        });
  }

  sendRecoveryPassword(context) {
    authBloc.sendPasswordResetEmail(widget.email.text);
    Navigator.pop(context);
  }

  hideAlertDialog(context) {
    Navigator.pop(context);
  }
}
