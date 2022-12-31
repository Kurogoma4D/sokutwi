import 'package:flutter_riverpod/flutter_riverpod.dart';

final _text = StateProvider.autoDispose((ref) => '');

final updateTweetText = Provider.autoDispose((ref) {
  final controller = ref.watch(_text.notifier);
  return (String text) {
    controller.state = text;
  };
});
