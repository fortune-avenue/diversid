import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/app_routes.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class InputPersonalInfo2Page extends StatelessWidget {
  const InputPersonalInfo2Page({super.key});

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
                      'Informasi pribadi',
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
                          const DropdownWidget(
                            hintText: 'Jenis Kelamin',
                            optionList: [
                              'Jenis Kelamin',
                            ],
                          ),
                          Gap.h16,
                          const DropdownWidget(
                            hintText: 'Agama',
                            optionList: [
                              'Agama',
                            ],
                          ),
                          Gap.h16,
                          const DropdownWidget(
                            hintText: 'Status Perkawinan',
                            optionList: [
                              'Tingkat Pendidikan',
                            ],
                          ),
                          Gap.h24,
                          ButtonWidget.primary(
                            text: 'LANJUT',
                            onTap: () {
                              context.pushNamed(Routes.inputPersonalInfo3.name);
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
    );
  }
}
