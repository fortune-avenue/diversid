import 'package:diversid/src/core/core.dart';
import 'package:diversid/src/core/presentation/ktp/ktp_capture_page.dart';
import 'package:diversid/src/core/presentation/ktp/liveness_page.dart';
import 'package:diversid/src/core/presentation/ktp/selfie_capture_page.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum Routes {
  // common
  splash,
  onboarding1,
  onboarding2,
  onboarding3,
  onboarding4,
  dashboard,

  // auth
  register,
  login,

  // address
  inputAddress,
  resultAddress,

  // additionalInfo
  inputAdditionalInfo,
  resultAdditionalInfo,

  // personalInfo
  inputPersonalInfo1,
  inputPersonalInfo2,
  inputPersonalInfo3,
  inputSignature,
  resultPersonalInfo,

  // otp
  inputPhoneNumber,
  phoneNumberVerification,
  resultPhoneNumberVerification,
  inputEmail,
  emailVerification,
  resultEmailVerification,

  // voice
  inputVoice,

  // ktp
  ktp,
  ktpCapture,
  selfieCapture,
  liveness,
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final goRouterProvider = Provider<GoRouter>(
  (ref) {
    return GoRouter(
      navigatorKey: navigatorKey,
      debugLogDiagnostics: true,
      initialLocation: '/splash',
      routerNeglect: true,
      redirect: (context, state) {
        // // if the user is not logged in, they need to login
        // final loggedIn = ref.read(hiveServiceProvider).getUser() != null;
        // final loggingIn = state.subloc == '/login';
        // if (!loggedIn) return loggingIn ? null : '/login';

        // // if the user is logged in but still on the login page, send them to
        // // the home page
        // if (loggingIn) return '/home';

        // // no need to redirect at all
        return null;
      },
      redirectLimit: 1,
      routes: [
        GoRoute(
          path: '/splash',
          name: Routes.splash.name,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/onboarding',
          name: Routes.onboarding1.name,
          builder: (context, state) => const Onboarding1Page(),
          routes: [
            GoRoute(
              path: 'onboarding2',
              name: Routes.onboarding2.name,
              builder: (context, state) => const Onboarding2Page(),
            ),
            GoRoute(
              path: 'onboarding3',
              name: Routes.onboarding3.name,
              builder: (context, state) => const Onboarding3Page(),
            ),
            GoRoute(
              path: 'onboarding4',
              name: Routes.onboarding4.name,
              builder: (context, state) => const Onboarding4Page(),
            ),
          ],
        ),
        GoRoute(
          path: '/register',
          name: Routes.register.name,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/login',
          name: Routes.login.name,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/dashboard',
          name: Routes.dashboard.name,
          builder: (context, state) => const DashboardPage(),
          routes: [
            GoRoute(
              path: 'address',
              name: Routes.inputAddress.name,
              builder: (context, state) => const InputAddressPage(),
              routes: [
                GoRoute(
                  path: 'result-address',
                  name: Routes.resultAddress.name,
                  builder: (context, state) => const ResultAddressPage(),
                ),
              ],
            ),
            GoRoute(
              path: 'additional-info',
              name: Routes.inputAdditionalInfo.name,
              builder: (context, state) => const InputAdditionalInfoPage(),
              routes: [
                GoRoute(
                  path: 'result-additional-info',
                  name: Routes.resultAdditionalInfo.name,
                  builder: (context, state) => const ResultAdditionalInfoPage(),
                ),
              ],
            ),
            GoRoute(
              path: 'personal-info',
              name: Routes.inputPersonalInfo1.name,
              builder: (context, state) => const InputPersonalInfo1Page(),
              routes: [
                GoRoute(
                  path: 'input-personal-info-2',
                  name: Routes.inputPersonalInfo2.name,
                  builder: (context, state) => const InputPersonalInfo2Page(),
                ),
                GoRoute(
                  path: 'input-personal-info-3',
                  name: Routes.inputPersonalInfo3.name,
                  builder: (context, state) => const InputSignaturePage(),
                ),
                GoRoute(
                  path: 'input-signature',
                  name: Routes.inputSignature.name,
                  builder: (context, state) => const InputSignaturePage(),
                ),
                GoRoute(
                  path: 'result-personal-info',
                  name: Routes.resultPersonalInfo.name,
                  builder: (context, state) => const ResultPersonalInfoPage(),
                ),
              ],
            ),
            GoRoute(
              path: 'otp',
              name: Routes.inputPhoneNumber.name,
              builder: (context, state) => const InputPhoneNumberPage(),
              routes: [
                GoRoute(
                  path: 'phone-number-verification',
                  name: Routes.phoneNumberVerification.name,
                  builder: (context, state) =>
                      const PhoneNumberVerificationPage(),
                ),
                GoRoute(
                  path: 'result-phone-number-verification',
                  name: Routes.resultPhoneNumberVerification.name,
                  builder: (context, state) =>
                      const ResultPhoneNumberVerificationPage(),
                ),
                GoRoute(
                  path: 'input-email',
                  name: Routes.inputEmail.name,
                  builder: (context, state) => const InputEmailPage(),
                ),
                GoRoute(
                  path: 'email-verification',
                  name: Routes.emailVerification.name,
                  builder: (context, state) => const EmailVerificationPage(),
                ),
                GoRoute(
                  path: 'result-email-verification',
                  name: Routes.resultEmailVerification.name,
                  builder: (context, state) =>
                      const ResultEmailVerificationPage(),
                ),
              ],
            ),
            GoRoute(
              path: 'voice',
              name: Routes.inputVoice.name,
              builder: (context, state) => const InputVoicePage(),
              routes: const [],
            ),
            GoRoute(
              path: 'ktp',
              name: Routes.ktp.name,
              builder: (context, state) => const KTPPage(),
              routes:  [
                GoRoute(
                  path: 'ktp-capture',
                  name: Routes.ktpCapture.name,
                  builder: (context, state) => const KTPCapturePage(),
                ),
                GoRoute(
                  path: 'selfie-capture',
                  name: Routes.selfieCapture.name,
                  builder: (context, state) => const SelfiePage(),
                ),
                GoRoute(
                  path: 'liveness',
                  name: Routes.liveness.name,
                  builder: (context, state) => const LivenessPage(),
                ),
              ],
            ),
          ],
        )
      ],
      errorBuilder: (context, state) => ErrorPage(
        error: state.error,
      ),
    );
  },
);
