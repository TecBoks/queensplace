import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  final Color colorVariable;
  const Loading({Key? key, required this.colorVariable}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: colorVariable,
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Stack(children: const [
          SpinKitCircle(color: Colors.blue, size: 90),
        ])));
  }
}
