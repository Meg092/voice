import 'package:get/get.dart';

import '../voice_first/voice_first_logic.dart';
import '../voice_fourth/voice_fourth_logic.dart';
import '../voice_second/voice_second_logic.dart';
import '../voice_third/voice_third_logic.dart';
import 'voice_tab_logic.dart';

class VoiceTabBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VoiceTabLogic());
    Get.lazyPut(() => VoiceFirstLogic());
    Get.lazyPut(() => VoiceSecondLogic());
    Get.lazyPut(() => VoiceThirdLogic());
    Get.lazyPut(() => VoiceFourthLogic());
  }
}
