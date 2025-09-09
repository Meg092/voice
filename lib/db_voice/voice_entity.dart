import 'package:intl/intl.dart';

class VoiceEntity {
  int id;
  DateTime createdTime;
  int type;
  int voice;
  String word;
  String voicePath;

  VoiceEntity({
    required this.id,
    required this.createdTime,
    required this.type,
    required this.voice,
    required this.word,
    required this.voicePath,
  });

  factory VoiceEntity.fromMap(Map<String, dynamic> map) {
    return VoiceEntity(
      id: map['id'],
      createdTime: DateTime.parse(map['createdTime']),
      type: map['type'],
      voice: map['voice'],
      word: map['word'],
      voicePath: map['voicePath'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdTime': createdTime.toIso8601String(),
      'type': type,
      'voice': voice,
      'word': word,
      'voicePath': voicePath,
    };
  }

  String get createdTimeString {
    return DateFormat('MM/dd/yyyy HH:mm').format(createdTime);
  }
}