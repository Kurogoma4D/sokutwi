import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sokutwi/constants/constants.dart';
import 'package:sokutwi/usecases/fixed_phrases.dart';
import 'package:sokutwi/widgets/build_context_ex.dart';
import 'package:sokutwi/widgets/components/phrase_animation.dart';

typedef OnTapPhraseCallback = Future<void> Function(
  Offset position,
  Widget widget,
);

final _isMenuShown = StateProvider.family.autoDispose<bool, PhraseData>(
  (_, __) => false,
);
final _phraseReference = Provider.autoDispose<PhraseData>(
  (ref) => throw UnimplementedError(),
);

class FixedPhrase extends ConsumerWidget {
  const FixedPhrase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrases = ref.watch(obtainSavedPhrases);
    return phrases.when(
      data: (data) => _Contents(phrases: data),
      error: (e, __) {
        debugPrint(e.toString());
        return const SizedBox.shrink();
      },
      loading: () => const Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }
}

Future<void> _animatePhrase({
  required BuildContext context,
  required Offset origin,
  required Offset target,
  required Widget card,
}) async {
  final overlay = createPhraseAnimationOverlay(
    origin,
    target,
    card,
  );
  Navigator.of(context).overlay?.insert(overlay);
  await Future.delayed(fixedPhraseAnimationDuration);
  overlay.remove();
}

class _Contents extends ConsumerWidget {
  const _Contents({required this.phrases});

  final Iterable<PhraseData> phrases;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final animationTargetPosition =
        MediaQuery.of(context).size.center(Offset.zero);

    return SizedBox(
      height: 56,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _RandomPhraseCard(
            phrases: phrases,
            onTap: (position, widget) => _animatePhrase(
              context: context,
              origin: position,
              target: animationTargetPosition,
              card: widget,
            ),
          ),
          const Gap(16),
          for (final phrase in phrases) ...[
            ProviderScope(
              overrides: [
                _phraseReference.overrideWithValue(phrase),
              ],
              child: _PhraseCard(
                onTap: (position, widget) => _animatePhrase(
                  context: context,
                  origin: position,
                  target: animationTargetPosition,
                  card: widget,
                ),
              ),
            ),
            const Gap(16),
          ],
          _Card(
            child: const Icon(Icons.add, color: Colors.black87),
            onTap: () => ref.read(savePhrase)(),
          ),
        ],
      ),
    );
  }
}

class _RandomPhraseCard extends ConsumerWidget {
  const _RandomPhraseCard({required this.phrases, required this.onTap});

  final Iterable<PhraseData> phrases;
  final OnTapPhraseCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = GlobalKey();

    Widget card(String text) => _Card(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              text,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.black87),
            ),
          ),
        );

    return _Card(
      key: key,
      child: const Icon(Icons.shuffle, color: Colors.black87),
      onTap: () async {
        final selfRenderBox =
            key.currentContext?.findRenderObject() as RenderBox?;
        final selfPosition =
            selfRenderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
        final phrase = ref.read(obtainRandomPhrase)(phrases);
        await onTap(selfPosition, card(phrase.text));
        ref.read(applyPhrase)(phrase);
      },
    );
  }
}

class _PhraseCard extends ConsumerWidget {
  const _PhraseCard({required this.onTap});

  final OnTapPhraseCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrase = ref.watch(_phraseReference);
    final isMenuShown = ref.watch(_isMenuShown(phrase));

    final key = GlobalObjectKey(phrase);
    final card = _Card(
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          phrase.text,
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.black87),
        ),
      ),
    );

    return PortalTarget(
      key: key,
      visible: isMenuShown,
      portalFollower: GestureDetector(
        onTap: () => ref.read(_isMenuShown(phrase).notifier).state = false,
        behavior: HitTestBehavior.opaque,
        child: const SizedBox.shrink(),
      ),
      child: PortalTarget(
        visible: isMenuShown,
        anchor: const Aligned(
          follower: Alignment.bottomCenter,
          target: Alignment.topCenter,
        ),
        portalFollower: _MenuChip(
          onTap: () {
            ref.read(_isMenuShown(phrase).notifier).state = false;
            ref.read(deletePhrase)(phrase);
          },
        ),
        child: _Card(
          child: Text(
            phrase.text,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.black87),
          ),
          onTap: () async {
            final selfRenderBox =
                key.currentContext?.findRenderObject() as RenderBox?;
            final selfPosition =
                selfRenderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
            await onTap(selfPosition, card);
            ref.read(applyPhrase)(phrase);
          },
          onLongPress: () =>
              ref.read(_isMenuShown(phrase).notifier).state = true,
        ),
      ),
    );
  }
}

class _Card extends StatefulWidget {
  const _Card({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  State<_Card> createState() => _CardState();
}

class _CardState extends State<_Card> {
  bool _isTappedDown = false;

  double get _scale => _isTappedDown ? 0.86 : 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      onTapDown: (_) => setState(() {
        _isTappedDown = true;
      }),
      onTapUp: (_) => setState(() {
        _isTappedDown = false;
      }),
      onTapCancel: () => setState(() {
        _isTappedDown = false;
      }),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutBack,
        scale: _scale,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [
              BoxShadow(color: Colors.white24, blurRadius: 12, spreadRadius: 4),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: widget.child,
        ),
      ),
    );
  }
}

class _MenuChip extends StatefulWidget {
  const _MenuChip({this.onTap});

  final VoidCallback? onTap;

  @override
  State<_MenuChip> createState() => _MenuChipState();
}

class _MenuChipState extends State<_MenuChip> {
  final _duration = const Duration(milliseconds: 180);
  double _scale = 0.0;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _scale = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          _scale = 0.0;
        });
        await Future.delayed(_duration);
        widget.onTap?.call();
      },
      child: AnimatedScale(
        scale: _scale,
        duration: _duration,
        alignment: Alignment.bottomCenter,
        curve: Curves.easeOutBack,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.amber.shade100,
            borderRadius: BorderRadius.circular(60),
            boxShadow: const [
              BoxShadow(color: Colors.white24, blurRadius: 12, spreadRadius: 4),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          margin: const EdgeInsets.only(bottom: 8),
          child: Text(
            context.string.delete,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.black87),
          ),
        ),
      ),
    );
  }
}
