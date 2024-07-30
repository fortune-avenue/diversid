import 'dart:async';

import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/app_routes.dart';
import 'package:diversid/src/services/local/stt_service.dart';
import 'package:diversid/src/services/services.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class InputVoicePage extends ConsumerStatefulWidget {
  const InputVoicePage({super.key});

  @override
  ConsumerState<InputVoicePage> createState() => _InputVoicePageState();
}

class _InputVoicePageState extends ConsumerState<InputVoicePage> {
  SpeechToTextService get speechService =>
      ref.watch(speechToTextServiceProvider);
  TTSService get ttsService => ref.read(ttsServiceProvider);
  String prevSpeech = '';

  List<String> validationTexts = [
    'Katak Lompat',
    'Kucing Salam',
    'Manusia Tenggelam',
    'Kuda Terbang',
    'Anjing Gila',
  ];

  int index = 0;

  @override
  void initState() {
    ttsService.speak('Halaman Verifikasi Suara');
    ttsService.speak('Sebutkan dengan lantang beberapa kata berikut ini');
    ttsService.speak(validationTexts[index]);
    ttsService.speak('Tekan Tombol Mikrofon untuk memulai');
    super.initState();
  }

  Timer? _debounceTimer;

  @override
  void dispose() {
    speechService.stopListening();
    ttsService.stop();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.scaffold,
      body: CustomScrollWidget(
        child: Stack(
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
                child: PaddingWidget(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Gap.h16,
                      GestureDetector(
                        onTap: () {
                          context.pop();
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            height: SizeApp.h48,
                            width: SizeApp.h48,
                            child: const Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                CupertinoIcons.chevron_back,
                                semanticLabel: 'Kembali',
                                color: ColorApp.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Gap.h20,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Voice Biometric',
                          style: TypographyApp.headline1.black,
                        ),
                      ),
                      Gap.h32,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sebutkan dengan lantang beberapa kata berikut ini',
                              style: TypographyApp.text1,
                              textAlign: TextAlign.center,
                            ),
                            Gap.h40,
                            GestureDetector(
                              onTap: () async {
                                await ttsService.speak(validationTexts[index]);
                              },
                              child: Text(
                                validationTexts[index],
                                style: TypographyApp.headline3,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Gap.h40,
                            //Container with circle shape and inside of it there's icon microphone
                            GestureDetector(
                              onTapDown: (_) async {
                                setState(() {});
                                ttsService.stop();
                                speechService.startListening(
                                  onResult: (text) {
                                    _debounceTimer?.cancel();
                                    _debounceTimer =
                                        Timer(const Duration(seconds: 1), () {
                                      _debounceTimer = Timer(
                                          const Duration(seconds: 1), () async {
                                        if (prevSpeech.toLowerCase() ==
                                            text.toLowerCase()) {
                                          print('return');
                                          return;
                                        }
                                        prevSpeech = text;
                                        print(text);
                                        await speechService.stopListening();
                                        setState(() {});
                                        if (text.toLowerCase().contains(
                                            validationTexts[index]
                                                .toLowerCase())) {
                                          //if the text is correct, then it will continue to the next index
                                          if (index <
                                              validationTexts.length - 1) {
                                            index++;
                                            setState(() {});
                                            await ttsService.speak(
                                                'Kata yang kamu ucapkan benar');
                                            await ttsService.speak(
                                                'Kata berikutnya adalah: ${validationTexts[index]}');
                                            ttsService.speak(
                                                'Tekan Tombol Mikrofon untuk memulai');
                                          } else {
                                            await ttsService.speak(
                                                'Kata yang kamu ucapkan benar');
                                            context
                                                .goNamed(Routes.dashboard.name);
                                          }
                                        } else {
                                          ttsService.speak(
                                              'Tekan Tombol Mikrofon untuk memulai');
                                        }
                                      });
                                    });
                                  },
                                );
                              },
                              onTapUp: (details) async {
                                await speechService.stopListening();
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: speechService.isListening
                                      ? ColorApp.primary
                                      : ColorApp.secondary,
                                ),
                                padding: EdgeInsets.all(32.r),
                                child: Icon(
                                  speechService.isListening
                                      ? Icons.mic
                                      : Icons.mic_off,
                                  color: ColorApp.white,
                                  size: 32.r,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
