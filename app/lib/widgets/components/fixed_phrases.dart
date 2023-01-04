import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:sokutwi/usecases/fixed_phrases.dart';

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
          _PhraseCard(
            child: const Icon(Icons.shuffle, color: Colors.black87),
            onTap: () => ref.read(applySomePhrase)(phrases),
          ),
          const Gap(16),
          for (final phrase in phrases) ...[
            _PhraseCard(
              child: Text(
                phrase.text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Colors.black87),
              ),
              onTap: () => ref.read(applyPhrase)(phrase),
            ),
            const Gap(16),
          ],
          _PhraseCard(
            child: const Icon(Icons.add, color: Colors.black87),
            onTap: () => ref.read(savePhrase)(),
          ),
        ],
      ),
    );
  }
}

class _PhraseCard extends StatelessWidget {
  const _PhraseCard({
    required this.child,
    this.onTap,
  });

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
