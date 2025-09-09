import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'voice_fourth_logic.dart';

class VoiceFourthPage extends GetView<VoiceFourthLogic> {
  Widget _item(int index, BuildContext context) {
    final titles = [
      'Clean original audio',
      'Clean transformed audio',
      'About app'
    ];
    return Container(
      color: Colors.transparent,
      height: 40,
      child: <Widget>[
        Text(
          titles[index],
          style: const TextStyle(color: Colors.white),
        ),
        index == 2
            ? Obx(() {
                return Text(
                  controller.appVersion.value,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                );
              })
            : const Icon(
                Icons.keyboard_arrow_right,
                size: 20,
                color: Colors.grey,
              )
      ].toRow(mainAxisAlignment: MainAxisAlignment.spaceBetween),
    ).gestures(onTap: () {
      switch (index) {
        case 0:
          controller.cleanData(0);
          break;
        case 1:
          controller.cleanData(1);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Setting"),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              child: <Widget>[
                _item(0, context),
                _item(1, context),
                _item(2, context)
              ].toColumn(
                  separator: Divider(
                height: 15,
                color: Colors.grey[100],
              )),
            ).decorated(
                color: const Color(0xff20212e), borderRadius: BorderRadius.circular(12))
          ].toColumn(),
        ).marginAll(15)),
      ),
    );
  }
}
