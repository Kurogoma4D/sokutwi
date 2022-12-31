import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sokutwi/usecases/twitter_sign_in.dart';
import 'package:sokutwi/widgets/pages/home.dart';
import 'package:sokutwi/widgets/pages/initial.dart';
import 'package:sokutwi/widgets/pages/sign_in.dart';

part 'router.g.dart';

@TypedGoRoute<InitialRoute>(path: '/')
class InitialRoute extends GoRouteData {
  @override
  Widget build(context, state) => const Initial();
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
  (ref) => GoRouter(
    routes: $appRoutes,
    redirect: (context, state) {
      final isSignedIn =
          ref.read(authTokenStore).asData?.value.token.isNotEmpty ?? false;
      final signInRoute = SignInRoute().location;
      final homeRoute = HomeRoute().location;
      debugPrint('----------redirect start-----------');
      debugPrint('isSignedIn: $isSignedIn');
      if (!isSignedIn) {
        debugPrint('subloc: ${state.subloc}');
        debugPrint('----------redirect end-----------');
        return state.subloc == signInRoute ? null : signInRoute;
      }

      if (state.location == '/') {
        debugPrint('redirect to home');
        debugPrint('----------redirect end-----------');
        return homeRoute;
      }

      // if (state.subloc == signInRoute) {
      //   debugPrint('redirect to home');
      //   debugPrint('----------redirect end-----------');
      //   return homeRoute;
      // }

      debugPrint('location: ${state.location}');
      debugPrint('----------redirect end-----------');
      return null;
    },
  ),
);
