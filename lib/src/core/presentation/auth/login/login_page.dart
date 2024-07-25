import 'dart:async';

import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/constants/themes/themes.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/services/local/stt_service.dart';
import 'package:diversid/src/services/services.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Assets.svgs.logoPrimary.svg(
                        semanticsLabel: "DiversID Logo",
                      )),
                      Container(
                        decoration: BoxDecoration(
                          color: ColorApp.white,
                          borderRadius: BorderRadius.circular(16.r),
                          boxShadow: ColorApp.shadow,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: SizeApp.w16,
                          vertical: SizeApp.h32,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Masuk',
                              style: TypographyApp.headline3.black,
                            ),
                            Gap.h16,
                            InputFormWidget(
                              controller: TextEditingController(),
                              hintText: 'Email',
                            ),
                            Gap.h16,
                            InputFormWidget.password(
                              controller: TextEditingController(),
                              hintText: 'Kata Sandi',
                            ),
                            Gap.h24,
                            ButtonWidget.primary(
                              text: 'Masuk',
                              onTap: () {
                                context.goNamed(Routes.dashboard.name);
                              },
                            ),
                            Gap.h12,
                            ButtonWidget.outlined(
                              text: 'Masuk Dengan Voice Biometric',
                              onTap: () {
                                showCupertinoModalBottomSheet(
                                  context: context,
                                  closeProgressThreshold: 0.6,
                                  builder: (BuildContext context) {
                                    return const LoginWithVoiceSection();
                                  },
                                );
                              },
                            ),
                            Gap.h12,
                            ButtonWidget.outlined(
                              text: 'Daftar',
                              onTap: () {
                                context.goNamed(Routes.register.name);
                              },
                            ),
                          ],
                        ),
                      ),
                      const Spacer()
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

class LoginWithVoiceSection extends ConsumerStatefulWidget {
  const LoginWithVoiceSection({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      LoginWithVoiceSectionState();
}

class LoginWithVoiceSectionState extends ConsumerState<LoginWithVoiceSection> {
  SpeechToTextService get speechService =>
      ref.watch(speechToTextServiceProvider);
  TTSService get ttsService => ref.read(ttsServiceProvider);
  String prevSpeech = '';

  @override
  void initState() {
    ttsService.speak('Sebutkan dengan lantang kata berikut ini: Kuda Terbang');
    ttsService.speak('Tekan Tombol Mikrofon untuk memulai');
    super.initState();
  }

  Timer? _debounceTimer;

  @override
  void dispose() {
    speechService.stopListening();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSpeechResult(String text) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (prevSpeech.toLowerCase() == text.toLowerCase()) {
        print('return');
        return;
      }
      prevSpeech = text;
      print(text);
      await speechService.stopListening();
      setState(() {});
      if (text.toLowerCase().contains('kuda terbang'.toLowerCase())) {
        context.goNamed(Routes.dashboard.name);
      } else {
        await ttsService.speak('Kata yang kamu ucapkan salah');
        ttsService.speak('Tekan Tombol Mikrofon untuk memulai');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FractionallySizedBox(
        heightFactor: 0.5,
        child: Container(
          color: ColorApp.white,
          child: PaddingWidget(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Gap.h16,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: ColorApp.primary,
                  ),
                  height: 4,
                  width: 32,
                ),
                Gap.h32,
                Text(
                  'Sebutkan dengan lantang kata berikut ini',
                  style: TypographyApp.text1,
                  textAlign: TextAlign.center,
                ),
                Gap.h40,
                GestureDetector(
                  onTap: () async {
                    await ttsService.speak('Kuda Terbang');
                  },
                  child: Text(
                    'Kuda Terbang',
                    style: TypographyApp.headline3,
                    textAlign: TextAlign.center,
                  ),
                ),
                Gap.h40,
                //Container with circle shape and inside of it there's icon microphone
                GestureDetector(
                  onTap: () async {
                    if (speechService.isListening) {
                      await speechService.stopListening();
                      setState(() {});
                    } else {
                      setState(() {});
                      ttsService.stop();
                      speechService.startListening(
                        onResult: _onSpeechResult,
                      );
                    }
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorApp.primary,
                    ),
                    padding: EdgeInsets.all(16.r),
                    child: Icon(
                      speechService.isListening ? Icons.mic_off : Icons.mic,
                      color: ColorApp.white,
                      size: 32.r,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
