import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/usecases/tutorial_controls.dart';

final _text = StateProvider((ref) => '');

final updateTweetText = Provider.autoDispose((ref) {
  final controller = ref.watch(_text.notifier);
  return (String text) {
    ref.read(markHasInputText)();
    controller.state = text;
  };
});

final inputTweetText = Provider.autoDispose((ref) => ref.watch(_text));
