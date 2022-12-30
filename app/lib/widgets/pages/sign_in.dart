import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sokutwi/router.dart';
import 'package:sokutwi/usecases/twitter_sign_in.dart';
import 'package:sokutwi/widgets/build_context_ex.dart';

final _hasInteractionStarted = StateProvider((_) => false);

void _signIn(WidgetRef ref) {
  ref.read(_hasInteractionStarted.notifier).state = true;
  ref.read(twitterSignInUsecase)();
}

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final signInState = ref.watch(authTokenStore);
    final isLoading =
        ref.watch(_hasInteractionStarted) && signInState.isLoading;

    if (signInState.hasValue) {
      Future.microtask(() => HomeRoute().go(context));
    }

    return Scaffold(
      appBar: AppBar(title: Text(context.string.signIn)),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (isLoading)
              const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            const Gap(8),
            ElevatedButton(
              onPressed: isLoading ? null : () => _signIn(ref),
              child: Text(context.string.signIn),
            ),
          ],
        ),
      ),
    );
  }
}
