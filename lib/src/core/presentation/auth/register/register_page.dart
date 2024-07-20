import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/services/services.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    HiveService hiveService = ref.read(hiveServiceProvider);
    hiveService.isFirstInstall = false;
    return Scaffold(
      backgroundColor: ColorApp.scaffold,
      body: Stack(
        children: [ 
          Positioned(
            right: 0,
            top: 0,
            child: Assets.images.elipse.image(
              height: context.screenHeightPercentage(0.4),
              fit: BoxFit.fitHeight,
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: PaddingWidget(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Assets.svgs.logoPrimary.svg(),
                    ),
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
                            'Daftar',
                            style: TypographyApp.headline3.black,
                          ),
                          Gap.h16,
                          InputFormWidget(
                            controller: TextEditingController(),
                            hintText: 'Nama Lengkap',
                          ),
                          Gap.h16,
                          InputFormWidget(
                            controller: TextEditingController(),
                            hintText: 'Email',
                          ),
                          Gap.h16,
                          InputFormWidget.password(
                            controller: TextEditingController(),
                            hintText: 'Password',
                          ),
                          Gap.h24,
                          ButtonWidget.primary(
                            text: 'Daftar',
                            onTap: () {},
                          ),
                          Gap.h12,
                          ButtonWidget.outlined(
                            text: 'Masuk',
                            onTap: () {
                              context.goNamed(Routes.login.name);
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
    );
  }
}
