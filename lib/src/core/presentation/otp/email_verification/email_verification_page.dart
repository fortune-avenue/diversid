import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/app_routes.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class EmailVerificationPage extends StatelessWidget {
  const EmailVerificationPage({super.key});

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
                    Gap.h20,
                    Text(
                      'Verifikasi Nomor HP',
                      style: TypographyApp.headline1.black,
                    ),
                    const Spacer(),
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
                          Center(
                            child: Text(
                              'Masukan Kode OTP',
                              style: TypographyApp.text1.bold.black,
                            ),
                          ),
                          Gap.h24,
                          OtpTextField(
                            numberOfFields: 6,
                            borderColor: ColorApp.primary,
                            focusedBorderColor: ColorApp.primary,
                            borderRadius: BorderRadius.circular(12.r),
                            showFieldAsBox: true,
                            onCodeChanged: (String code) {},
                            onSubmit: (String verificationCode) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Verification Code"),
                                      content: Text(
                                          'Code entered is $verificationCode'),
                                    );
                                  });
                            }, // end onSubmit
                          ),
                          Gap.h16,
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Kirim Ulang OTP',
                              style: TypographyApp.text2.secondary,
                            ),
                          ),
                          Gap.h24,
                          ButtonWidget.primary(
                            text: 'LANJUT',
                            onTap: () {
                              context.pushNamed(
                                Routes.resultPhoneNumberVerification.name,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const Spacer(
                      flex: 2,
                    ),
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
