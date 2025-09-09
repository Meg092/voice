import 'package:flutter/material.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:get/get.dart';

class VoicesView extends StatefulWidget {
  const VoicesView({this.selectedIndex, super.key});

  final Function(int selectedIndex)? selectedIndex;

  @override
  State<VoicesView> createState() => _VoicesViewState();
}

class _VoicesViewState extends State<VoicesView> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // height: 100,
      child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10),
          itemCount: 6,
          itemBuilder: (_, index) {
            return Container(
              child: <Widget>[
                Container(
                  width: 62,
                  height: 62,
                  padding: const EdgeInsets.all(2),
                  child: Image.asset(
                    index == 5 ? 'assets/more.png' : 'assets/icon$index.png',
                    fit: BoxFit.fill,
                  ),
                ).decorated(
                    borderRadius: BorderRadius.circular(31),
                    border: selectedIndex != 5
                        ? (selectedIndex == index
                            ? Border.all(
                                color: const Color(0xff00d8ff), width: 5)
                            : null)
                        : null),
                Text(
                  index == 5 ? 'More' : 'Voice ${index + 1}',
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                )
              ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
            ).decorated(color: Colors.transparent).gestures(onTap: () {
              if (index == 5) {
                Get.toNamed('/all_voices',arguments:  selectedIndex)?.then((v) {
                  setState(() {
                    selectedIndex = v;
                    widget.selectedIndex?.call(v);
                  });
                });
              } else {
                setState(() {
                  selectedIndex = index;
                  widget.selectedIndex?.call(index);
                });
              }
            });
          }),
    );
  }
}
