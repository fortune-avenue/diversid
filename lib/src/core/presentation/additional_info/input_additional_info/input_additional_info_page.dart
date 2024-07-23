import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/app_routes.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class InputAdditionalInfoPage extends StatelessWidget {
  const InputAdditionalInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.scaffold,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: context.screenHeight,
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
                            'Informasi Tambahan',
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
                              const DropdownWidget(
                                hintText: 'Pekerjaan',
                                optionList: [
                                  'Pekerjaan',
                                ],
                              ),
                              Gap.h16,
                              const DropdownWidget(
                                hintText: 'Jenis Industri',
                                optionList: [
                                  'Jenis Industri',
                                ],
                              ),
                              Gap.h16,
                              const DropdownWidget(
                                hintText: 'Pendapatan Tahunan',
                                optionList: [
                                  'Pendapatan Tahunan',
                                ],
                              ),
                              Gap.h16,
                              const DropdownWidget(
                                hintText: 'Sumber Pendapatan',
                                optionList: [
                                  'Sumber Pendapatan',
                                ],
                              ),
                              Gap.h24,
                              ButtonWidget.primary(
                                text: 'LANJUT',
                                onTap: () {
                                  context.pushNamed(
                                      Routes.resultAdditionalInfo.name);
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
    );
  }
}
