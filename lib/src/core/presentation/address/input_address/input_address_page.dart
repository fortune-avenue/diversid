import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/app_routes.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class InputAddressPage extends StatelessWidget {
  const InputAddressPage({super.key});

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
                      'Verifikasi Alamat',
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
                            hintText: 'Alamat Anda',
                          ),
                          Gap.h16,
                          Row(
                            children: [
                              Expanded(
                                child: InputFormWidget(
                                  controller: TextEditingController(),
                                  hintText: 'RT',
                                ),
                              ),
                              Gap.w16,
                              Expanded(
                                child: InputFormWidget(
                                  controller: TextEditingController(),
                                  hintText: 'RW',
                                ),
                              ),
                            ],
                          ),
                          Gap.h16,
                          const DropdownWidget(
                            hintText: 'Provinsi',
                            optionList: [
                              'Provinsi',
                            ],
                          ),
                          Gap.h16,
                          const DropdownWidget(
                            hintText: 'Provinsi',
                            optionList: [
                              'Provinsi',
                            ],
                          ),
                          Gap.h16,
                          const DropdownWidget(
                            hintText: 'Kota',
                            optionList: [
                              'Kecamatan',
                            ],
                          ),
                          Gap.h16,
                          const DropdownWidget(
                            hintText: 'Kelurahan',
                            optionList: [
                              'Kelurahan',
                            ],
                          ),
                          Gap.h16,
                          const DropdownWidget(
                            hintText: 'Kode Pos',
                            optionList: [
                              'Kode Pos',
                            ],
                          ),
                          Gap.h24,
                          ButtonWidget.primary(
                            text: 'LANJUT',
                            onTap: () {
                              context.pushNamed(Routes.resultAddress.name);
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
