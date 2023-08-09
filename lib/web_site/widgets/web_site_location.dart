import 'package:bequeen/web_site/widgets/web_site_location_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:flutter_svg/flutter_svg.dart';

class WebSiteLocation extends StatefulWidget {
  const WebSiteLocation({Key? key}) : super(key: key);

  @override
  State<WebSiteLocation> createState() => _WebSiteLocationState();
}

class _WebSiteLocationState extends State<WebSiteLocation> {
  late final MapController _mapController = MapController();
  double zoom = 17.0;
  List items = [
    {
      "lat": "15.5175408",
      "long": "-88.0290048",
      "place": "Puerto Cortes, San Pedro Sula",
      "address":
          "Bo. Los Andes, 12 y 13 Calle, 11 Ave, Casa23 Color Gris, San Pedro Sula, Cortes",
      "tel": "+504 9421-253",
      "email": ""
    }
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size media = MediaQuery.of(context).size;
    return Column(children: [
      const SizedBox(height: 20),
      const Center(
          child: Text("Ubicación",
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
      const Center(
          child: Text(
              "#queenplace #bqueen #hairstudio #hairstyle Un lugar de reinas para reinas 👸",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22))),
      const SizedBox(height: 15),
      Center(
          child: Container(
              margin: const EdgeInsets.only(right: 10),
              width: (media.width > 800)
                  ? MediaQuery.of(context).size.width / 1.4
                  : MediaQuery.of(context).size.width / 1.1,
              height: 400,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(30)),
              child: Stack(alignment: const Alignment(0.95, 0.75), children: [
                FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                        center: LatLng(15.5175408, -88.0290048), zoom: zoom),
                    layers: [
                      TileLayerOptions(
                          urlTemplate:
                              "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                          subdomains: ['a', 'b', 'c']),
                      MarkerLayerOptions(
                          markers: items.map((entry) {
                        return Marker(
                            width: 100,
                            height: 100,
                            point: LatLng(double.parse(entry["lat"]),
                                double.parse(entry["long"])),
                            builder: (ctx) => GestureDetector(
                                child: const Icon(Icons.location_on,
                                    color: Colors.red, size: 25),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return WebSiteLocationDialog(
                                            item: entry);
                                      });
                                }));
                      }).toList()),
                    ]),
                Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                  InputChip(
                      backgroundColor: Colors.green,
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            return WebSiteLocationDialog(item: items[0]);
                          }),
                      elevation: 2,
                      label: const Text('¿Como Llegar?',
                          style: TextStyle(color: Colors.white))),
                  const SizedBox(height: 6),
                  FloatingActionButton(
                      heroTag: "btn2",
                      backgroundColor: Colors.yellow.shade800,
                      child: const Icon(Icons.location_searching_outlined,
                          color: Colors.white),
                      onPressed: () {
                        setState(() {
                          _mapController.move(
                              LatLng(15.5175408, -88.0290048), 17);
                        });
                      }),
                  const SizedBox(height: 6),
                  FloatingActionButton(
                      heroTag: "btn3",
                      backgroundColor: Colors.yellow.shade800,
                      child: const Icon(Icons.zoom_in, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          if (zoom < 18) {
                            zoom = zoom + 1.0;
                            _mapController.move(
                                LatLng(15.5175408, -88.0290048), zoom);
                          }
                        });
                      }),
                  const SizedBox(height: 6),
                  FloatingActionButton(
                      heroTag: "btn4",
                      backgroundColor: Colors.yellow.shade800,
                      child: const Icon(Icons.zoom_out, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          if (zoom > 2) {
                            zoom = zoom - 1.0;
                            _mapController.move(
                                LatLng(15.5175408, -88.0290048), zoom);
                          }
                        });
                      }),
                  const SizedBox(height: 10),
                ])
              ]))),
      const SizedBox(height: 20),
    ]);
  }
}
