import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:motion_toast/motion_toast.dart';

class WebSiteContactUs extends StatefulWidget {
  const WebSiteContactUs({Key? key}) : super(key: key);

  @override
  State<WebSiteContactUs> createState() => _WebSiteContactUsState();
}

class _WebSiteContactUsState extends State<WebSiteContactUs> {
  TextEditingController ctrlName = TextEditingController();
  TextEditingController ctrlPhone = TextEditingController();
  TextEditingController ctrlEmail = TextEditingController();
  TextEditingController ctrlSubject = TextEditingController();
  TextEditingController ctrlMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Column(children: [
      const SizedBox(height: 20),
      const Center(
          child: Text("Contactanos",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold))),
      Center(
          child: Container(
              width: 80,
              height: 10,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white))),
      const SizedBox(height: 20),
      Container(
          width: (media.width > 800)
              ? MediaQuery.of(context).size.width / 2
              : double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            TextField(
                controller: ctrlName,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "* Nombre:",
                    hintStyle: TextStyle(color: Colors.white),
                    fillColor: Color.fromRGBO(56, 57, 57, 1),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1)))),
            const SizedBox(height: 10),
            TextField(
                controller: ctrlEmail,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "* Correo:",
                    fillColor: Color.fromRGBO(56, 57, 57, 1),
                    hintStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1)))),
            const SizedBox(height: 10),
            TextField(
                controller: ctrlPhone,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "Teléfono / Celular:",
                    fillColor: Color.fromRGBO(56, 57, 57, 1),
                    hintStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1)))),
            const SizedBox(height: 10),
            TextField(
                controller: ctrlSubject,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "* Asunto:",
                    fillColor: Color.fromRGBO(56, 57, 57, 1),
                    hintStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1)))),
            const SizedBox(height: 10),
            TextField(
                controller: ctrlMessage,
                maxLines: 5,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    filled: true,
                    hintText: "* Mensaje:",
                    fillColor: Color.fromRGBO(56, 57, 57, 1),
                    hintStyle: TextStyle(color: Colors.white),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 2)),
                    enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black, width: 1)))),
            const SizedBox(height: 10),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    elevation: 2,
                    backgroundColor: Colors.yellow.shade800,
                    shape: const StadiumBorder()),
                onPressed: () {
                  if (ctrlName.text.isEmpty ||
                      ctrlEmail.text.isEmpty ||
                      ctrlMessage.text.isEmpty ||
                      ctrlSubject.text.isEmpty) {
                    MotionToast.error(
                            title: const Text("Opps"),
                            description: const Text(
                                '¡Los campos con (*) son obligatorios!'))
                        .show(context);
                  } else {
                    sendEmail(ctrlName.text, ctrlEmail.text, ctrlPhone.text,
                        ctrlSubject.text, ctrlMessage.text);
                  }
                },
                label: const SizedBox(
                    height: 45,
                    width: 300,
                    child: Center(
                      child:
                          Text("Enviar", style: TextStyle(color: Colors.white)),
                    )),
                icon: const Icon(Icons.email, color: Colors.white))
          ])),
      const SizedBox(height: 20),
    ]);
  }

  sendEmail(
      String name, String email, String phone, String subject, String message) {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    http.post(url,
        body: json.encode({
          "service_id": "service_x2rpc5s",
          "template_id": "template_k9bkjyb",
          "user_id": "i89Kpi7Nh21GerqeD",
          "template_params": {
            "web_page": "bequeenhn.com",
            "company": "Queen's Place WEB",
            "to_email": "queenplacesps@gmail.com",
            "user_name": name,
            "user_email": email,
            "user_phone": (phone.isEmpty) ? "No Proporcionado" : phone,
            "user_subject": subject,
            "user_message": message
          },
          "accessToken": "LkRF3F7ZXVWRhsby5rAPC"
        }),
        headers: {'content-type': 'application/json'}).then((response) {
      if (response.statusCode == 200) {
        MotionToast.success(
                title: const Text("Opps"),
                description: const Text('¡Correo enviado con éxito!'))
            .show(context);
        setState(() {
          ctrlName = TextEditingController(text: "");
          ctrlEmail = TextEditingController(text: "");
          ctrlPhone = TextEditingController(text: "");
          ctrlSubject = TextEditingController(text: "");
          ctrlMessage = TextEditingController(text: "");
        });
      } else {
        MotionToast.info(
                title: const Text("Opps"),
                description: const Text('¡No se pudo enviar el correo!'))
            .show(context);
      }
    });
  }
}
