import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/usecases/tutorial_controls.dart';
import 'package:sokutwi/usecases/tweet_text.dart';
import 'package:sokutwi/widgets/build_context_ex.dart';

class TweetCard extends ConsumerStatefulWidget {
  final FocusNode focus;

  const TweetCard({Key? key, required this.focus}) : super(key: key);

  @override
  ConsumerState<TweetCard> createState() => _TweetCardState();
}

class _TweetCardState extends ConsumerState<TweetCard> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final shouldShow = ref.watch(shouldShowInputTutorial);

    ref.listen(inputTweetText, (_, value) {
      if (value == _controller.text) return;
      _controller.text = value;
    });

    return CustomPaint(
      painter: _CardPainter(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Stack(
          children: [
            if (shouldShow) const _InputTutorial(),
            Center(
              child: AutoSizeTextField(
                controller: _controller,
                focusNode: widget.focus,
                onChanged: (value) => ref.read(updateTweetText)(value),
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge
                    ?.copyWith(color: Colors.black54),
                minFontSize: 12,
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class _CardPainter extends CustomPainter {
  final cutRadius = 40.0;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = Colors.amber.shade50
      ..style = PaintingStyle.fill;

    final path = Path()
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width + 4.0, size.height)
      ..cubicTo(
        size.width / 2,
        size.height,
        size.width / 3,
        size.height / 18 * 17,
        4.0,
        size.height / 20 * 19.8,
      )
      ..relativeLineTo(0, -2.0)
      ..relativeLineTo(-2.6, -size.height / 3)
      ..close();

    final shadowPath = Path()
      ..lineTo(size.width, 0.0)
      ..lineTo(size.width + 4.0, size.height - 8.0)
      ..cubicTo(
        size.width / 2,
        size.height / 18 * 17.8,
        size.width / 3,
        size.height / 18 * 18.6,
        4.0,
        size.height / 20 * 18,
      )
      ..relativeLineTo(0, -2.0)
      ..relativeLineTo(-2.6, -size.height / 3)
      ..close();

    canvas.drawShadow(shadowPath, Colors.amber.shade50, 16, true);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InputTutorial extends StatefulWidget {
  const _InputTutorial();

  @override
  State<_InputTutorial> createState() => __InputTutorialState();
}

class __InputTutorialState extends State<_InputTutorial>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat(reverse: true);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Opacity(
        opacity: _controller.value,
        child: child,
      ),
      child: Center(
        child: Text(
          context.string.inputText,
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(color: Colors.black45),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
