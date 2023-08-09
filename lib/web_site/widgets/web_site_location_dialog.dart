import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class WebSiteLocationDialog extends StatefulWidget {
  final dynamic item;
  const WebSiteLocationDialog({Key? key, required this.item}) : super(key: key);

  @override
  State<WebSiteLocationDialog> createState() => _WebSiteLocationDialogState();
}

class _WebSiteLocationDialogState extends State<WebSiteLocationDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.black87,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          Expanded(
              child: Text(widget.item['place']!,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: Colors.white,
                  shape: const StadiumBorder()),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close, color: Colors.yellow.shade700)),
        ]),
        content: SizedBox(
            width: 400,
            height: 300,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Dirección: ${widget.item["address"]}",
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              Text("Teléfonos: ${widget.item["tel"]}",
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 10),
              Text("Correo: ${widget.item["email"]}",
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 25),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 2,
                        backgroundColor: Colors.yellow.shade700,
                        shape: const StadiumBorder()),
                    onPressed: () {
                      _launchURL(
                          "https://www.google.com/maps/search/?api=1&query=${widget.item['lat']},${widget.item['long']}");
                    },
                    child: SizedBox(
                      width: 150,
                      child: Row(children: const [
                        Icon(Icons.location_on, color: Colors.white),
                        SizedBox(width: 5),
                        Text("Como Llegar",
                            style: TextStyle(color: Colors.white))
                      ]),
                    )),
              ),
            ])));
  }

  _launchURL(String url) async {
    if (await canLaunchUrlString(Uri.encodeFull(url))) {
      await launchUrlString(Uri.encodeFull(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
