// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/app_routes.dart';
import 'package:diversid/src/services/local/local.dart';
import 'package:diversid/src/services/local/stt_service.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class InputAddressPage extends ConsumerStatefulWidget {
  const InputAddressPage({super.key});

  @override
  ConsumerState<InputAddressPage> createState() => _InputAddressPageState();
}

class _InputAddressPageState extends ConsumerState<InputAddressPage> {
  SpeechToTextService get speechService =>
      ref.watch(speechToTextServiceProvider);
  TTSService get ttsService => ref.read(ttsServiceProvider);

  Timer? _debounceTimer;

  Map<String, TextEditingController> textEditingControllers = {
    'address': TextEditingController(),
    'rt': TextEditingController(),
    'rw': TextEditingController(),
    // Add more controllers as needed
  };

  Map<String, FocusNode> focusNodes = {
    'address': FocusNode(),
    'rt': FocusNode(),
    'rw': FocusNode(),
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
    ttsService.speak('Halaman Verifikasi Alamat');
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
                                'Verifikasi Alamat',
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
                                    hintText: 'Alamat Anda',
                                    controller:
                                        textEditingControllers['address']!,
                                    focusNode: focusNodes['address'],
                                  ),
                                  Gap.h16,
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InputFormWidget(
                                          controller:
                                              textEditingControllers['rt']!,
                                          focusNode: focusNodes['rt'],
                                          hintText: 'RT',
                                        ),
                                      ),
                                      Gap.w16,
                                      Expanded(
                                        child: InputFormWidget(
                                          controller:
                                              textEditingControllers['rw']!,
                                          focusNode: focusNodes['rw'],
                                          hintText: 'RW',
                                        ),
                                      ),
                                    ],
                                  ),
                                  Gap.h16,
                                  const DropdownWidget(
                                    hintText: 'Provinsi',
                                    optionList: [
                                      'Provinsi',
                                    ],
                                  ),
                                  Gap.h16,
                                  const DropdownWidget(
                                    hintText: 'Provinsi',
                                    optionList: [
                                      'Provinsi',
                                    ],
                                  ),
                                  Gap.h16,
                                  const DropdownWidget(
                                    hintText: 'Kota',
                                    optionList: [
                                      'Kecamatan',
                                    ],
                                  ),
                                  Gap.h16,
                                  const DropdownWidget(
                                    hintText: 'Kelurahan',
                                    optionList: [
                                      'Kelurahan',
                                    ],
                                  ),
                                  Gap.h16,
                                  const DropdownWidget(
                                    hintText: 'Kode Pos',
                                    optionList: [
                                      'Kode Pos',
                                    ],
                                  ),
                                  Gap.h24,
                                  ButtonWidget.primary(
                                    text: 'LANJUT',
                                    onTap: () {
                                      context
                                          .pushNamed(Routes.resultAddress.name);
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
                ? 'Tekan untuk Mode Suara'
                : 'Mendengarkan...',
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

class KeyboardAwareButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Function(TapDownDetails details)? onTapDown;
  final Function(TapUpDetails details)? onTapUp;
  final String text;

  const KeyboardAwareButton({
    super.key,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (!isKeyboardVisible) return const SizedBox.shrink();
        return ButtonWidget.hold(
          text: text,
          onTapUp: onTapUp,
          onTapDown: onTapDown,
          isStickyButton: true,
        );
      },
    );
  }
}
