import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/router.dart';
import 'package:sokutwi/usecases/post_tweet.dart';
import 'package:sokutwi/widgets/build_context_ex.dart';

// Drag element codes Inspired from:
// https://github.com/cb-cloud/flutter_in_app_notification/blob/main/lib/src/in_app_notification.dart

final _isShowingSticky = StateProvider((ref) => true);

Future<TweetResult> _postTweet(WidgetRef ref) async {
  const text = 'てすと';
  return await ref.read(postTweet)(text);
}

void _actionAfterTweet(TweetResult result, BuildContext context) {
  final message = result.when(
    done: () => context.string.doneTweet,
    clientNotReady: () => context.string.clientNotReady,
    rateLimitExceeded: () => context.string.tryLater,
  );
  final signInAction = SnackBarAction(
    label: context.string.signIn,
    onPressed: () => SignInRoute().go(context),
  );
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      action: result == TweetResult.clientNotReady ? signInAction : null,
    ),
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
    final isShowing = ref.watch(_isShowingSticky);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) => Stack(
            children: [
              if (isShowing)
                _Sticky(
                  displayHeight: constraints.maxHeight,
                  onDone: () async {
                    ref.watch(_isShowingSticky.notifier).state = false;
                    final result = await _postTweet(ref);
                    // ignore: use_build_context_synchronously
                    if (!context.mounted) return;
                    _actionAfterTweet(result, context);
                    ref.watch(_isShowingSticky.notifier).state = true;
                  },
                )
              else
                const Positioned.fill(
                  child: CircularProgressIndicator.adaptive(),
                ),
            ],
          ),
        ),
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

class _Sticky extends StatefulWidget {
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
  State<_Sticky> createState() => _StickyState();
}

class _StickyState extends State<_Sticky> with SingleTickerProviderStateMixin {
  late final _animationController = VerticalInteractAnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 250),
  )..addListener(() => setState(() {}));

  late final neutralPosition = widget.displayHeight - widget.initialPosition;

  double get _currentPosition =>
      _animationController.currentAnimation?.value ??
      (neutralPosition + _animationController.dragDistance);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: _currentPosition,
      left: 0,
      right: 0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragUpdate: _onVerticalDragUpdate,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SizedBox(
            height: widget.height,
            child: Card(
              color: Colors.amber.shade50,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Center(
                  child: TextField(
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(border: InputBorder.none),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    setState(() {
      if (!details.delta.dy.isNegative) return;
      _animationController.dragDistance =
          (_animationController.dragDistance + details.delta.dy.abs())
              .clamp(0, double.infinity);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) async {
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
