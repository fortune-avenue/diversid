import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/app_routes.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResultPersonalInfoPage extends StatelessWidget {
  const ResultPersonalInfoPage({super.key});

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
                          child: const Icon(
                            CupertinoIcons.chevron_back,
                            semanticLabel: 'Kembali',
                            color: ColorApp.black,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Assets.svgs.upload.svg(
                      semanticsLabel: 'Ilustrasi upload berhasil',
                    ),
                    Gap.h16,
                    Text(
                      'Verifikasi Informasi Pribadi Berhasil :)',
                      style: TypographyApp.headline1.black,
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    ButtonWidget.primary(
                      text: 'Selesai',
                      onTap: () {
                        context.goNamed(Routes.dashboard.name);
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
