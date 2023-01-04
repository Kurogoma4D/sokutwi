import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/usecases/twitter_sign_in.dart';
import 'package:sokutwi/widgets/build_context_ex.dart';

class SignInBanner extends ConsumerStatefulWidget {
  const SignInBanner({Key? key}) : super(key: key);

  @override
  ConsumerState<SignInBanner> createState() => _SignInBannerState();
}

class _SignInBannerState extends ConsumerState<SignInBanner>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 1200))
    ..repeat(reverse: true);
  late final _animation = Tween(begin: 1.0, end: 2.0).animate(_controller);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ref.read(twitterSignInUsecase)(),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.amber.shade50,
              boxShadow: [
                BoxShadow(
                  color: Colors.white24,
                  blurRadius: 16 * _animation.value,
                  spreadRadius: 4 * _animation.value,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: child,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              context.string.appNeedsSignIn,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
