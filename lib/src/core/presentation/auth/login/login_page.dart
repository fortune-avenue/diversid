import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
                              context.goNamed(Routes.dashboard.name);
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
    );
  }
}
