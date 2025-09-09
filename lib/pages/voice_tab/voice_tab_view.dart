import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:versatile_voice/pages/voice_first/voice_first_view.dart';
import 'package:versatile_voice/pages/voice_fourth/voice_fourth_view.dart';
import 'package:versatile_voice/pages/voice_second/voice_second_logic.dart';
import 'package:versatile_voice/pages/voice_second/voice_second_view.dart';
import 'package:versatile_voice/pages/voice_third/voice_third_view.dart';

import 'voice_tab_logic.dart';

class VoiceTabPage extends GetView<VoiceTabLogic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: controller.pageController,
        children: [
          VoiceFirstPage(),
          VoiceSecondPage(),
          VoiceThirdPage(),
          VoiceFourthPage()
        ],
      ),
      bottomNavigationBar: Obx(() => _navVoiceBars()),
    );
  }

  Widget _navVoiceBars() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/item0Grey.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          activeIcon: Image.asset(
            'assets/item0Light.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/item1Grey.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          activeIcon: Image.asset(
            'assets/item1Light.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          label: 'Text',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/item2Grey.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          activeIcon: Image.asset(
            'assets/item2Light.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          label: 'Speaking',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/item3Grey.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          activeIcon: Image.asset(
            'assets/item3Light.png',
            fit: BoxFit.cover,
            width: 22,
            height: 22,
          ),
          label: 'Setting',
        ),
      ],
      currentIndex: controller.currentIndex.value,
      onTap: (index) {
        controller.currentIndex.value = index;
        controller.pageController.jumpToPage(index);
        if (index == 0) {
          VoiceSecondLogic firstLogic = Get.find<VoiceSecondLogic>();
          firstLogic.getData();
        }
      },
    );
  }
}
