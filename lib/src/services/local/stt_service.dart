import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

enum SttState { listening, notListening }

class SpeechToTextService {
  late stt.SpeechToText _speechToText;
  SttState _sttState = SttState.notListening;
  bool _speechEnabled = false;
  String _lastWords = '';

  bool get isListening => _sttState == SttState.listening;
  bool get isNotListening => _sttState == SttState.notListening;
  String get lastWords => _lastWords;
  bool get speechEnabled => _speechEnabled;

  SpeechToTextService() {
    _initSpeech();
  }

  void _initSpeech() async {
    _speechToText = stt.SpeechToText();
    _speechEnabled = await _speechToText.initialize();
    _sttState = SttState.notListening;
  }

  Future<void> startListening(
      {required Function(String text) onResult,
      String localeId = 'id_ID'}) async {
    if (!_speechEnabled) return;
    _sttState = SttState.listening;
    await _speechToText.listen(
      onResult: (result) {
        _lastWords = result.recognizedWords;
        onResult(_lastWords);
      },
      localeId: localeId,
    );
  }

  Future<void> stopListening() async {
    if (_sttState == SttState.notListening) return;
    await _speechToText.stop();
    _lastWords = '';
    _sttState = SttState.notListening;
  }
}

final speechToTextServiceProvider = Provider<SpeechToTextService>((ref) {
  return SpeechToTextService();
});
