import 'package:get/get.dart';

import 'voice_first_logic.dart';

class VoiceFirstBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VoiceFirstLogic());
  }
}
