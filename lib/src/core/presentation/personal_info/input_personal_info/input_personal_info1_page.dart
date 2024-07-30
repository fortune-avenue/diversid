import 'dart:async';

import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/core/core.dart';
import 'package:diversid/src/routes/app_routes.dart';
import 'package:diversid/src/services/local/local.dart';
import 'package:diversid/src/services/local/stt_service.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class InputPersonalInfo1Page extends ConsumerStatefulWidget {
  const InputPersonalInfo1Page({super.key});

  @override
  ConsumerState<InputPersonalInfo1Page> createState() =>
      _InputPersonalInfo1PageState();
}

class _InputPersonalInfo1PageState
    extends ConsumerState<InputPersonalInfo1Page> {
  SpeechToTextService get speechService =>
      ref.watch(speechToTextServiceProvider);

  TTSService get ttsService => ref.read(ttsServiceProvider);
  Timer? _debounceTimer;

  Map<String, TextEditingController> textEditingControllers = {
    'full_name': TextEditingController(),
    'nik': TextEditingController(),
    'npwp': TextEditingController(),
    'birth': TextEditingController(),
    'date_birth': TextEditingController(),
    // Add more controllers as needed
  };

  Map<String, FocusNode> focusNodes = {
    'full_name': FocusNode(),
    'nik': FocusNode(),
    'npwp': FocusNode(),
    'birth': FocusNode(),
    'date_birth': FocusNode(),
    // Add more focus nodes as needed
  };
  TextEditingController? getFocusedTextEditingController() {
    String? focusedKey = focusNodes.keys.firstWhere(
      (key) => focusNodes[key]!.hasFocus,
      orElse: () => '',
    );
    if (focusedKey.isNotEmpty) {
      return textEditingControllers[focusedKey];
    }
    return null;
  }

  @override
  void initState() {
    ttsService.speak('Halaman Informasi Pribadi');
    super.initState();
  }

  @override
  void dispose() {
    ttsService.stop();
    speechService.stopListening();
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.scaffold,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollWidget(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                'Informasi Pribadi',
                                style: TypographyApp.headline1.black,
                              ),
                            ),
                            Gap.h32,
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
                                  InputFormWidget(
                                    controller:
                                        textEditingControllers['full_name']!,
                                    focusNode: focusNodes['full_name']!,
                                    hintText: 'Nama Lengkap',
                                  ),
                                  Gap.h16,
                                  InputFormWidget(
                                    controller: textEditingControllers['nik']!,
                                    focusNode: focusNodes['nik']!,
                                    hintText: 'NIK',
                                  ),
                                  Gap.h16,
                                  InputFormWidget(
                                    controller: textEditingControllers['npwp']!,
                                    focusNode: focusNodes['npwp']!,
                                    hintText: 'NPWP',
                                  ),
                                  Gap.h16,
                                  const DropdownWidget(
                                    hintText: 'Kewarganegaraan',
                                    optionList: [
                                      'Kewarganegaraan',
                                    ],
                                  ),
                                  Gap.h16,
                                  InputFormWidget(
                                    controller:
                                        textEditingControllers['birth']!,
                                    focusNode: focusNodes['birth']!,
                                    hintText: 'Tempat Lahir',
                                  ),
                                  Gap.h16,
                                  InputFormWidget(
                                    controller:
                                        textEditingControllers['date_birth']!,
                                    focusNode: focusNodes['date_birth']!,
                                    hintText: 'Tanggal Lahir',
                                  ),
                                  Gap.h24,
                                  ButtonWidget.primary(
                                    text: 'LANJUT',
                                    onTap: () {
                                      context.pushNamed(
                                          Routes.inputPersonalInfo2.name);
                                    },
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
          ),
          KeyboardAwareButton(
            text: speechService.isNotListening
                ? 'Mulai Mode Suara'
                : 'Selesaikan Mode Suara',
            onTapDown: (details) {
              setState(() {});
              if (ttsService.isPlaying) ttsService.stop();
              speechService.startListening(
                onResult: (text) {
                  _debounceTimer?.cancel();
                  _debounceTimer = Timer(const Duration(seconds: 1), () {
                    TextEditingController? focusedController =
                        getFocusedTextEditingController();
                    if (focusedController != null) {
                      focusedController.text = text;
                      focusedController.selection = TextSelection.fromPosition(
                        TextPosition(offset: focusedController.text.length),
                      );
                      ttsService.speak(text);
                    }
                  });
                },
              );
            },
            onTapUp: (details) async {
              await speechService.stopListening();
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
