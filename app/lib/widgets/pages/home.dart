import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/constants/constants.dart';
import 'package:sokutwi/usecases/fixed_phrases.dart';
import 'package:sokutwi/usecases/post_tweet.dart';
import 'package:sokutwi/usecases/show_privacy_policy.dart';
import 'package:sokutwi/usecases/tweet_text.dart';
import 'package:sokutwi/utils/cookie_preference.dart'
    if (dart.library.html) 'package:sokutwi/utils/cookie_preference_web.dart';
import 'package:sokutwi/widgets/build_context_ex.dart';
import 'package:sokutwi/widgets/components/ad_banner.dart'
    if (dart.library.io) 'package:sokutwi/widgets/components/ad_banner_mobile.dart';
import 'package:sokutwi/widgets/components/fixed_phrases.dart';
import 'package:sokutwi/widgets/components/tweet_card.dart';

// Drag element codes Inspired from:
// https://github.com/cb-cloud/flutter_in_app_notification/blob/main/lib/src/in_app_notification.dart

const _cardSizeLimit = 600.0;

final _isShowingSticky = StateProvider.autoDispose((ref) => true);

void _actionAfterTweet(
  TweetResult result,
  BuildContext context,
  WidgetRef ref,
) {
  ref.read(updateTweetText)('');
  final message = result.when(
    success: () => context.string.doneTweet,
    fail: (kind) => kind.when(
      clientNotReady: () => context.string.clientNotReady,
      rateLimitExceeded: () => context.string.tryLater,
      other: () => context.string.somethingWentWrong,
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: const [
              Expanded(child: _Contents()),
              if (showAd && !kIsWeb) AdBanner(),
              if (kIsWeb) SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

class _Contents extends ConsumerWidget {
  const _Contents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isShowing = ref.watch(_isShowingSticky);
    return LayoutBuilder(
      builder: (context, constraints) => Stack(
        children: [
          const Positioned(
            top: 0,
            right: 0,
            child: _Menu(),
          ),
          const Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: FixedPhrase(),
          ),
          if (isShowing)
            _Sticky(
              displayHeight: constraints.maxHeight,
              onDone: () async {
                ref.watch(_isShowingSticky.notifier).state = false;
                final result = await ref.read(postTweet)();
                // ignore: use_build_context_synchronously
                if (!context.mounted) return;
                _actionAfterTweet(result, context, ref);
                ref.watch(_isShowingSticky.notifier).state = true;
              },
            )
          else
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            ),
        ],
      ),
    );
  }
}

class _Menu extends ConsumerWidget {
  const _Menu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SubmenuButton(
      style: SubmenuButton.styleFrom(
        shape: const CircleBorder(),
      ),
      // 前後に空の要素を入れると内部でpaddingがついてちょうど良い感じになる
      leadingIcon: const SizedBox.shrink(),
      trailingIcon: const SizedBox.shrink(),
      menuChildren: [
        MenuItemButton(
          onPressed: () async {
            final controller = ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.string.importing),
              ),
            );
            await ref.read(importPhrases)();
            controller.close();
          },
          child: Text(context.string.importFixedPhrases),
        ),
        MenuItemButton(
          onPressed: () async {
            final controller = ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.string.exporting),
              ),
            );
            await ref.read(exportPhrases)();
            controller.close();
          },
          child: Text(context.string.exportFixedPhrases),
        ),
        MenuItemButton(
          onPressed: () => showLicensePage(context: context),
          child: Text(context.string.license),
        ),
        if (kIsWeb)
          MenuItemButton(
            onPressed: () => showCookiePreference(),
            child: Text(context.string.cookiePreference),
          ),
        MenuItemButton(
          onPressed: () => ref.read(privacyPolicyOpener)(),
          child: Text(context.string.privacyPolicy),
        ),
      ],
      child: const Icon(
        Icons.menu,
        color: Colors.white,
      ),
    );
  }
}

final _defaultCurve = CurveTween(curve: Curves.easeOutCubic);

abstract class InteractnimationController {
  Animation<double>? currentAnimation;
  late double dragDistance;

  Future<void> animate({required double from, required double to});
}

class VerticalInteractAnimationController extends AnimationController
    implements InteractnimationController {
  @override
  Animation<double>? currentAnimation;

  @override
  double dragDistance = 0.0;

  VerticalInteractAnimationController({
    required TickerProvider vsync,
    required Duration duration,
  }) : super(vsync: vsync, duration: duration) {
    value = 1.0;
  }

  @override
  Future<void> animate({required double from, required double to}) async {
    currentAnimation = Tween(
      begin: from,
      end: to,
    ).chain(_defaultCurve).animate(this);
    dragDistance = 0.0;

    await forward(from: 0.0);
    currentAnimation = null;
  }
}

class _Sticky extends ConsumerStatefulWidget {
  const _Sticky({
    required this.displayHeight,
    required this.onDone,
  })  : height = displayHeight / 3,
        initialPosition = displayHeight / 2 + displayHeight / 3 / 2;

  final double displayHeight;
  final double initialPosition;
  final double height;
  final VoidCallback onDone;

  @override
  ConsumerState<_Sticky> createState() => _StickyState();
}

class _StickyState extends ConsumerState<_Sticky>
    with SingleTickerProviderStateMixin {
  late final _animationController = VerticalInteractAnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  )..addListener(() => setState(() {}));

  late final neutralPosition = widget.displayHeight - widget.initialPosition;
  final textFocus = FocusNode();

  double get _currentPosition =>
      _animationController.currentAnimation?.value ??
      (neutralPosition + _animationController.dragDistance);

  bool get canPostTweet {
    return ref.read(inputTweetText).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final width = min(screenWidth - 32, _cardSizeLimit).toDouble();
    final offset =
        width < _cardSizeLimit ? 16 : (screenWidth - _cardSizeLimit) / 2;

    return Positioned(
      bottom: _currentPosition,
      left: offset.toDouble(),
      width: width,
      height: widget.height,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragStart: (_) => textFocus.unfocus(),
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: (details) => _onVerticalDragEnd(details),
        onTap: () => textFocus.requestFocus(),
        child: TweetCard(focus: textFocus),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    textFocus.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      _animationController.dragDistance =
          (_animationController.dragDistance - details.delta.dy)
              .clamp(0, double.infinity);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) async {
    if (!canPostTweet) {
      await _stay();
      return;
    }

    final percentage =
        (widget.displayHeight - _currentPosition) / widget.initialPosition;
    final velocity = details.velocity.pixelsPerSecond.dy * widget.displayHeight;
    if (velocity <= -1.0) {
      await _dismiss();
      widget.onDone();
      return;
    }

    if (percentage >= 0.5) {
      if (_animationController.dragDistance == 0.0) return;
      await _stay();
    } else {
      await _dismiss();
      widget.onDone();
    }
  }

  Future<void> _dismiss() async => await _animationController.animate(
      from: _currentPosition, to: widget.displayHeight + 80);

  Future<void> _stay() async => await _animationController.animate(
      from: _currentPosition, to: neutralPosition);
}
