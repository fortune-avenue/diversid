import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/app_routes.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class InputPersonalInfo3Page extends StatelessWidget {
  const InputPersonalInfo3Page({super.key});

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
                      Text(
                        'Informasi Pribadi',
                        style: TypographyApp.headline1.black,
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
                              controller: TextEditingController(),
                              hintText: 'Kontak Darurat',
                            ),
                            Gap.h16,
                            const DropdownWidget(
                              hintText: 'Kontak Darurat - Hubungan',
                              optionList: [
                                'Kontak Darurat - Hubungan',
                              ],
                            ),
                            Gap.h16,
                            InputFormWidget(
                              controller: TextEditingController(),
                              keyboardType: TextInputType.emailAddress,
                              hintText: 'Kontak Darurat - Alamat Email',
                            ),
                            Gap.h16,
                            InputFormWidget(
                              controller: TextEditingController(),
                              keyboardType: TextInputType.number,
                              hintText: 'Kontak Darurat - Nomor HP',
                            ),
                            Gap.h24,
                            ButtonWidget.primary(
                              text: 'LANJUT',
                              onTap: () {
                                context.pushNamed(Routes.inputSignature.name);
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
    );
  }
}
