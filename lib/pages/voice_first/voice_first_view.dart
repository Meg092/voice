import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:versatile_voice/pages/voice_first/voices_view.dart';

import 'voice_first_logic.dart';

class VoiceFirstPage extends GetView<VoiceFirstLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: GetBuilder<VoiceFirstLogic>(
                init: VoiceFirstLogic(),
                builder: (_) {
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: <Widget>[
                      VoicesView(selectedIndex: (v) {
                        controller.fontVoice = v;
                        controller.update();
                      }),
                      Container(
                        width: double.infinity,
                        height: 56,
                        child: <Widget>[
                          Image.asset(
                            'assets/icon${controller.fontVoice}.png',
                            width: 30,
                            height: 30,
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text(
                            'Choose to use',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ].toRow(mainAxisAlignment: MainAxisAlignment.center),
                      )
                          .decorated(
                              borderRadius: BorderRadius.circular(28),
                              gradient: const LinearGradient(
                                  colors: [
                                    Color(0xff2bd9f8),
                                    Color(0xff00ff80)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight))
                          .gestures(onTap: () {
                        controller.voiceIndex = controller.fontVoice;
                        controller.update();
                      }),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        child: Obx(() {
                          return controller.list.isEmpty
                              ? const Center(
                                  child: Text(
                                    'No data',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.list.length,
                                  itemBuilder: (_, index) {
                                    final entity = controller.list[index];
                                    return SizedBox(
                                      height: 40,
                                      child: <Widget>[
                                        Image.asset(
                                          'assets/img0.png',
                                          fit: BoxFit.cover,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Expanded(
                                            child: Text(
                                          entity.createdTimeString,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        )),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Obx(() {
                                          return Icon(
                                            !controller.isPlaying.value
                                                ? Icons.play_circle
                                                : (controller.playIndex == index
                                                    ? Icons.pause_circle
                                                    : Icons.play_circle),
                                            size: 20,
                                            color: Colors.white,
                                          ).gestures(onTap: () async {
                                            controller.speak(index);
                                          });
                                        }),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        const Icon(
                                          Icons.download_for_offline_outlined,
                                          size: 20,
                                          color: Colors.white,
                                        ).gestures(onTap: () {
                                          controller.saveFile(entity);
                                        })
                                      ].toRow(),
                                    );
                                  });
                        }),
                      )
                          .decorated(
                              color: const Color(0xff20212e),
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: const Color(0xff414877)))
                          .marginOnly(top: 30)
                    ].toColumn(),
                  );
                }).marginAll(15)),
      ),
    );
  }
}
