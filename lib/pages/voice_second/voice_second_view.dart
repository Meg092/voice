import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:versatile_voice/pages/voice_first/voice_text_field.dart';
import 'package:versatile_voice/pages/voice_first/voices_view.dart';

import 'voice_second_logic.dart';

class VoiceSecondPage extends GetView<VoiceSecondLogic> {
  @override
  Widget build(BuildContext context) {
    print(controller.voiceIndex);
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Voice text',
        style: TextStyle(color: Colors.white),
      )),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: GetBuilder<VoiceSecondLogic>(builder: (_) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: <Widget>[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: VoiceTextField(
                    maxLength: 500,
                    value: controller.content,
                    maxLines: 10,
                    textStyle: const TextStyle(color: Colors.white),
                    onChange: (v) {
                      controller.content = v;
                    }),
              ).decorated(
                  color: const Color(0xff20212e),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xff414877))),
              VoicesView(selectedIndex: (index) {
                controller.voiceIndex = index;
                controller.update();
              }),
              Container(
                width: double.infinity,
                height: 56,
                child: <Widget>[
                  Image.asset(
                    'assets/icon${controller.voiceIndex}.png',
                    width: 30,
                    height: 30,
                    fit: BoxFit.fill,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    controller.isTransformation
                        ? 'Conversion in progress...'
                        : 'Choose to use',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  )
                ].toRow(mainAxisAlignment: MainAxisAlignment.center),
              )
                  .decorated(
                      borderRadius: BorderRadius.circular(28),
                      gradient: const LinearGradient(
                          colors: [Color(0xff2bd9f8), Color(0xff00ff80)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight))
                  .gestures(onTap: () {
                controller.transformation();
              }),
              Obx(() {
                return Visibility(
                    visible: controller.list.isNotEmpty,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      child: Obx(() {
                        return ListView.builder(
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
                                    style: const TextStyle(color: Colors.white),
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
                                      if (controller.isPlaying.value) {
                                        controller.stopPlaying();
                                      } else {
                                        await controller.stopPlaying();

                                        await controller.startPlay(index);
                                      }
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
                            border: Border.all(color: const Color(0xff414877)))
                        .marginOnly(top: 30));
              }),
            ].toColumn(),
          );
        }).marginAll(15)),
      ),
    );
  }
}
