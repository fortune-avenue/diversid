// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum KTPVerificationType {
  ktp,
  selfie,
  liveness,
}

class CaptureView extends StatelessWidget {
  final KTPVerificationType ktpVerificationType;
  final String imagePath;

  const CaptureView({
    super.key,
    required this.ktpVerificationType,
    required this.imagePath,
  });

  String get title {
    switch (ktpVerificationType) {
      case KTPVerificationType.ktp:
        return 'Foto KTP';
      case KTPVerificationType.selfie:
        return 'Foto Selfie';
      case KTPVerificationType.liveness:
        return 'Liveness';
    }
  }

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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hasil $title',
                          style: TypographyApp.headline1.black,
                        ),
                      ),
                      Gap.h32,
                      Expanded(
                        child: Center(
                          child: imagePath.isNotEmpty
                              ? Image.file(File(imagePath))
                              : const Text('Tidak ada gambar terambil'),
                        ),
                      ),
                      Gap.h32,
                      Row(
                        children: [
                          Expanded(
                            child: ButtonWidget.primary(
                              text: 'Ulangi',
                              onTap: () {
                                context.pop();
                              },
                            ),
                          ),
                          Gap.w16,
                          Expanded(
                            child: ButtonWidget.primary(
                              text: 'Lanjut',
                              onTap: () {
                                context.pushNamed(Routes.ktp.name);
                              },
                            ),
                          ),
                        ],
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
