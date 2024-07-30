import 'dart:async';
import 'dart:math';

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
  final bool isFromDeeplink;

  const LoginPage({super.key, required this.isFromDeeplink});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  TTSService get ttsService => ref.read(ttsServiceProvider);

  @override
  void initState() {
    ttsService.speak('Halaman Masuk');
    if (widget.isFromDeeplink) {
      showCupertinoModalBottomSheet(
        context: context,
        closeProgressThreshold: 0.6,
        builder: (BuildContext context) {
          return const LoginWithVoiceSection();
        },
      );
    }
    super.initState();
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
                              keyboardType: TextInputType.emailAddress,
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
  late String validationText;

  List<String> validationTexts = [
    'Katak Lompat',
    'Kucing Salam',
    'Manusia Tenggelam',
    'Kuda Terbang',
    'Anjing Gila',
    'Harimau Berdansa',
    'Burung Menari',
    'Singa Berbicara',
    'Gajah Berlari',
    'Serigala Bernyanyi',
    'Panda Melompat',
    'Beruang Menari',
    'Buaya Tersenyum',
    'Rubah Bermain',
    'Kanguru Berjingkrak',
    'Kelinci Melompat',
    'Kuda Laut',
    'Ikan Terbang',
    'Domba Melompat',
    'Kura-kura Cepat',
    'Sapi Berlari',
    'Babi Berbicara',
    'Ayam Berkokok',
    'Bebek Berdansa',
    'Ular Bergoyang',
    'Merak Berkibar',
    'Jerapah Berputar',
    'Badak Berlari',
    'Kambing Melompat',
    'Gagak Terbang',
    'Elang Menyelam',
    'Burung Hantu',
    'Tupai Melompat',
    'Tikus Bermain',
    'Kupu-kupu Menari',
    'Lebah Menggigit',
    'Kumbang Berjalan',
    'Semut Bekerja',
    'Laba-laba Menjaring',
    'Nyamuk Berdengung',
    'Cicak Berlari',
    'Kadal Berjemur',
    'Katak Menyanyi',
    'Bunglon Berubah',
    'Kelelawar Bergantung',
    'Burung Hantu',
    'Gajah Berbicara',
    'Singa Mengaum',
    'Rusa Melompat',
    'Zebra Berlari',
    'Rubah Bersembunyi',
    'Serigala Berburu',
    'Beruang Bermain',
    'Anak Kucing',
    'Anak Anjing',
    'Anak Ayam',
    'Anak Kelinci',
    'Anak Domba',
    'Bayi Gajah',
    'Anak Kuda',
    'Anak Burung',
    'Anak Bebek',
    'Anak Ular',
    'Anak Ikan',
    'Anak Kura-kura',
    'Anak Katak',
    'Anak Cicak',
    'Anak Kadal',
    'Anak Bunglon',
    'Anak Kelelawar',
    'Anak Burung',
    'Anak Gajah',
    'Anak Singa',
    'Anak Rusa',
    'Anak Zebra',
    'Anak Rubah',
    'Anak Serigala',
    'Anak Beruang',
    'Ibu Kucing',
    'Ibu Anjing',
    'Ibu Ayam',
    'Ibu Kelinci',
    'Ibu Domba',
    'Ibu Gajah',
    'Ibu Kuda',
    'Ibu Burung',
    'Ibu Bebek',
    'Ibu Ular',
    'Ibu Ikan',
    'Ibu Kura-kura',
    'Ibu Katak',
    'Ibu Cicak',
    'Ibu Kadal',
    'Ibu Bunglon',
    'Ibu Kelelawar',
    'Ibu Burung',
    'Ibu Gajah',
    'Ibu Singa',
    'Ibu Rusa',
    'Ibu Zebra',
    'Ibu Rubah',
    'Ibu Serigala',
    'Ibu Beruang',
    'Ayah Kucing',
    'Ayah Anjing',
    'Ayah Ayam',
    'Ayah Kelinci',
    'Ayah Domba',
    'Ayah Gajah',
    'Ayah Kuda',
    'Ayah Burung',
    'Ayah Bebek',
    'Ayah Ular',
    'Ayah Ikan',
    'Ayah Kura-kura',
    'Ayah Katak',
    'Ayah Cicak',
    'Ayah Kadal',
    'Ayah Bunglon',
    'Ayah Kelelawar',
    'Ayah Burung',
    'Ayah Gajah',
    'Ayah Singa',
    'Ayah Rusa',
    'Ayah Zebra',
    'Ayah Rubah',
    'Ayah Serigala',
    'Ayah Beruang',
    'Guru Kucing',
    'Guru Anjing',
    'Guru Ayam',
    'Guru Kelinci',
    'Guru Domba',
    'Guru Gajah',
    'Guru Kuda',
    'Guru Burung',
    'Guru Bebek',
    'Guru Ular',
    'Guru Ikan',
    'Guru Kura-kura',
    'Guru Katak',
    'Guru Cicak',
    'Guru Kadal',
    'Guru Bunglon',
    'Guru Kelelawar',
    'Guru Burung',
    'Guru Gajah',
    'Guru Singa',
    'Guru Rusa',
    'Guru Zebra',
    'Guru Rubah',
    'Guru Serigala',
    'Guru Beruang',
    'Dokter Kucing',
    'Dokter Anjing',
    'Dokter Ayam',
    'Dokter Kelinci',
    'Dokter Domba',
    'Dokter Gajah',
    'Dokter Kuda',
    'Dokter Burung',
    'Dokter Bebek',
    'Dokter Ular',
    'Dokter Ikan',
    'Dokter Kura-kura',
    'Dokter Katak',
    'Kucing Cina',
    'Dokter Cicak',
    'Dokter Kadal',
    'Dokter Bunglon',
    'Dokter Kelelawar',
    'Dokter Burung',
    'Dokter Gajah',
    'Dokter Singa',
    'Dokter Rusa',
    'Dokter Zebra',
    'Dokter Rubah',
    'Manusia Itik',
    'Dokter Serigala',
    'Dokter Beruang',
    'Pilot Kucing',
    'Pilot Anjing',
    'Pilot Ayam',
    'Pilot Kelinci',
    'Pilot Domba',
    'Pilot Gajah',
    'Pilot Kuda',
    'Pilot Burung',
    'Pilot Bebek',
    'Pilot Ular',
    'Pilot Ikan',
    'Pilot Kura-kura',
    'Pilot Katak',
    'Pilot Cicak',
    'Pilot Kadal',
    'Pilot Bunglon',
    'Pilot Kelelawar',
    'Pilot Burung',
    'Pilot Gajah',
    'Pilot Singa',
    'Pilot Rusa',
    'Pilot Zebra',
    'Pilot Rubah',
    'Pilot Serigala',
    'Pilot Beruang',
    'Penulis Kucing',
    'Penulis Anjing',
    'Penulis Ayam',
    'Penulis Kelinci',
    'Penulis Domba',
    'Penulis Gajah',
    'Penulis Kuda',
    'Penulis Burung',
    'Penulis Bebek',
    'Penulis Ular',
    'Penulis Ikan',
    'Penulis Kura-kura',
    'Penulis Katak',
    'Penulis Cicak',
    'Penulis Kadal',
    'Penulis Bunglon',
    'Penulis Kelelawar',
    'Penulis Burung',
    'Penulis Gajah',
    'Penulis Singa',
    'Penulis Rusa',
    'Penulis Zebra',
    'Penulis Rubah'
  ];

  @override
  void initState() {
    validationText = randomizeValidationText();
    speakInit();
    super.initState();
  }

  void speakInit() {
    ttsService.speak('Sebutkan dengan lantang beberapa kata berikut ini');
    ttsService.speak(validationText);
    ttsService.speak('Tekan Tombol Mikrofon untuk memulai');
  }

  Timer? _debounceTimer;

  String randomizeValidationText() {
    final random = Random();
    int randomIndex = random.nextInt(validationTexts.length);
    return validationTexts[randomIndex];
  }

  @override
  void dispose() {
    speechService.stopListening();
    _debounceTimer?.cancel();
    super.dispose();
  }

  Future<void> _onSpeechResult(String text) async {
    if (prevSpeech.toLowerCase() == text.toLowerCase()) {
      print('return');
      return;
    }
    prevSpeech = text;
    print(text);
    await speechService.stopListening();
    setState(() {});
    if (text.toLowerCase().contains(validationText.toLowerCase())) {
      context.goNamed(Routes.dashboard.name);
    } else {
      ttsService.speak('Kata yang kamu ucapkan salah');
      setState(() {
        validationText = randomizeValidationText();
      });
      speakInit();
    }
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
                    await ttsService.speak(validationText);
                  },
                  child: Text(
                    validationText,
                    style: TypographyApp.headline3,
                    textAlign: TextAlign.center,
                  ),
                ),
                Gap.h40,
                //Container with circle shape and inside of it there's icon microphone
                GestureDetector(
                  onTapDown: (details) {
                    setState(() {});
                    if (ttsService.isPlaying) ttsService.stop();
                    speechService.startListening(
                      onResult: (text) {
                        _debounceTimer?.cancel();
                        _debounceTimer = Timer(const Duration(seconds: 1), () {
                          _onSpeechResult(text);
                        });
                      },
                    );
                  },
                  onTapUp: (details) async {
                    await speechService.stopListening();
                    setState(() {});
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorApp.primary,
                    ),
                    padding: EdgeInsets.all(32.r),
                    child: Icon(
                      speechService.isListening ? Icons.mic : Icons.mic_off,
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
