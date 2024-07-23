import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused, continued }

class TTSService {
  late FlutterTts _flutterTts;

  TtsState _ttsState = TtsState.stopped;
  bool isCurrentLanguageInstalled = false;

  bool get isPlaying => _ttsState == TtsState.playing;
  bool get isStopped => _ttsState == TtsState.stopped;
  bool get isPaused => _ttsState == TtsState.paused;
  bool get isContinued => _ttsState == TtsState.continued;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  TTSService() {
    initTts();
  }

  void initTts() async {
    _flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    _flutterTts.setStartHandler(() {
      _ttsState = TtsState.playing;
    });

    _flutterTts.setCompletionHandler(() {
      _ttsState = TtsState.stopped;
    });

    _flutterTts.setCancelHandler(() {
      _ttsState = TtsState.stopped;
    });

    _flutterTts.setPauseHandler(() {
      _ttsState = TtsState.paused;
    });

    _flutterTts.setContinueHandler(() {
      _ttsState = TtsState.continued;
    });

    _flutterTts.setErrorHandler((msg) {
      _ttsState = TtsState.stopped;
    });

    await _flutterTts.setVolume(1);
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(0.7);
    await _flutterTts.setLanguage('id-ID');
    if (isAndroid) {
      _flutterTts
          .isLanguageInstalled('id-ID')
          .then((value) => isCurrentLanguageInstalled = (value as bool));
    }
  }

  Future<void> _getDefaultEngine() => _flutterTts.getDefaultEngine;

  Future<void> _getDefaultVoice() => _flutterTts.getDefaultVoice;

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> _setAwaitOptions() async {
    await _flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> stop() async {
    var result = await _flutterTts.stop();
    if (result == 1) _ttsState = TtsState.stopped;
  }

  Future<void> pause() async {
    var result = await _flutterTts.pause();
    if (result == 1) {
      _ttsState = TtsState.paused;
    }
  }
}

final ttsServiceProvider = Provider<TTSService>((ref) {
  return TTSService();
});
