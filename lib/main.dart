import 'package:diversid/src/constants/constants.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:diversid/src/services/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  /// [INFO] Init hive local db
  await hiveInit();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.read(goRouterProvider);

    /// [INFO]
    /// As we use flutter_screenutil for responsive pixel
    /// with considering the design system size (390, 844).
    /// then don't forget to use these extension :
    /// 1. .h -> to pixel related with height, ex : 16.h
    /// 2. .w -> to pixel related with width, ex : 24.w
    /// 3. .r -> to pixel related with radius, ex : 8.r
    /// 4. .sp -> to pixel related with font size, ex : 14.sp
    ///
    /// [INFO]
    /// FocusManager is used for unfocus whenever user click outside of the textfield, it will unfocus.
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder: (context, child) {
          return OverlaySupport.global(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerDelegate: router.routerDelegate,
              routeInformationParser: router.routeInformationParser,
              routeInformationProvider: router.routeInformationProvider,
              title: 'DiversID',
              theme: _appTheme,
              builder: (context, child) {
                ErrorWidget.builder = (details) {
                  return CustomErrorWidget(errorDetails: details);
                };
                return child ?? const Scaffold();
              },
            ),
          );
        },
      ),
    );
  }
}

/// [INFO]
/// Show this Widget when something error happens
class CustomErrorWidget extends StatelessWidget {
  final FlutterErrorDetails errorDetails;

  const CustomErrorWidget({
    super.key,
    required this.errorDetails,
  });

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: Colors.red,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "Something is not right here...",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

final _appTheme = ThemeData(
  scaffoldBackgroundColor: ColorApp.scaffold,
  colorScheme: const ColorScheme.light(
    primary: ColorApp.primary,
    secondary: ColorApp.secondary,
    surface: ColorApp.scaffold,
  ),
  fontFamily: GoogleFonts.nunito().fontFamily,
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: <TargetPlatform, PageTransitionsBuilder>{
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);
