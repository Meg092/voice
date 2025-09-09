import 'package:get/get.dart';

import 'all_voices_logic.dart';

class AllVoicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllVoicesLogic());
  }
}