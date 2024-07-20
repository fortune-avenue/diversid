import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/constants/themes/themes.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class Onboarding4Page extends StatelessWidget {
  const Onboarding4Page({super.key});

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
                    child: Assets.svgs.logoPrimary.svg(),
                  ),
                  const Spacer(flex: 1),
                  GestureDetector(
                    onTap: () => context.goNamed(Routes.register.name),
                    child: Text('Skip >>', style: TypographyApp.text2),
                  ),
                ],
              ),
              Expanded(
                flex: 3,
                child: Assets.svgs.onboarding4.svg(),
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
              GestureDetector(
                onTap: () => context.goNamed(Routes.register.name),
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
              Gap.h20,
            ],
          ),
        ),
      ),
    );
  }
}
