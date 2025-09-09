import 'package:get/get.dart';

import 'voice_fourth_logic.dart';

class VoiceFourthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VoiceFourthLogic());
  }
}
