import 'dart:io';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../db_voice/db_voice.dart';
import '../../db_voice/voice_entity.dart';

class VoiceSecondLogic extends GetxController {
  final FlutterTts flutterTts = FlutterTts();

  final AudioPlayer _audioPlayer = AudioPlayer();

  final DBVoice dbVoice = Get.find<DBVoice>();

  var list = <VoiceEntity>[].obs;

  bool isTransformation = false;

  var isPlaying = false.obs;

  int voiceIndex = 0;
  int playIndex = -1;

  String content = '';

  getData() async {
    final result = await dbVoice.getVoicesAllData();
    list.value = result.where((e) => e.type == 0).toList();
  }

  Future<void> transformation() async {
    if (content.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter some text');
      return;
    }
    isTransformation = true;
    update();

    try {
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final safeFileName = 'tts_$timestamp.${Platform.isAndroid ? "wav" : "caf"}';

      final directory = await getApplicationDocumentsDirectory();
      final ttsDir = Directory(directory.path);
      final filePath = '${ttsDir.path}/$safeFileName';

      List<dynamic> voices = await flutterTts.getVoices;
      if (voices.isNotEmpty) {
        String name = voices[10+voiceIndex]['name'];
        await flutterTts.setVoice({'name': name, "locale": "en-US"});
      }
      final result = await flutterTts.synthesizeToFile(
        content,
        safeFileName,
      );

      if (result == 1) {

        await Future.delayed(const Duration(milliseconds: 500));

        final file = File(filePath);
        if (await file.exists()) {
          await dbVoice.insertVoice(VoiceEntity(
              id: 0,
              createdTime: DateTime.now(),
              type: 0,
              voice: 10+voiceIndex,
              word: content,
              voicePath: filePath));
          Fluttertoast.showToast(msg: 'Transformation successful');
          await Future.delayed(const Duration(milliseconds: 200));
          await getData();
        } else {
          Fluttertoast.showToast(msg: 'Conversion failed. Please try again.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Conversion failed. Please try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Conversion failed. Please try again.');
    } finally {
      isTransformation = false;
      update();
    }

  }

  void saveFile (VoiceEntity entity) async {
    final bytes = await File(entity.voicePath).readAsBytes();
    FlutterFileSaver().writeFileAsBytes(
      fileName: 'Voice${entity.id}.mp3',
      bytes: bytes,
    );
  }

  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        playIndex = -1;
      }
      update();
    });
  }

  Future<void> startPlay(int currentIndex) async {
    try {
      playIndex = currentIndex;
      isPlaying.value = true;
      update();
      await _audioPlayer.setFilePath(list.value[currentIndex].voicePath);
      await _audioPlayer.play();
    } catch (e) {
      print("Play recording error: $e");
    }
  }

  Future<void> stopPlaying() async {
    await _audioPlayer.stop();
    isPlaying.value = false;
    playIndex = -1;
    update();
  }

  @override
  void onInit() async {
    // TODO: implement onInit
    getData();
    await flutterTts.setLanguage('en-US');
    _setupAudioPlayer();
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    flutterTts.stop();
    stopPlaying();
    super.onClose();
  }
}
