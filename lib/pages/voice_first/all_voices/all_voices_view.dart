import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import 'all_voices_logic.dart';

class AllVoicesWidget extends GetView<AllVoicesLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'More Voices',
          style: TextStyle(color: Colors.white),
        ),
        foregroundColor: Colors.white,
      ),
      body: GetBuilder<AllVoicesLogic>(builder: (_) {
        return SafeArea(
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10),
                  itemCount: 15,
                  itemBuilder: (_, index) {
                    return Container(
                      child: <Widget>[
                        Container(
                          width: 62,
                          height: 62,
                          padding: const EdgeInsets.all(2),
                          child: Image.asset(
                            'assets/icon$index.png',
                            fit: BoxFit.fill,
                          ),
                        ).decorated(
                            borderRadius: BorderRadius.circular(31),
                            border: (controller.selectedIndex == index
                                ? Border.all(
                                color: const Color(0xff00d8ff), width: 5)
                                : null)),
                        Text(
                          'Voice ${index + 1}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )
                      ].toColumn(mainAxisAlignment: MainAxisAlignment.center),
                    ).decorated(color: Colors.transparent).gestures(onTap: () {
                      controller.selectedIndex = index;
                      controller.update();
                      Get.back(result: controller.selectedIndex);
                    });
                  }),
            )
                .decorated(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xff414877)),
              color: const Color(0xff20212e),
            )
                .marginAll(15));
      }),
    );
  }
}
