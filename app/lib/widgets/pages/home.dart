import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/usecases/post_tweet.dart';
import 'package:sokutwi/widgets/build_context_ex.dart';

Future<TweetResult> _postTweet(WidgetRef ref) async {
  const text = 'てすと';
  return await ref.read(postTweet)(text);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    FlutterNativeSplash.remove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        // TODO(Kurogoma4D): delete this
        postTweet.overrideWithValue((text) async => TweetResult.done),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(context.string.home)),
        body: const Center(child: _TweetButton()),
      ),
    );
  }
}

class _TweetButton extends ConsumerWidget {
  const _TweetButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        final result = await _postTweet(ref);
        // ignore: use_build_context_synchronously
        if (!context.mounted) return;

        final message = result.when(
          done: () => context.string.doneTweet,
          clientNotReady: () => context.string.clientNotReady,
          rateLimitExceeded: () => context.string.tryLater,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
      child: Text(context.string.tweet),
    );
  }
}
