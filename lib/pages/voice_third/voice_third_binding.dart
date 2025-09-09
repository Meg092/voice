import 'package:get/get.dart';

import 'voice_third_logic.dart';

class VoiceThirdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VoiceThirdLogic());
  }
}
