import 'package:diversid/gen/assets.gen.dart';
import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/services/services.dart';
import 'package:diversid/src/shared/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  HiveService get hiveService => ref.read(hiveServiceProvider);

  @override
  void initState() {
    safeRebuild(() {
      Future.delayed(
        const Duration(seconds: 3),
        () {
          if (hiveService.isFirstInstall) {
            context.goNamed(Routes.onboarding1.name);
            return;
          }
          context.goNamed(Routes.register.name);
        },
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // how to make backgroundColor using gradient
      backgroundColor: ColorApp.primary,
      body: Stack(
        children: [
          Positioned(
            left: -100,
            top: -50,
            child: Assets.svgs.eye.svg(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Assets.images.linePattern.image(
              fit: BoxFit.fitWidth,
              width: context.screenWidth,
            ),
          ),
          Positioned.fill(
            child: Center(
              child: Assets.svgs.logoWhite.svg(),
            ),
          ),
        ],
      ),
    );
  }
}
