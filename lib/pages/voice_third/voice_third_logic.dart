import 'dart:async';
import 'dart:io';

import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import '../../db_voice/db_voice.dart';
import '../../db_voice/voice_entity.dart';

class VoiceThirdLogic extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final FlutterTts flutterTts = FlutterTts();

  stt.SpeechToText _speech = stt.SpeechToText();

  int timeDown = 60;

  Timer? _timer;

  DBVoice dbVoice = Get.find<DBVoice>();
  var originalList = <VoiceEntity>[].obs;
  var transformList = <VoiceEntity>[].obs;

  List<VoiceEntity> selectedList = <VoiceEntity>[];

  var isPlaying = false.obs;

  bool _isListening = false;

  var isRecording = false.obs;
  final AudioRecorder _audioRecorder = AudioRecorder();

  int voiceIndex = 0;
  int fontVoice = 0;
  int playIndex = -1;
  int playListView = -1;

  String _text = '';

  getData() async {
    final result = await dbVoice.getVoicesAllData();
    originalList.value = result.where((e) => e.type == 1).toList();
    transformList.value = result.where((e) => e.type == 2).toList();
    print(originalList);
  }

  startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      timeDown--;
      update();
      if (timeDown <= 0) {
        stopRecording();
      }
    });
  }

  stopTimer() async {
    _timer?.cancel();
    _timer = null;
    timeDown = 60;
    await stopPlaying();
    update();
  }

  void _speechListen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        _isListening = true;
        _speech.listen(
          onResult: (result) {
            _text = result.recognizedWords;
            if (result.hasConfidenceRating && result.confidence > 0) {
              // _confidence = result.confidence;
            }
          },
          localeId: 'en_US',
        );
      }
    } else {
      _isListening = false;
      _speech.stop();
    }
  }

  Future<bool> _requestPermission() async {
    final status = await Permission.microphone.request();
    return status == PermissionStatus.granted;
  }

  Future<void> startRecording() async {
    if (!await _requestPermission()) {
      Fluttertoast.showToast(msg: 'Please grant the microphone permission.');
      return;
    }
    try {
      if (await _audioRecorder.hasPermission()) {
        bool available = await _speech.initialize(
          onStatus: (status) {
            print('SpeechState: $status');
            if (status == 'done') {
              _isListening = false;
            }
          },
          onError: (error) {
            print('SpeechError: $error');
            _isListening = false;
          },
        );
        if (!available) {
          Fluttertoast.showToast(
              msg: 'The device does not support voice recognition.');
          return;
        }
        startTimer();
        _speechListen();
        final directory = await getApplicationDocumentsDirectory();
        final recordingsDir = Directory('${directory.path}/recordings');

        if (!await recordingsDir.exists()) {
          await recordingsDir.create(recursive: true);
        }

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final path = '${recordingsDir.path}/recording_$timestamp.m4a';

        await _audioRecorder
            .start(const RecordConfig(encoder: AudioEncoder.wav), path: path);
        isRecording.value = true;
      } else {
        Fluttertoast.showToast(
            msg:
                'The microphone permission has been denied. Please go to settings to enable the recording permission for this app.');
      }
    } catch (e) {
      print("Recording error: $e");
      Fluttertoast.showToast(msg: 'Recording error: $e');
    }
  }

  Future<void> stopRecording() async {
    if (timeDown == 60) {
      timeDown = 60;
      isRecording.value = false;
      _speech.stop();
      stopTimer();
      return;
    }
    timeDown = 60;
    update();
    _speech.stop();
    stopTimer();
    try {
      final path = await _audioRecorder.stop();
      isRecording.value = false;
      if (path != null) {
        await dbVoice.insertVoice(VoiceEntity(
            id: 0,
            createdTime: DateTime.now(),
            type: 1,
            voice: 10 + voiceIndex,
            word: _text,
            voicePath: path));
        _text = '';
        await getData();
      }
    } catch (e) {
      print("Stop recording error: $e");
    }
  }

  Future<void> startPlay(int currentList, int currentIndex) async {
    final list = currentList == 0 ? originalList : transformList;
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
    playListView = -1;
    update();
  }

  void _setupAudioPlayer() {
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        isPlaying.value = false;
        playIndex = -1;
        playListView = -1;
      }
      update();
    });
  }

  Future<void> transformation(String content) async {
    if (content.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter some text');
      return;
    }

    update();

    try {
      if (await Permission.storage.isDenied) {
        await Permission.storage.request();
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final safeFileName =
          'tts_$timestamp.${Platform.isAndroid ? "wav" : "caf"}';

      final directory = await getApplicationDocumentsDirectory();
      final ttsDir = Directory(directory.path);
      final filePath = '${ttsDir.path}/$safeFileName';

      List<dynamic> voices = await flutterTts.getVoices;
      if (voices.isNotEmpty) {
        String name = voices[10 + voiceIndex]['name'];
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
              type: 2,
              voice: 10 + voiceIndex,
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
    } finally {}
  }

  void saveFile(VoiceEntity entity) async {
    final bytes = await File(entity.voicePath).readAsBytes();
    FlutterFileSaver().writeFileAsBytes(
      fileName: 'Voice${entity.id}.mp3',
      bytes: bytes,
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    _requestPermission();
    _speech.initialize();
    getData();
    _setupAudioPlayer();
    super.onInit();
  }



  @override
  void onClose() {
    // TODO: implement onClose
    _speech.stop();
    stopPlaying();
    stopRecording();
    stopTimer();
    super.onClose();
  }
}
