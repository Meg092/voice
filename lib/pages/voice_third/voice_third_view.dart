import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:styled_widget/styled_widget.dart';

import '../voice_first/voices_view.dart';
import 'voice_third_logic.dart';

class VoiceThirdPage extends GetView<VoiceThirdLogic> {
  Widget recordBtn() {
    Widget item = SizedBox();
    if (controller.isRecording.value) {
    } else {
      item = Container(
        width: double.infinity,
        height: 56,
        child: <Widget>[
          const Text(
            'Long press to start recording',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          )
        ].toRow(mainAxisAlignment: MainAxisAlignment.center),
      ).decorated(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(
              colors: [Color(0xff2bd9f8), Color(0xff00ff80)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight));
    }
    return item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice speaking'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: GetBuilder<VoiceThirdLogic>(init: VoiceThirdLogic(),builder: (_) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: <Widget>[
              Obx(() {
                return Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(28),
                      color: const Color(0xffaeb1d8),
                      gradient: controller.isRecording.value
                          ? null
                          : const LinearGradient(
                              colors: [Color(0xff2bd9f8), Color(0xff00ff80)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight)),
                  child: <Widget>[
                    Obx(() {
                      return controller.isRecording.value
                          ? <Widget>[
                              Image.asset(
                                'assets/img0.png',
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                'Release and stop (${controller.timeDown} seconds)',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              )
                            ].toRow()
                          : const Text(
                              'Long press to start recording',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            );
                    })
                  ].toRow(mainAxisAlignment: MainAxisAlignment.center),
                ).gestures(onLongPress: () {
                  controller.startRecording();
                }, onLongPressEnd: (details) {
                  controller.stopRecording();
                });
              }),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Obx(() {
                  return controller.originalList.isEmpty
                      ? const Center(
                          child: Text(
                            'No data',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.originalList.length,
                          itemBuilder: (_, index) {
                            final entity = controller.originalList[index];
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
                                      await controller.startPlay(0, index);
                                    }
                                  });
                                }),
                                const SizedBox(
                                  width: 10,
                                ),
                                Icon(
                                  controller.selectedList.contains(entity) ? Icons.check_circle : Icons.circle_outlined,
                                  size: 20,
                                  color: controller.selectedList.contains(entity) ? Colors.blue : Colors.grey,
                                ).gestures(onTap: () {
                                  if (controller.selectedList.contains(entity)) {
                                    controller.selectedList.remove(entity);
                                  } else {
                                    controller.selectedList.add(entity);
                                  }
                                  controller.update();
                                })
                              ].toRow(),
                            );
                          });
                }),
              ).decorated(
                  color: const Color(0xff20212e),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xff414877))).marginOnly(top: 30),
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                controller.voiceIndex = controller.fontVoice;
                controller.update();
                if (controller.selectedList.isEmpty) {
                  Fluttertoast.showToast(msg: 'Please select the data to be converted');
                  return;
                }
                for (var item in controller.selectedList) {
                  controller.transformation(item.word);
                }
                controller.selectedList.clear();
                controller.update();
              }),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                child: Obx(() {
                  return controller.transformList.isEmpty
                      ? const Center(
                          child: Text(
                            'No data',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.transformList.length,
                          itemBuilder: (_, index) {
                            final entity = controller.transformList[index];
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
                                      await controller.startPlay(1, index);
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
                  .marginOnly(top: 30)
            ].toColumn(),
          );
        }).marginAll(15)),
      ),
    );
  }
}
