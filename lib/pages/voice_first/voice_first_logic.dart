import 'dart:io';

import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:versatile_voice/db_voice/db_voice.dart';

import '../../db_voice/voice_entity.dart';

class VoiceFirstLogic extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final FlutterTts flutterTts = FlutterTts();

  DBVoice dbVoice = Get.find<DBVoice>();
  var list = <VoiceEntity>[].obs;

  var isPlaying = false.obs;

  int voiceIndex = 0;
  int fontVoice = 0;
  int playIndex = -1;

  void getData() async {
    final result = await dbVoice.getVoicesAllData();
    list.value = result;
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

  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        playIndex = -1;
      }
      update();
    });
  }

  void saveFile(VoiceEntity entity) async {
    final bytes = await File(entity.voicePath).readAsBytes();
    FlutterFileSaver().writeFileAsBytes(
      fileName: 'Voice${entity.id}.mp3',
      bytes: bytes,
    );
  }

  speak(int currentIndex) async {
    final item = list.value[currentIndex];

    stopPlaying();
    await flutterTts.stop();
    playIndex = -1;
    isPlaying.value = false;
    update();

    playIndex = currentIndex;
    isPlaying.value = true;
    update();
    if (fontVoice == voiceIndex) {
      await flutterTts.setLanguage('en-US');
      List<dynamic> voices = await flutterTts.getVoices;
      if (voices.isNotEmpty) {
        String name = voices[10 + voiceIndex]['name'];
        await flutterTts.setVoice({'name': name, "locale": "en-US"});
      }
      flutterTts.speak(item.word);
    } else {
      if (item.type == 1) {
        startPlay(currentIndex);
      } else {
        await flutterTts.setLanguage('en-US');
        List<dynamic> voices = await flutterTts.getVoices;
        if (voices.isNotEmpty) {
          String name = voices[item.voice]['name'];
          await flutterTts.setVoice({'name': name, "locale": "en-US"});
        }
        flutterTts.speak(item.word);
      }
    }
  }

  _ttsSetup() async {
    flutterTts.setStartHandler(() {
      print("Playing start");
      isPlaying.value = true;
      update();
    });

    flutterTts.setCompletionHandler(() {
      print("Playing complete");
      isPlaying.value = false;
      playIndex = -1;
      update();
    });

    flutterTts.setErrorHandler((msg) {
      print("Playing error: $msg");
      isPlaying.value = false;
      playIndex = -1;
      update();
    });

    flutterTts.setCancelHandler(() {
      print("Playing cancel");
      isPlaying.value = false;
      playIndex = -1;
      update();
    });

  }

  @override
  void onInit() {
    // TODO: implement onInit
    getData();
    _setupAudioPlayer();
    _ttsSetup();
    super.onInit();
  }
}
