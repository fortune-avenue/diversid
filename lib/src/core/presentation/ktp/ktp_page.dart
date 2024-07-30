import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/core/core.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/services/local/local.dart';
import 'package:diversid/src/shared/shared.dart';
import 'package:diversid/src/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class KTPPage extends ConsumerStatefulWidget {
  const KTPPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _KTPPageState();
}

class _KTPPageState extends ConsumerState<KTPPage> {
  TTSService get ttsService => ref.read(ttsServiceProvider);

  @override
  void initState() {
    ttsService.speak('Halaman Verifikasi KTP');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorApp.scaffold,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollWidget(
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
                                'Verifikasi KTP',
                                style: TypographyApp.headline1.black,
                              ),
                            ),
                            Gap.h32,
                            Semantics(
                              button: true,
                              label: 'Foto KTP',
                              // label: 'Informasi Pribadi Wajib Di-isi',
                              // label: 'Informasi Pribadi Menunggu Verifikasi',
                              // label: 'Informasi Pribadi Perlu Diperbarui',
                              // label: 'Informasi Pribadi Ditolak',
                              // label: 'Informasi Pribadi Opsional',
                              child: MenuDashboardWidget(
                                title: "Foto KTP",
                                svg: Assets.icons.ktpVerification,
                                status: MenuDashboardStatus.verified,
                                onTap: () {
                                  context.goNamed(Routes.ktpCapture.name);
                                },
                              ),
                            ),
                            Gap.h8,
                            Semantics(
                              button: true,
                              label: 'Selfie Wajah & KTP',
                              child: MenuDashboardWidget(
                                title: "Selfie Wajah & KTP",
                                svg: Assets.icons.ktpVerification,
                                status: MenuDashboardStatus.waiting,
                                onTap: () {
                                  context.goNamed(Routes.selfieCapture.name);
                                },
                              ),
                            ),
                            Gap.h8,
                            Semantics(
                              button: true,
                              label: 'Liveness Check',
                              child: MenuDashboardWidget(
                                title: "Liveness Check",
                                svg: Assets.icons.ktpVerification,
                                status: MenuDashboardStatus.required,
                                onTap: () {
                                  context.goNamed(Routes.liveness.name);
                                },
                              ),
                            ),
                            Gap.h32,
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
