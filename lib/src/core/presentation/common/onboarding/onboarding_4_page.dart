import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/constants/themes/themes.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/services/local/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Onboarding4Page extends ConsumerStatefulWidget {
  const Onboarding4Page({super.key});

  @override
  ConsumerState<Onboarding4Page> createState() => _Onboarding4PageState();
}

class _Onboarding4PageState extends ConsumerState<Onboarding4Page> {
  TTSService get ttsService => ref.read(ttsServiceProvider);

  @override
  void initState() {
    ttsService.speak('Verifikasi Biometrik Suara');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.scaffold,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ExcludeSemantics(
                      child: Assets.svgs.logoPrimary.svg(
                        semanticsLabel: "DiversID Logo",
                      ),
                    ),
                  ),
                  const Spacer(flex: 1),
                  GestureDetector(
                    onTap: () {
                      ttsService.stop();
                      context.goNamed(Routes.register.name);
                    },
                    child: SizedBox(
                      height: SizeApp.h48,
                      child: Center(
                        child: Text(
                          'Lewati >>',
                          style: TypographyApp.text2,
                          semanticsLabel: 'Lewati ke Halaman Daftar',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                flex: 3,
                child: Assets.svgs.onboarding4.svg(
                  semanticsLabel: 'Ilustrasi Verifikasi Biometrik Suara',
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Verifikasi Biometrik Suara',
                      style: TypographyApp.headline2,
                    ),
                    Gap.h32,
                    Text(
                      'Keamanan Tingkat Tinggi dengan Biometrik Suara',
                      style: TypographyApp.text1,
                    ),
                  ],
                ),
              ),
              Semantics(
                button: true,
                label: 'Lanjut',
                child: GestureDetector(
                  onTap: () {
                    ttsService.stop();
                    context.goNamed(Routes.register.name);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.r),
                      color: ColorApp.primary,
                    ),
                    padding: EdgeInsets.all(8.w),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: ColorApp.white,
                      size: 40,
                    ),
                  ),
                ),
              ),
              Gap.h20,
            ],
          ),
        ),
      ),
    );
  }
}
