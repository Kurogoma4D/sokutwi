// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'router.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<GoRoute> get $appRoutes => [
      $initializeRoute,
      $signInRoute,
    ];

GoRoute get $initializeRoute => GoRouteData.$route(
      path: '/',
      factory: $InitializeRouteExtension._fromState,
    );

extension $InitializeRouteExtension on InitializeRoute {
  static InitializeRoute _fromState(GoRouterState state) => InitializeRoute();

  String get location => GoRouteData.$location(
        '/',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}

GoRoute get $signInRoute => GoRouteData.$route(
      path: '/sign_in',
      factory: $SignInRouteExtension._fromState,
    );

extension $SignInRouteExtension on SignInRoute {
  static SignInRoute _fromState(GoRouterState state) => SignInRoute();

  String get location => GoRouteData.$location(
        '/sign_in',
      );

  void go(BuildContext context) => context.go(location, extra: this);

  void push(BuildContext context) => context.push(location, extra: this);
}
