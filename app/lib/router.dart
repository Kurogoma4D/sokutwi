import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sokutwi/widgets/pages/home.dart';
import 'package:sokutwi/widgets/pages/initialize.dart';
import 'package:sokutwi/widgets/pages/sign_in.dart';

part 'router.g.dart';

@TypedGoRoute<InitializeRoute>(path: '/')
class InitializeRoute extends GoRouteData {
  @override
  Widget build(context, state) => const Initialize();
}

@TypedGoRoute<SignInRoute>(path: '/sign_in')
class SignInRoute extends GoRouteData {
  @override
  Widget build(context, state) => const SignIn();
}

@TypedGoRoute<HomeRoute>(path: '/home')
class HomeRoute extends GoRouteData {
  @override
  Widget build(context, state) => const Home();
}

final routerProvider = Provider(
  (ref) => GoRouter(routes: $appRoutes),
);
