import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart' as ap;
import 'package:audioplayers/audioplayers.dart';
import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/services/local/local.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  TTSService get ttsService => ref.read(ttsServiceProvider);

  @override
  void initState() {
    ttsService.speak('Halaman Dashboard');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.scaffold,
      body: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: ExcludeSemantics(
              child: Assets.images.elipse.image(
                height: context.screenHeightPercentage(0.4),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Column(
                  children: [
                    Gap.h16,
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Assets.svgs.logoPrimary.svg(
                            semanticsLabel: "DiversID Logo",
                          ),
                        ),
                      ],
                    ),
                    Gap.h64,
                    Semantics(
                      button: true,
                      label: 'Menu Informasi Pribadi Terisi',
                      // label: 'Informasi Pribadi Wajib Di-isi',
                      // label: 'Informasi Pribadi Menunggu Verifikasi',
                      // label: 'Informasi Pribadi Perlu Diperbarui',
                      // label: 'Informasi Pribadi Ditolak',
                      // label: 'Informasi Pribadi Opsional',
                      child: MenuDashboardWidget(
                        title: "Informasi Pribadi",
                        svg: Assets.icons.personalInformation,
                        status: MenuDashboardStatus.verified,
                        onTap: () {
                          context.goNamed(Routes.inputPersonalInfo1.name);
                        },
                      ),
                    ),
                    Gap.h8,
                    Semantics(
                      button: true,
                      label:
                          'Menu Verifikasi KTP Dengan Status Menunggu Verifikasi',
                      child: MenuDashboardWidget(
                        title: "Verifikasi KTP",
                        svg: Assets.icons.ktpVerification,
                        status: MenuDashboardStatus.waiting,
                        onTap: () {},
                      ),
                    ),
                    Gap.h8,
                    Semantics(
                      button: true,
                      label: 'Menu Verifikasi Email & Nomor HP Wajib Di-isi',
                      child: MenuDashboardWidget(
                        title: "Verifikasi Email & Nomor HP",
                        svg: Assets.icons.otp,
                        status: MenuDashboardStatus.required,
                        onTap: () =>
                            context.goNamed(Routes.inputPhoneNumber.name),
                      ),
                    ),
                    Gap.h8,
                    Semantics(
                      button: true,
                      label: 'Menu Verifikasi Alamat Opsional',
                      child: MenuDashboardWidget(
                        title: "Verifikasi Alamat",
                        svg: Assets.icons.address,
                        status: MenuDashboardStatus.optional,
                        onTap: () {
                          context.goNamed(Routes.inputAddress.name);
                        },
                      ),
                    ),
                    Gap.h8,
                    Semantics(
                      button: true,
                      label:
                          'Menu Verifikasi Biometrik Wajib Dengan Status Ditolak',
                      child: MenuDashboardWidget(
                        title: "Voice Biometric",
                        svg: Assets.icons.voiceBiometric,
                        status: MenuDashboardStatus.rejected,
                        onTap: () {},
                      ),
                    ),
                    Gap.h8,
                    Semantics(
                      button: true,
                      label:
                          'Menu Informasi Tambahan Dengan Status Perlu Diperbarui',
                      child: MenuDashboardWidget(
                        title: "Informasi Tambahan",
                        svg: Assets.icons.additionalInfo,
                        onTap: () {
                          context.goNamed(Routes.inputAdditionalInfo.name);
                        },
                        status: MenuDashboardStatus.needsUpdate,
                      ),
                    ),
                    Gap.h8,
                    Expanded(
                      child: Center(
                        child: Semantics(
                          button: true,
                          label: 'Tekan untuk memberikan Masukan',
                          child: GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const FlutterTTSPage(),
                              //   ),
                              // );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => const MyHomePage(),
                              //   ),
                              // );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RecorderPage(),
                                ),
                              );
                            },
                            child: ExcludeSemantics(
                              child: SizedBox(
                                height: SizeApp.h48,
                                child: Center(
                                  child: Text(
                                    'Ada Masukan? Hubungi Kami',
                                    style: TypographyApp.text1.bold.primary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum MenuDashboardStatus {
  verified,
  waiting,
  optional,
  rejected,
  needsUpdate,
  required,
}

class MenuDashboardWidget extends StatelessWidget {
  final String title;
  final MenuDashboardStatus status;
  final VoidCallback? onTap;
  final SvgGenImage svg;
  const MenuDashboardWidget({
    super.key,
    required this.title,
    this.status = MenuDashboardStatus.required,
    this.onTap,
    required this.svg,
  });

  String get statusText {
    switch (status) {
      case MenuDashboardStatus.verified:
        return 'Verifikasi Sukses';
      case MenuDashboardStatus.waiting:
        return 'Menunggu Verifikasi';
      case MenuDashboardStatus.optional:
        return 'Opsional';
      case MenuDashboardStatus.rejected:
        return 'Verifikasi Ditolak';
      case MenuDashboardStatus.needsUpdate:
        return 'Perlu Diperbarui';
      case MenuDashboardStatus.required:
        return 'Wajib';
      default:
        return 'Wajib';
    }
  }

  Widget get icon {
    switch (status) {
      case MenuDashboardStatus.verified:
        return const Icon(
          CupertinoIcons.check_mark,
          color: ColorApp.white,
          size: 12,
        );
      case MenuDashboardStatus.waiting:
        return const Icon(
          CupertinoIcons.clock,
          color: ColorApp.white,
          size: 12,
        );
      case MenuDashboardStatus.optional:
        return const SizedBox(
          height: 12,
          width: 12,
        );
      case MenuDashboardStatus.rejected:
        return const Icon(
          CupertinoIcons.xmark,
          color: ColorApp.white,
          size: 12,
        );
      case MenuDashboardStatus.needsUpdate:
        return const Icon(
          CupertinoIcons.arrow_2_circlepath,
          color: ColorApp.white,
          size: 12,
        );
      case MenuDashboardStatus.required:
        return const Icon(
          CupertinoIcons.exclamationmark,
          color: ColorApp.white,
          size: 12,
        );
      default:
        return const Icon(
          CupertinoIcons.exclamationmark,
          color: ColorApp.white,
          size: 12,
        );
    }
  }

  Color get iconColor {
    switch (status) {
      case MenuDashboardStatus.verified:
        return ColorApp.primary;
      case MenuDashboardStatus.waiting:
        return ColorApp.yellow;
      case MenuDashboardStatus.optional:
        return ColorApp.lightPurple;
      case MenuDashboardStatus.rejected:
        return ColorApp.red;
      case MenuDashboardStatus.needsUpdate:
        return ColorApp.yellow;
      case MenuDashboardStatus.required:
        return ColorApp.purple;
      default:
        return ColorApp.purple;
    }
  }

  Color get statusTextColor {
    switch (status) {
      case MenuDashboardStatus.verified:
        return ColorApp.primary;
      case MenuDashboardStatus.waiting:
        return ColorApp.grey;
      case MenuDashboardStatus.optional:
        return ColorApp.grey;
      case MenuDashboardStatus.rejected:
        return ColorApp.red;
      case MenuDashboardStatus.needsUpdate:
        return ColorApp.red;
      case MenuDashboardStatus.required:
        return ColorApp.red;
      default:
        return ColorApp.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ExcludeSemantics(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            color: ColorApp.white,
            boxShadow: ColorApp.shadow,
          ),
          padding: EdgeInsets.all(SizeApp.w16),
          child: Row(
            children: [
              svg.svg(width: 40, color: ColorApp.primary),
              Gap.w16,
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TypographyApp.text1.bold.black,
                  ),
                  Text(
                    statusText,
                    style: TypographyApp.subText1.copyWith(
                      color: statusTextColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.r),
                  color: iconColor,
                ),
                padding: EdgeInsets.all(SizeApp.w4),
                child: icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult, localeId: 'ID-id');
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Text(
                  // If listening is active show the recognized words
                  _speechToText.isListening
                      ? _lastWords
                      // If listening isn't active but could be tell the user
                      // how to start it, otherwise indicate that speech
                      // recognition is not yet ready or not supported on
                      // the target device
                      : _speechEnabled
                          ? 'Tap the microphone to start listening...'
                          : 'Speech not available',
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
            // If not yet listening for speech start, otherwise stop
            _speechToText.isNotListening ? _startListening : _stopListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}

mixin AudioRecorderMixin {
  Future<void> recordFile(AudioRecorder recorder, RecordConfig config) async {
    final path = await _getPath();

    await recorder.start(config, path: path);
  }

  Future<void> recordStream(AudioRecorder recorder, RecordConfig config) async {
    final path = await _getPath();

    final file = File(path);

    final stream = await recorder.startStream(config);

    stream.listen(
      (data) {
        // ignore: avoid_print
        print(
          recorder.convertBytesToInt16(Uint8List.fromList(data)),
        );
        file.writeAsBytesSync(data, mode: FileMode.append);
      },
      // ignore: avoid_print
      onDone: () {
        // ignore: avoid_print
        print('End of stream. File written to $path.');
      },
    );
  }

  void downloadWebData(String path) {}

  Future<String> _getPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return p.join(
      dir.path,
      'audio_${DateTime.now().millisecondsSinceEpoch}.m4a',
    );
  }
}

class AudioPlayer extends StatefulWidget {
  /// Path from where to play recorded audio
  final String source;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;

  const AudioPlayer({
    super.key,
    required this.source,
    required this.onDelete,
  });

  @override
  AudioPlayerState createState() => AudioPlayerState();
}

class AudioPlayerState extends State<AudioPlayer> {
  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  final _audioPlayer = ap.AudioPlayer()..setReleaseMode(ReleaseMode.stop);
  late StreamSubscription<void> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;
  Duration? _position;
  Duration? _duration;

  @override
  void initState() {
    _playerStateChangedSubscription =
        _audioPlayer.onPlayerComplete.listen((state) async {
      await stop();
    });
    _positionChangedSubscription = _audioPlayer.onPositionChanged.listen(
      (position) => setState(() {
        _position = position;
      }),
    );
    _durationChangedSubscription = _audioPlayer.onDurationChanged.listen(
      (duration) => setState(() {
        _duration = duration;
      }),
    );

    _audioPlayer.setSource(_source);

    super.initState();
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _buildControl(),
                _buildSlider(constraints.maxWidth),
                IconButton(
                  icon: const Icon(Icons.delete,
                      color: Color(0xFF73748D), size: _deleteBtnSize),
                  onPressed: () {
                    if (_audioPlayer.state == ap.PlayerState.playing) {
                      stop().then((value) => widget.onDelete());
                    } else {
                      widget.onDelete();
                    }
                  },
                ),
              ],
            ),
            Text('${_duration ?? 0.0}'),
          ],
        );
      },
    );
  }

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_audioPlayer.state == ap.PlayerState.playing) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_audioPlayer.state == ap.PlayerState.playing) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlider(double widgetWidth) {
    bool canSetValue = false;
    final duration = _duration;
    final position = _position;

    if (duration != null && position != null) {
      canSetValue = position.inMilliseconds > 0;
      canSetValue &= position.inMilliseconds < duration.inMilliseconds;
    }

    double width = widgetWidth - _controlSize - _deleteBtnSize;
    width -= _deleteBtnSize;

    return SizedBox(
      width: width,
      child: Slider(
        activeColor: Theme.of(context).primaryColor,
        inactiveColor: Theme.of(context).colorScheme.secondary,
        onChanged: (v) {
          if (duration != null) {
            final position = v * duration.inMilliseconds;
            _audioPlayer.seek(Duration(milliseconds: position.round()));
          }
        },
        value: canSetValue && duration != null && position != null
            ? position.inMilliseconds / duration.inMilliseconds
            : 0.0,
      ),
    );
  }

  Future<void> play() => _audioPlayer.play(_source);

  Future<void> pause() async {
    await _audioPlayer.pause();
    setState(() {});
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    setState(() {});
  }

  Source get _source =>
      kIsWeb ? ap.UrlSource(widget.source) : ap.DeviceFileSource(widget.source);
}

class Recorder extends StatefulWidget {
  final void Function(String path) onStop;

  const Recorder({super.key, required this.onStop});

  @override
  State<Recorder> createState() => _RecorderState();
}

class _RecorderState extends State<Recorder> with AudioRecorderMixin {
  int _recordDuration = 0;
  Timer? _timer;
  late final AudioRecorder _audioRecorder;
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  @override
  void initState() {
    _audioRecorder = AudioRecorder();

    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      _updateRecordState(recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) {
      setState(() => _amplitude = amp);
    });

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        const encoder = AudioEncoder.aacLc;

        if (!await _isEncoderSupported(encoder)) {
          return;
        }

        final devs = await _audioRecorder.listInputDevices();
        debugPrint(devs.toString());

        const config = RecordConfig(encoder: encoder, numChannels: 1);

        // Record to file
        await recordFile(_audioRecorder, config);

        // Record to stream
        // await recordStream(_audioRecorder, config);

        _recordDuration = 0;

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop() async {
    final path = await _audioRecorder.stop();

    if (path != null) {
      widget.onStop(path);

      downloadWebData(path);
    }
  }

  Future<void> _pause() => _audioRecorder.pause();

  Future<void> _resume() => _audioRecorder.resume();

  void _updateRecordState(RecordState recordState) {
    setState(() => _recordState = recordState);

    switch (recordState) {
      case RecordState.pause:
        _timer?.cancel();
        break;
      case RecordState.record:
        _startTimer();
        break;
      case RecordState.stop:
        _timer?.cancel();
        _recordDuration = 0;
        break;
    }
  }

  Future<bool> _isEncoderSupported(AudioEncoder encoder) async {
    final isSupported = await _audioRecorder.isEncoderSupported(
      encoder,
    );

    if (!isSupported) {
      debugPrint('${encoder.name} is not supported on this platform.');
      debugPrint('Supported encoders are:');

      for (final e in AudioEncoder.values) {
        if (await _audioRecorder.isEncoderSupported(e)) {
          debugPrint('- ${encoder.name}');
        }
      }
    }

    return isSupported;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildRecordStopControl(),
                const SizedBox(width: 20),
                _buildPauseResumeControl(),
                const SizedBox(width: 20),
                _buildText(),
              ],
            ),
            if (_amplitude != null) ...[
              const SizedBox(height: 40),
              Text('Current: ${_amplitude?.current ?? 0.0}'),
              Text('Max: ${_amplitude?.max ?? 0.0}'),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  Widget _buildRecordStopControl() {
    late Icon icon;
    late Color color;

    if (_recordState != RecordState.stop) {
      icon = const Icon(Icons.stop, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.mic, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState != RecordState.stop) ? _stop() : _start();
          },
        ),
      ),
    );
  }

  Widget _buildPauseResumeControl() {
    if (_recordState == RecordState.stop) {
      return const SizedBox.shrink();
    }

    late Icon icon;
    late Color color;

    if (_recordState == RecordState.record) {
      icon = const Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = const Icon(Icons.play_arrow, color: Colors.red, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child: SizedBox(width: 56, height: 56, child: icon),
          onTap: () {
            (_recordState == RecordState.pause) ? _resume() : _pause();
          },
        ),
      ),
    );
  }

  Widget _buildText() {
    if (_recordState != RecordState.stop) {
      return _buildTimer();
    }

    return const Text("Waiting to record");
  }

  Widget _buildTimer() {
    final String minutes = _formatNumber(_recordDuration ~/ 60);
    final String seconds = _formatNumber(_recordDuration % 60);

    return Text(
      '$minutes : $seconds',
      style: const TextStyle(color: Colors.red),
    );
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }
}

class RecorderPage extends StatefulWidget {
  const RecorderPage({super.key});

  @override
  State<RecorderPage> createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {
  bool showPlayer = false;

  String? audioPath;

  @override
  void initState() {
    showPlayer = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: showPlayer
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: AudioPlayer(
                    source: audioPath!,
                    onDelete: () {
                      setState(() => showPlayer = false);
                    },
                  ),
                )
              : Recorder(
                  onStop: (path) {
                    if (kDebugMode) print('Recorded file path: $path');
                    setState(() {
                      audioPath = path;
                      showPlayer = true;
                    });
                  },
                ),
        ),
      ),
    );
  }
}
