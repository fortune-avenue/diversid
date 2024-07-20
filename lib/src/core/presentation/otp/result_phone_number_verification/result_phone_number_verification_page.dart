import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/app_routes.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultPhoneNumberVerificationPage extends StatelessWidget {
  const ResultPhoneNumberVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Gap.h16,
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: const Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          CupertinoIcons.chevron_back,
                          color: ColorApp.black,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Assets.svgs.upload.svg(),
                    Gap.h16,
                    Text(
                      'Verifikasi Nomor HP Berhasil :)',
                      style: TypographyApp.headline1.black,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    ButtonWidget.primary(
                      text: 'Lanjut',
                      onTap: () {
                        context.goNamed(Routes.inputEmail.name);
                      },
                    ),
                    Gap.h20,
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
