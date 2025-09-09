import 'package:get/get.dart';

import 'voice_second_logic.dart';

class VoiceSecondBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VoiceSecondLogic());
  }
}
