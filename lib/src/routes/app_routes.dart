import 'package:diversid/src/core/core.dart';
import 'package:diversid/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum Routes {
  // common
  splash,

  // auth
  login,
  register,
  signAs,
  emailConfirmation,
  whatsappConfirmation,
  passwordRecovery,

  // dashboard
  home,
  feed,
  wireLeader,
  account,
  setting,
  createFeed,
  generalInformation,
  accountApps,
  security,
  notification,
  createForum,
  createMentoring,
  myProfile,

  // community
  profileMember,
  communityDetail,
  directoryMember,
  communityMembership,
  communityDashboard,
  addCommunity,
  detailMember,

  // membership
  membership,
  paymentMembership,

  // announcement
  announcement,
  addAnnouncement,

  // report
  reportDashboard,
  reportBusiness,
  reportBusinessDetail,
  reportCommunity,
  reportCommunityDetail,
  reportSocialImpact,
  reportSocialImpactDetail,
  reportSyirkah,
  reportSyirkahDetail,
  reportSyirkahDetailMember,

  // commitee
  commitee,
  addCommitee,
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
        // GoRoute(
        //   path: '/splash',
        //   name: Routes.splash.name,
        //   builder: (context, state) => const SplashPage(),
        // ),
        // GoRoute(
        //   path: '/register',
        //   name: Routes.register.name,
        //   builder: (context, state) => const RegisterPage(),
        //   routes: [
        //     GoRoute(
        //       path: 'email-confirmation',
        //       name: Routes.emailConfirmation.name,
        //       builder: (context, state) => const EmailConfirmationPage(),
        //     ),
        //     GoRoute(
        //       path: 'whatsapp-confirmation',
        //       name: Routes.whatsappConfirmation.name,
        //       builder: (context, state) => const WhatsappConfirmationPage(),
        //     ),
        //   ],
        // ),
        // GoRoute(
        //   path: '/login',
        //   name: Routes.login.name,
        //   builder: (context, state) => const LoginPage(),
        //   routes: [
        //     GoRoute(
        //       path: 'password-recovery',
        //       name: Routes.passwordRecovery.name,
        //       builder: (context, state) => const PasswordRecoveryPage(),
        //     ),
        //     GoRoute(
        //       path: 'sign-as',
        //       name: Routes.signAs.name,
        //       builder: (context, state) => const SignAsPage(),
        //     ),
        //   ],
        // ),
        // GoRoute(
        //   path: '/home',
        //   name: Routes.home.name,
        //   builder: (context, state) => const DashboardPage(tabIndex: 0),
        //   routes: [
        //     GoRoute(
        //       path: 'community',
        //       name: Routes.communityDashboard.name,
        //       builder: (context, state) => const CommunityDashboardPage(),
        //       routes: [
        //         GoRoute(
        //           path: 'profile-member',
        //           name: Routes.profileMember.name,
        //           builder: (context, state) => const ProfileMemberPage(),
        //         ),
        //         GoRoute(
        //           path: 'community-detail',
        //           name: Routes.communityDetail.name,
        //           builder: (context, state) => const CommunityDetailPage(),
        //         ),
        //         GoRoute(
        //           path: 'directory-member',
        //           name: Routes.directoryMember.name,
        //           builder: (context, state) => const DirectoryMemberPage(),
        //         ),
        //         GoRoute(
        //           path: 'community-membership',
        //           name: Routes.communityMembership.name,
        //           builder: (context, state) => const CommunityMembershipPage(),
        //         ),
        //         GoRoute(
        //           path: 'add-community',
        //           name: Routes.addCommunity.name,
        //           builder: (context, state) => const AddCommunityPage(),
        //         ),
        //         GoRoute(
        //           path: 'detail-member',
        //           name: Routes.detailMember.name,
        //           builder: (context, state) => const DetailMemberPage(),
        //         ),
        //       ],
        //     ),
        //     GoRoute(
        //       path: 'membership',
        //       name: Routes.membership.name,
        //       builder: (context, state) => const MembershipPage(),
        //       routes: [
        //         GoRoute(
        //           path: 'payment-membership',
        //           name: Routes.paymentMembership.name,
        //           builder: (context, state) => const PaymentMembershipPage(),
        //         ),
        //       ],
        //     ),
        //     GoRoute(
        //       path: 'announcement',
        //       name: Routes.announcement.name,
        //       builder: (context, state) => const AnnouncementPage(),
        //       routes: [
        //         GoRoute(
        //           path: 'add-announcement',
        //           name: Routes.addAnnouncement.name,
        //           builder: (context, state) => const AddAnnouncementPage(),
        //         ),
        //       ],
        //     ),
        //     GoRoute(
        //       path: 'commitee',
        //       name: Routes.commitee.name,
        //       builder: (context, state) => const CommiteePage(),
        //       routes: [
        //         GoRoute(
        //           path: 'add-commitee',
        //           name: Routes.addCommitee.name,
        //           builder: (context, state) => const AddCommiteePage(),
        //         ),
        //       ],
        //     ),
        //     GoRoute(
        //       path: 'report-dashboard',
        //       name: Routes.reportDashboard.name,
        //       builder: (context, state) => const ReportDashboardPage(),
        //       routes: [
        //         GoRoute(
        //           path: 'report-business',
        //           name: Routes.reportBusiness.name,
        //           builder: (context, state) => const ReportBusinessPage(),
        //           routes: [
        //             GoRoute(
        //               path: 'detail',
        //               name: Routes.reportBusinessDetail.name,
        //               builder: (context, state) =>
        //                   const ReportBusinessDetailPage(),
        //             ),
        //           ],
        //         ),
        //         GoRoute(
        //           path: 'report-community',
        //           name: Routes.reportCommunity.name,
        //           builder: (context, state) => const ReportCommunityPage(),
        //           routes: [
        //             GoRoute(
        //               path: 'detail',
        //               name: Routes.reportCommunityDetail.name,
        //               builder: (context, state) =>
        //                   const ReportCommunityDetailPage(),
        //             ),
        //           ],
        //         ),
        //         GoRoute(
        //           path: 'report-social-impact',
        //           name: Routes.reportSocialImpact.name,
        //           builder: (context, state) => const ReportSocialImpactPage(),
        //           routes: [
        //             GoRoute(
        //               path: 'detail',
        //               name: Routes.reportSocialImpactDetail.name,
        //               builder: (context, state) =>
        //                   const ReportSocialImpactDetailPage(),
        //             ),
        //           ],
        //         ),
        //         GoRoute(
        //           path: 'report-syirkah',
        //           name: Routes.reportSyirkah.name,
        //           builder: (context, state) => const ReportSyirkahPage(),
        //           routes: [
        //             GoRoute(
        //               path: 'detail',
        //               name: Routes.reportSyirkahDetail.name,
        //               builder: (context, state) =>
        //                   const ReportSyirkahDetailPage(),
        //               routes: [
        //                 GoRoute(
        //                   path: 'member',
        //                   name: Routes.reportSyirkahDetailMember.name,
        //                   builder: (context, state) =>
        //                       const ReportSyirkahDetailMemberPage(),
        //                 ),
        //               ],
        //             ),
        //           ],
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
        // GoRoute(
        //   path: '/feed',
        //   name: Routes.feed.name,
        //   builder: (context, state) => const DashboardPage(tabIndex: 1),
        //   routes: [
        //     GoRoute(
        //       path: 'create-feed',
        //       name: Routes.createFeed.name,
        //       builder: (context, state) => const CreateFeedPage(),
        //     ),
        //     GoRoute(
        //       path: 'create-forum',
        //       name: Routes.createForum.name,
        //       builder: (context, state) => const CreateForumPage(),
        //     ),
        //     GoRoute(
        //       path: 'create-mentoring',
        //       name: Routes.createMentoring.name,
        //       builder: (context, state) => const CreateMentoringPage(),
        //     ),
        //   ],
        // ),
        // GoRoute(
        //   path: '/wire-leader',
        //   name: Routes.wireLeader.name,
        //   builder: (context, state) => const DashboardPage(tabIndex: 3),
        // ),
        // GoRoute(
        //   path: '/account',
        //   name: Routes.account.name,
        //   builder: (context, state) => const DashboardPage(tabIndex: 4),
        //   routes: [
        //     GoRoute(
        //       path: 'my-profile',
        //       name: Routes.myProfile.name,
        //       builder: (context, state) => const MyProfilePage(),
        //     ),
        //     GoRoute(
        //       path: 'setting',
        //       name: Routes.setting.name,
        //       builder: (context, state) => const SettingsPage(),
        //       routes: [
        //         GoRoute(
        //           path: 'general-information',
        //           name: Routes.generalInformation.name,
        //           builder: (context, state) => const GeneralInformationPage(),
        //         ),
        //         GoRoute(
        //           path: 'account-and-apps',
        //           name: Routes.accountApps.name,
        //           builder: (context, state) => const AccountAndPages(),
        //         ),
        //         GoRoute(
        //           path: 'security',
        //           name: Routes.security.name,
        //           builder: (context, state) => const SecurityPages(),
        //         ),
        //         GoRoute(
        //           path: 'notification',
        //           name: Routes.notification.name,
        //           builder: (context, state) => const NotificationPages(),
        //         ),
        //       ],
        //     ),
        //   ],
        // ),
      ],
      errorBuilder: (context, state) => ErrorPage(
        error: state.error,
      ),
    );
  },
);
