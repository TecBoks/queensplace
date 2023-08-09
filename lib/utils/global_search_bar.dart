import 'package:flutter/material.dart';

class GlobalSearchBar extends StatefulWidget {
  final Function changeFilter;
  final String title;
  final Widget icon;
  const GlobalSearchBar(
      {Key? key,
      required this.changeFilter,
      required this.icon,
      required this.title})
      : super(key: key);

  @override
  State<GlobalSearchBar> createState() => _GlobalSearchBarState();
}

class _GlobalSearchBarState extends State<GlobalSearchBar> {
  TextEditingController controller = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      Expanded(
          child: Container(
        margin: const EdgeInsets.only(left: 10, top: 10, bottom: 4),
        decoration: BoxDecoration(
            color: Colors.grey[200], borderRadius: BorderRadius.circular(5)),
        child: Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.grey),
            child: TextField(
                controller: controller,
                onChanged: (value) {
                  widget.changeFilter(value);
                },
                decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: GestureDetector(
                        child: const Icon(Icons.close),
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          WidgetsBinding.instance
                              .addPostFrameCallback((_) => controller.clear());
                          widget.changeFilter('');
                        }),
                    prefixIcon: const Icon(Icons.search),
                    hintText: widget.title))),
      )),
      widget.icon
    ]);
  }
}
