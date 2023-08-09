import 'package:bequeen/web_site/screens/web_site_home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/auth/screens/auth_register.dart';
import 'package:bequeen/auth/widgets/auth_password_recovery.dart';
import 'package:bequeen/utils/loading.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bequeen/utils/session_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:motion_toast/motion_toast.dart';

class AuthLogin extends StatefulWidget {
  const AuthLogin({Key? key}) : super(key: key);

  @override
  State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  final storage = Hive.box("queensPlaceTecBoks");
  bool loading = false;
  TextEditingController ctrlEmail = TextEditingController(text: "");
  TextEditingController ctrlPassword = TextEditingController(text: "");
  bool isPasswordHidden = true;

  @override
  void initState() {
    authBloc.signOut();
    storage.clear();
    super.initState();
  }

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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: (kIsWeb)
                ? GestureDetector(
                    child: const Icon(Icons.arrow_back, color: Colors.black),
                    onTap: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WebSiteHome()),
                        (Route<dynamic> route) => false))
                : Container(),
            title: Row(children: const <Widget>[])),
        body: SafeArea(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Center(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            child: Image.asset('assets/logo.png',
                                fit: BoxFit.fitWidth)),
                        // const Center(
                        //     child: Text("Queen's Place",
                        //         style: TextStyle(
                        //             color: Colors.blue,
                        //             fontWeight: FontWeight.bold,
                        //             fontSize: 36))),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              (media.width > 800)
                                  ? SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width / 5,
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child:
                                              Image.asset('assets/task.png')))
                                  : Container(),
                              const SizedBox(width: 15),
                              SizedBox(
                                width: (media.width > 800)
                                    ? MediaQuery.of(context).size.width / 3
                                    : MediaQuery.of(context).size.width / 1.1,
                                child: Column(children: [
                                  Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 600),
                                      margin: const EdgeInsets.only(top: 20),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(children: [
                                        textField(
                                            "* Correo:",
                                            const Icon(Icons.mail_outline),
                                            const Icon(Icons.mail),
                                            false,
                                            false,
                                            'email',
                                            ctrlEmail),
                                        const SizedBox(height: 12),
                                        textField(
                                            '* Contraseña:',
                                            const Icon(Icons.lock_outline),
                                            (isPasswordHidden == true)
                                                ? const Icon(
                                                    Icons.visibility_off,
                                                    color: Colors.grey)
                                                : const Icon(Icons.visibility,
                                                    color: Colors.grey),
                                            true,
                                            isPasswordHidden,
                                            'text',
                                            ctrlPassword),
                                      ])),
                                  const SizedBox(height: 15),
                                  AuthPasswordRecovery(email: ctrlEmail),
                                  const SizedBox(height: 15),
                                  GestureDetector(
                                      child: const Text(
                                          "¿Aún no estás en Queen's Place? Regístrate",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue),
                                          textAlign: TextAlign.center),
                                      onTap: () {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AuthRegister()),
                                            (Route<dynamic> route) => false);
                                      }),
                                  const SizedBox(height: 15),
                                  Container(
                                      constraints:
                                          const BoxConstraints(maxWidth: 600),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              elevation: 2,
                                              backgroundColor: Colors.black,
                                              shape: const StadiumBorder()),
                                          onPressed: () async {
                                            if (ctrlEmail.text.isNotEmpty &&
                                                ctrlPassword.text.isNotEmpty) {
                                              authBloc.setIsLoading(true);
                                              try {
                                                await authBloc
                                                    .signInWithEmailAndPassword(
                                                        ctrlEmail.text,
                                                        ctrlPassword.text)
                                                    .then((result) {
                                                  if (result
                                                      .user!.uid.isNotEmpty) {
                                                    authBloc
                                                        .getDataUser(
                                                            ctrlEmail.text)
                                                        .then((valueUser) {
                                                      var dataUser =
                                                          valueUser.data();
                                                      storage.put(
                                                          'userAuth', dataUser);
                                                      Navigator.pushAndRemoveUntil(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const SessionHandler()),
                                                          (Route<dynamic>
                                                                  route) =>
                                                              false);
                                                      authBloc
                                                          .setIsLoading(false);
                                                    });
                                                  }
                                                });
                                              } on FirebaseAuthException catch (error) {
                                                print(error.message);
                                                authBloc.setIsLoading(false);
                                                if (error.message ==
                                                    'There is no user record corresponding to this identifier. The user may have been deleted.') {
                                                  authBloc
                                                      .getDataUser(
                                                          ctrlEmail.text)
                                                      .then((value) {
                                                    var data = value.data();
                                                    if (data == null) {
                                                      return buildErrorDialog(
                                                          context,
                                                          '¡El usuario con el correo: ${ctrlEmail.text}, aún no ha sido creado!');
                                                    } else {
                                                      buildVerifyUserDialog(
                                                          context, data);
                                                    }
                                                  });
                                                } else if (error.message ==
                                                    'The user account has been disabled by an administrator.') {
                                                  return buildErrorDialog(
                                                      context,
                                                      '¡La cuenta de usuario ha sido deshabilitada por el administrador!');
                                                } else {
                                                  return buildErrorDialog(
                                                      context,
                                                      '¡El correo o la contraseña son incorrectos!');
                                                }
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
                                                child: Text('Iniciar Sesión',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 17))),
                                          ))),
                                  Container(
                                      margin: const EdgeInsets.all(10),
                                      child: const Text(
                                          "Si continúas, aceptas los Términos del servicio de Queen's Place y confirmas que has leído nuestra Política de privacidad",
                                          style: TextStyle(fontSize: 10),
                                          textAlign: TextAlign.center))
                                ]),
                              )
                            ]),
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
              content: Text(message),
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
        });
  }

  Future buildVerifyUserDialog(BuildContext context, user) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: const Text("Verificar Usuario"),
              content: const Text("¡Empieza ya!, activa tu usuario:"),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.blue,
                        shape: const StadiumBorder()),
                    onPressed: () async {
                      try {
                        await authBloc
                            .createUserWithEmailAndPassword(
                                ctrlEmail.text, "123456")
                            .then((result) {
                          storage.put('userAuth', user);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SessionHandler()),
                              (Route<dynamic> route) => false);
                        });
                        authBloc.setIsLoading(false);
                      } on FirebaseAuthException catch (error) {
                        authBloc.setIsLoading(false);
                        return buildErrorDialog(context, error.message);
                      } on Exception catch (error) {
                        authBloc.setIsLoading(false);
                        return buildErrorDialog(context, error.toString());
                      }
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
