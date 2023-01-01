import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sokutwi/widgets/pages/home.dart';

part 'router.g.dart';

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends GoRouteData {
  @override
  Widget build(context, state) => const Home();
}

final routerProvider = Provider(
  (ref) => GoRouter(
    routes: $appRoutes,
  ),
);
