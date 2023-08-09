import 'package:bequeen/auth/screens/auth_login.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hovering/hovering.dart';
import 'package:bequeen/auth/repository/auth_bloc.dart';
import 'package:bequeen/profile/repository/profile_bloc.dart';
import 'package:bequeen/utils/side_menu.dart';
import 'package:bequeen/utils/side_menu_responsive.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';

class ProfileHome extends StatefulWidget {
  const ProfileHome({Key? key}) : super(key: key);

  @override
  State<ProfileHome> createState() => _ProfileHomeState();
}

class _ProfileHomeState extends State<ProfileHome> {
  ScrollController scrollController = ScrollController();
  var userAuth = {};
  final storage = Hive.box("queensPlaceTecBoks");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    userAuth = (storage.get('userAuth') == null) ? {} : storage.get('userAuth');
    Size media = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        drawer:
            (media.width > 800) ? null : SideMenuResponsive(userAuth: userAuth),
        appBar: AppBar(
            title: Row(children: <Widget>[
          Container(
              width: 40,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
              child: Image.asset('assets/task.png')),
          Expanded(child: Container()),
          (media.width > 800)
              ? GestureDetector(
                  child: Text('¡Hola ${userAuth['name']}!'),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileHome()),
                        (Route<dynamic> route) => false);
                  })
              : Container(),
          (media.width > 800)
              ? GestureDetector(
                  child: (userAuth['photoURL'] == null ||
                          userAuth['photoURL'] == '')
                      ? Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade300),
                              shape: BoxShape.circle,
                              image: const DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage('assets/profile.jpg'))))
                      : Container(
                          height: 40,
                          width: 40,
                          margin: const EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(
                                  width: 1, color: Colors.grey.shade300),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(userAuth['photoURL'])))),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfileHome()),
                        (Route<dynamic> route) => false);
                  })
              : Container()
        ])),
        body: Stack(children: [
          Scrollbar(
              thumbVisibility: true,
              controller: scrollController,
              child: Builder(
                  builder: (context) => SingleChildScrollView(
                      controller: scrollController,
                      child: _container(context)))),
          (media.width > 800)
              ? HoverWidget(
                  hoverChild: SideMenu(size: 200, userAuth: userAuth),
                  child: SideMenu(size: 60, userAuth: userAuth),
                  onHover: (value) {})
              : Container(),
        ]));
  }

  Widget _container(context) {
    Size media = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(right: 15),
        width: MediaQuery.of(context).size.width,
        child: Container(
            width: MediaQuery.of(context).size.width / 1.1,
            margin: EdgeInsets.only(left: (media.width > 700) ? 60 : 0),
            decoration: const BoxDecoration(color: Colors.white),
            child: Column(children: [
              Container(
                  height: 40,
                  margin: const EdgeInsets.only(right: 10, left: 10),
                  decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(children: const [
                    Expanded(
                        child: Text('Ajustes',
                            style: TextStyle(color: Colors.white, fontSize: 22),
                            textAlign: TextAlign.center))
                  ])),
              const SizedBox(height: 10),
              // (userAuth['photoURL'] == null || userAuth['photoURL'].isEmpty)
              //     ? Container(
              //         height: 100,
              //         width: 250,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             border:
              //                 Border.all(width: 1, color: Colors.grey.shade300),
              //             image: const DecorationImage(
              //                 fit: BoxFit.contain,
              //                 image: AssetImage('assets/profile.jpg'))))
              //     : Container(
              //         height: 100,
              //         width: 250,
              //         decoration: BoxDecoration(
              //             borderRadius: BorderRadius.circular(10),
              //             border:
              //                 Border.all(width: 1, color: Colors.grey.shade300),
              //             image: DecorationImage(
              //                 fit: BoxFit.contain,
              //                 image: NetworkImage(userAuth['photoURL'])))),
              // const SizedBox(height: 10),
              // InputChip(
              //     backgroundColor: Colors.blue,
              //     onPressed: () async {
              //       FilePickerResult? result = await FilePicker.platform
              //           .pickFiles(
              //               allowedExtensions: ['jpeg', 'jpg', 'png'],
              //               type: FileType.custom);
              //       if (result != null) {
              //         Uint8List? fileBytes = result.files.first.bytes;
              //         String fileName = result.files.first.name;
              //         String photoExtension =
              //             fileName.split(".")[fileName.split('.').length - 1];
              //         String path = 'user/photoURL/${userAuth['uid']}';
              //         Reference ref =
              //             FirebaseStorage.instance.ref().child(path);
              //         await ref.putData(
              //             fileBytes!,
              //             SettableMetadata(
              //                 contentType: 'image/$photoExtension'));
              //         var downUrl = await ref.getDownloadURL();
              //         var urlImage = downUrl.toString();
              //         var newUser = userAuth;
              //         newUser['photoURL'] = urlImage;
              //         storage.put('userAuth', newUser);
              //         profileBloc.updateDataUser(newUser['uid'], newUser);
              //         setState(() {});
              //       }
              //     },
              //     elevation: 2,
              //     label: const Text('Editar Foto de Perfil',
              //         style: TextStyle(color: Colors.white))),
              // const SizedBox(height: 10),
              Container(
                  width: (media.width > 700)
                      ? MediaQuery.of(context).size.width / 2
                      : MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 10, right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(width: 1, color: Colors.grey.shade300)),
                  child: Row(children: [
                    const Text("Correo",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(child: Text(" ${userAuth['email']}"))
                  ])),
              InputChip(
                  backgroundColor: Colors.red,
                  onPressed: () =>
                      _passwordRecovery(context, userAuth['email']),
                  elevation: 2,
                  label: const Text('Cambiar Contraseña',
                      style: TextStyle(color: Colors.white))),
              const SizedBox(height: 10),
              userCard(userAuth['name'], 'name', "Nombres y Apellidos:", media,
                  context),
              userCard(userAuth['phone'], 'phone', "Celular:", media, context),
              userCard(userAuth['birthDay'], 'birthDay', "Fecha de Nacimiento:",
                  media, context),
              const SizedBox(height: 30),
              Container(
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 10, left: 30, right: 30),
                  padding: const EdgeInsets.all(10),
                  child: InputChip(
                      backgroundColor: const Color.fromRGBO(228, 8, 0, 1),
                      onPressed: () {
                        _buildDeleteDialog(context);
                      },
                      elevation: 2,
                      label: const Text('Eliminar Cuenta',
                          style: TextStyle(color: Colors.white)))),
            ])));
  }

  Future _buildDeleteDialog(BuildContext context) {
    TextEditingController ctrlPasswordResingin =
        TextEditingController(text: '');
    return showDialog(
        context: context,
        builder: (context) {
          bool isloading = false;
          return StreamBuilder(
              stream: authBloc.loadingStream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                isloading = snapshot.data ?? false;
                return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    title: const Text("¡Advertencia!"),
                    content: SizedBox(
                        height: 250,
                        child: Column(children: [
                          Text(
                              "¿Seguro que quieres eliminar tu cuenta permanentemente?"),
                          SizedBox(height: 10),
                          TextFormField(
                              controller: ctrlPasswordResingin,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(7.0)),
                                  labelStyle:
                                      TextStyle(color: Colors.grey[700]),
                                  labelText: '* Contraseña:',
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.0),
                                    borderRadius: BorderRadius.circular(7.0),
                                  ))),
                        ])),
                    actions: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              elevation: 2,
                              backgroundColor: Colors.blue,
                              shape: const StadiumBorder()),
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancelar',
                              style: TextStyle(color: Colors.white))),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              elevation: 2,
                              backgroundColor: Colors.white,
                              shape: const StadiumBorder()),
                          onPressed: () async {
                            if (!isloading) {
                              if (ctrlPasswordResingin.text.isEmpty) {
                                MotionToast.error(
                                        title: const Text("Opps"),
                                        description: const Text(
                                            '¡Los campos con * son obligatorios'))
                                    .show(context);
                              } else {
                                authBloc.setIsLoading(true);
                                try {
                                  await authBloc
                                      .signInWithEmailAndPassword(
                                          userAuth['email'],
                                          ctrlPasswordResingin.text)
                                      .then((value) {
                                    if (value.user!.uid.isNotEmpty) {
                                      value.user?.delete().then((value) {
                                        authBloc.deleteUser(userAuth['uid']);
                                        authBloc.setIsLoading(false);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AuthLogin()),
                                            (Route<dynamic> route) => false);
                                      }, onError: (e) {
                                        authBloc.setIsLoading(false);
                                        print(e);
                                        MotionToast.error(
                                                title: const Text("Opps"),
                                                description: const Text(
                                                    '¡No se pudo eliminar tu cuenta, intenta de nuevo!'))
                                            .show(context);
                                      });
                                    } else {
                                      authBloc.setIsLoading(false);
                                      MotionToast.error(
                                              title: const Text("Opps"),
                                              description: const Text(
                                                  '¡El correo o la contraseña son incorrectos!'))
                                          .show(context);
                                    }
                                  });
                                } catch (e) {
                                  authBloc.setIsLoading(false);
                                  MotionToast.error(
                                          title: const Text("Opps"),
                                          description: const Text(
                                              '¡El correo o la contraseña son incorrectos!'))
                                      .show(context);
                                }
                              }
                            }
                          },
                          label: Text("Eliminar",
                              style: TextStyle(color: Colors.blue)),
                          icon: isloading
                              ? Container(
                                  width: 10,
                                  height: 10,
                                  margin: EdgeInsets.only(left: 5),
                                  child: CircularProgressIndicator(
                                      strokeWidth: 0.8,
                                      valueColor:
                                          new AlwaysStoppedAnimation<Color>(
                                              Colors.blue)))
                              : Container()),
                    ]);
              });
        });
  }

  Widget userCard(
      String placeholder, String item, String hinter, Size media, context) {
    return GestureDetector(
        child: Container(
            width: (media.width > 700)
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width,
            margin:
                const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(width: 1, color: Colors.grey.shade300)),
            child: Row(children: [
              Text(hinter, style: const TextStyle(fontWeight: FontWeight.bold)),
              Expanded(child: Text(" $placeholder")),
              const SizedBox(width: 10),
              const Icon(Icons.create)
            ])),
        onTap: () {
          editDialog(context, hinter, placeholder, item);
        });
  }

  Widget timeField(
      String placeholder, String item, String hinter, Size media, context) {
    TextEditingController ctrlInput = TextEditingController(text: placeholder);
    return Container(
        width: (media.width > 700)
            ? MediaQuery.of(context).size.width / 2
            : MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.grey.shade300)),
        child: DateTimeField(
            controller: ctrlInput,
            onChanged: (value) {
              String date = DateFormat('H:mm').format(value!);
              var newUser = userAuth;
              newUser[item] = date;
              storage.put('userAuth', newUser);
              profileBloc.updateDataUser(newUser['uid'], newUser);
              setState(() {});
            },
            resetIcon: null,
            format: DateFormat('H:mm'),
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.watch_later_outlined),
                focusedBorder: InputBorder.none,
                border: InputBorder.none,
                hintText: hinter),
            onShowPicker: (context, currentValue) async {
              final time = await showTimePicker(
                context: context,
                initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                builder: (context, child) => Localizations.override(
                  context: context,
                  locale: const Locale('es'),
                  child: child,
                ),
              );
              return DateTimeField.convert(time);
            }));
  }

  Future editDialog(BuildContext context, hinter, placeholder, item) {
    TextEditingController ctrlInput = TextEditingController(text: "");
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              title: Text("Editar $hinter"),
              content: TextFormField(
                  controller: ctrlInput,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(7.0)),
                      labelStyle: TextStyle(color: Colors.grey[700]),
                      labelText: placeholder,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 1.0),
                        borderRadius: BorderRadius.circular(7.0),
                      ))),
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
                      if (ctrlInput.text.isNotEmpty) {
                        var newUser = userAuth;
                        newUser[item] = ctrlInput.text;
                        storage.put('userAuth', newUser);
                        profileBloc.updateDataUser(newUser['uid'], newUser);
                        setState(() {});
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Editar',
                        style: TextStyle(color: Colors.blue)))
              ]);
        });
  }

  _passwordRecovery(context, email) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              content: Text(
                  "Se enviará un correo electrónico a $email para realizar el proceso de cambio de contraseña.\nNota: Siempre verifica en correos no deseados o Spam el correo enviado."),
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
                      authBloc.sendPasswordResetEmail(email);
                      Navigator.pop(context);
                    },
                    child: const Text('Enviar',
                        style: TextStyle(color: Colors.blue)))
              ]);
        });
  }
}
