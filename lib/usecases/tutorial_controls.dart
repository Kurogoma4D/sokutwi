import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/datasources/shared_preference.dart';

const _showTutorial = 'showTutorial';

final _hasInputText = StateProvider((ref) => false);

final _shouldShowTutorial = Provider.autoDispose(
  (ref) => ref.watch(sharedPreferences).getBool(_showTutorial) ?? true,
);

final markDontShowTutorial = Provider.autoDispose((ref) {
  final preference = ref.watch(sharedPreferences);
  return () async {
    await preference.setBool(_showTutorial, false);
  };
});

final markHasInputText = Provider.autoDispose((ref) {
  final controller = ref.watch(_hasInputText.notifier);
  return () {
    controller.state = true;
  };
});

final shouldShowInputTutorial = Provider.autoDispose(
  (ref) => ref.watch(_shouldShowTutorial) && !ref.watch(_hasInputText),
);

final shouldShowSwipeTutorial = Provider.autoDispose(
  (ref) => ref.watch(_shouldShowTutorial) && ref.watch(_hasInputText),
);
