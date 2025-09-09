import 'voice_trans_logic.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';
class VoiceTransView extends GetView<VoiceTransLogic> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(
          () => controller.kris.value
              ? const CircularProgressIndicator(color: Colors.white)
              : buildError(),
        ),
      ),
    );
  }

  Widget buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              controller.jtriy();
            },
            icon: const Icon(
              Icons.restart_alt,
              size: 50,
            ),
          ),
        ],
      ),
    );
  }
}
