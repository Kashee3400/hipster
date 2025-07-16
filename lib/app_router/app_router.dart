import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hipster/app_router/route_constants.dart';
import 'package:hipster/screens/dashboard/dashboard.dart';
import '../screens/dashboard/employee_detail.dart';
import '../screens/dashboard/models/user_profile_model.dart';
import '../screens/splash_screen.dart';

enum CustomTransitionType {
  sharedAxisScaled,
  sharedAxisHorizontal,
  sharedAxisVertical,
  fade,
  slide,
}

class MRouteConfiguration {
  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'hipster');
  static final router = GoRouter(
    initialLocation: '/${Routes.splash}',
    routes: [
      GoRoute(
        name: Routes.splash,
        path: '/${Routes.splash}',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        name: Routes.home.isEmpty ? "home" : Routes.home,
        path: '/${Routes.home}',
        builder: (context, state) => const DashboardScreen(),
        pageBuilder: (context, state) {
          return const AnimatedPageWrapper(
              screen: DashboardScreen(),
              transitionKey: ValueKey("dashboard"),
              transitionType: CustomTransitionType.sharedAxisScaled);
        },
      ),
      GoRoute(
        name: Routes.employeeDetail,
        path: '/${Routes.employeeDetail}',
        pageBuilder: (context, state) {
          UserProfile employee = state.extra as UserProfile;
          return AnimatedPageWrapper(
              screen: UserDetailPage(user: employee),
              transitionKey: const ValueKey("employee_detail"),
              transitionType: CustomTransitionType.sharedAxisScaled);
        },
      ),
    ],
  );
}

class AnimatedPageWrapper extends Page {
  const AnimatedPageWrapper({
    required this.screen,
    required this.transitionKey,
    this.transitionType = CustomTransitionType.sharedAxisScaled,
  }) : super(key: transitionKey);

  final Widget screen;
  final ValueKey transitionKey;
  final CustomTransitionType transitionType;

  @override
  Route createRoute(BuildContext context) {
    return PageRouteBuilder(
      settings: this,
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 800),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case CustomTransitionType.sharedAxisScaled:
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.scaled,
              fillColor: Theme.of(context).colorScheme.surface,
              child: child,
            );
          case CustomTransitionType.sharedAxisHorizontal:
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              fillColor: Theme.of(context).colorScheme.surface,
              child: child,
            );
          case CustomTransitionType.sharedAxisVertical:
            return SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.vertical,
              fillColor: Theme.of(context).colorScheme.surface,
              child: child,
            );
          case CustomTransitionType.fade:
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          case CustomTransitionType.slide:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
        }
      },
    );
  }
}
