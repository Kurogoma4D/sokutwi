import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/router.dart';

final _nextRoute = FutureProvider((ref) async {
  FlutterNativeSplash.remove();
  return SignInRoute();
});

class Initialize extends ConsumerWidget {
  const Initialize({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(_nextRoute, (_, next) {
      next.whenData((value) => value.go(context));
    });
    return const SizedBox.shrink();
  }
}
