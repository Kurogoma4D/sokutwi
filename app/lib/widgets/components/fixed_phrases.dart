import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sokutwi/usecases/fixed_phrases.dart';
import 'package:sokutwi/widgets/build_context_ex.dart';

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

class _Contents extends ConsumerWidget {
  const _Contents({required this.phrases});

  final Iterable<PhraseData> phrases;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: 56,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _Card(
            child: const Icon(Icons.shuffle, color: Colors.black87),
            onTap: () => ref.read(applySomePhrase)(phrases),
          ),
          const Gap(16),
          for (final phrase in phrases) ...[
            ProviderScope(
              overrides: [
                _phraseReference.overrideWithValue(phrase),
              ],
              child: const _PhraseCard(),
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

class _PhraseCard extends ConsumerWidget {
  const _PhraseCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phrase = ref.watch(_phraseReference);
    final isMenuShown = ref.watch(_isMenuShown(phrase));
    return PortalTarget(
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
          onTap: () => ref.read(applyPhrase)(phrase),
          onLongPress: () =>
              ref.read(_isMenuShown(phrase).notifier).state = true,
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.child,
    this.onTap,
    this.onLongPress,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber.shade100,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(color: Colors.white24, blurRadius: 12, spreadRadius: 4),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

class _MenuChip extends StatefulWidget {
  const _MenuChip({super.key, this.onTap});

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
