import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:versatile_voice/db_voice/db_voice.dart';
import 'package:versatile_voice/pages/voice_first/all_voices/all_voices_binding.dart';
import 'package:versatile_voice/pages/voice_first/all_voices/all_voices_view.dart';
import 'package:versatile_voice/pages/voice_first/all_voices/voice_tts_config.dart';
import 'package:versatile_voice/pages/voice_first/voice_first_binding.dart';
import 'package:versatile_voice/pages/voice_first/voice_first_view.dart';
import 'package:versatile_voice/pages/voice_fourth/voice_fourth_binding.dart';
import 'package:versatile_voice/pages/voice_fourth/voice_fourth_view.dart';
import 'package:versatile_voice/pages/voice_second/voice_second_binding.dart';
import 'package:versatile_voice/pages/voice_second/voice_second_view.dart';
import 'package:versatile_voice/pages/voice_tab/voice_tab_binding.dart';
import 'package:versatile_voice/pages/voice_tab/voice_tab_view.dart';
import 'package:versatile_voice/pages/voice_third/voice_third_binding.dart';
import 'package:versatile_voice/pages/voice_third/voice_third_view.dart';
import 'package:versatile_voice/pages/voice_trans/voice_trans_binding.dart';
import 'package:versatile_voice/pages/voice_trans/voice_trans_view.dart';


Color primaryColor = const Color(0xff2bd9f8);
Color bgColor = const Color(0xff16171e);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => DBVoice().init());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: Voice,
      initialRoute: '/voice',
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: bgColor,
        colorScheme: ColorScheme.light(
          primary: primaryColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
            type: BottomNavigationBarType.fixed,
            selectedItemColor: primaryColor,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            unselectedItemColor: Colors.white.withAlpha(150),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            elevation: 0,
            backgroundColor: const Color(0xff2f3041)),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
      ),
    );
  }
}
List<GetPage<dynamic>> Voice = [
  GetPage(name: '/voice', page: () => VoiceTransView(), binding: VoiceTransBinding()),
  GetPage(name: '/voice_tab', page: () => VoiceTabPage(), binding: VoiceTabBinding()),
  GetPage(name: '/voice_first', page: () => VoiceFirstPage(), binding: VoiceFirstBinding()),
  GetPage(name: '/voice_second', page: () => VoiceSecondPage(), binding: VoiceSecondBinding()),
  GetPage(name: '/voice_config', page: () => VoiceTtsConfig()),
  GetPage(name: '/voice_third', page: () => VoiceThirdPage(), binding: VoiceThirdBinding()),
  GetPage(name: '/voice_fourth', page: () => VoiceFourthPage(), binding: VoiceFourthBinding()),
  GetPage(name: '/all_voices', page: () => AllVoicesWidget(), binding: AllVoicesBinding()),
];