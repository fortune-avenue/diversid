import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:signature/signature.dart';

class InputSignaturePage extends StatefulWidget {
  const InputSignaturePage({super.key});

  @override
  State<InputSignaturePage> createState() => _InputSignaturePageState();
}

class _InputSignaturePageState extends State<InputSignaturePage> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: ColorApp.primary,
    exportBackgroundColor: Colors.white,
    exportPenColor: Colors.black,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
                      Text(
                        'Tanda Tangan',
                        style: TypographyApp.headline1.black,
                      ),
                      Gap.h16,
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorApp.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: ColorApp.shadow,
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: Signature(
                                    controller: _controller,
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 16,
                                top: 16,
                                child: GestureDetector(
                                  // onTap: () => _controller.clear(),
                                  child: SizedBox(
                                    height: SizeApp.h48,
                                    width: SizeApp.h48,
                                    child: Text(
                                      'Ulangi',
                                      style: TypographyApp.text2.primary.bold,
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Gap.h24,
                      ButtonWidget.primary(
                        text: 'LANJUT',
                        onTap: () {
                          context.pushNamed(Routes.resultPersonalInfo.name);
                        },
                      ),
                      Gap.h24,
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
