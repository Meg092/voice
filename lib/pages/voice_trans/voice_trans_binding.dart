import 'voice_trans_logic.dart';
import 'package:get/get.dart';


class VoiceTransBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(
      VoiceTransLogic(),
      permanent: true,
    );
  }
}
