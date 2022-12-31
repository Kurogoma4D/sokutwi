import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/usecases/tweet_text.dart';

class TweetCard extends ConsumerWidget {
  final FocusNode focus;

  const TweetCard({Key? key, required this.focus}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
          child: TextField(
            focusNode: focus,
            onChanged: (value) => ref.read(updateTweetText)(value),
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
            decoration: const InputDecoration(border: InputBorder.none),
          ),
        ),
      ),
    );
  }
}
