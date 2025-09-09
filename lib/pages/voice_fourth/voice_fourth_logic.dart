
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:versatile_voice/db_voice/db_voice.dart';
import 'package:flutter/material.dart';

class VoiceFourthLogic extends GetxController {

  DBVoice dbVoice = Get.find<DBVoice>();

  var appVersion = '1.0.0'.obs;

  cleanData(int style) async {
    Get.dialog(AlertDialog(
      title: const Text('Warm reminder'),
      content: Text(
          'Do you want to clean all ${style == 0 ? 'Original' : 'Transformed'} records?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.black),
          ),
        ),
        TextButton(
          onPressed: () async {
            if (style == 0) {
              await dbVoice.cleanOriginalData();
            } else {
              await dbVoice.cleanTransformationData();
            }
            Get.back();
          },
          child: const Text(
            'OK',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ));
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    var info = await PackageInfo.fromPlatform();
    appVersion.value = info.version;
    super.onInit();
  }

}
