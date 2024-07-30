import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/constants/themes/themes.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/services/local/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Onboarding1Page extends ConsumerStatefulWidget {
  const Onboarding1Page({super.key});

  @override
  ConsumerState<Onboarding1Page> createState() => _Onboarding1PageState();
}

class _Onboarding1PageState extends ConsumerState<Onboarding1Page> {
  TTSService get ttsService => ref.read(ttsServiceProvider);

  @override
  void initState() {
    ttsService.speak('Selamat datang di DiversID. E-KYC Ramah Tuna Netra');
    super.initState();
  }

  @override
  void dispose() {
    ttsService.pause();
    super.dispose();
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
                    onTap: () => context.goNamed(Routes.register.name),
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
                child: Assets.svgs.onboarding1.svg(
                  semanticsLabel: 'Ilustrasi E-KYC Ramah Tuna Netra',
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'E-KYC Ramah Tuna Netra',
                      style: TypographyApp.headline2,
                    ),
                    Gap.h32,
                    Text(
                      'Aksesibilitas untuk Semua dengan Teknologi AI',
                      style: TypographyApp.text1,
                    ),
                  ],
                ),
              ),
              Semantics(
                button: true,
                label: 'Lanjut',
                child: GestureDetector(
                  onTap: () => context.goNamed(Routes.onboarding2.name),
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
