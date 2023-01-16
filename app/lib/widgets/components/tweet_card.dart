import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/usecases/tweet_text.dart';

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
    ref.listen(inputTweetText, (_, value) {
      if (value == _controller.text) return;
      _controller.text = value;
    });

    return CustomPaint(
      painter: _CardPainter(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(
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
      ..lineTo(4.0, size.height - 2.0)
      ..relativeLineTo(-2.6, -size.height / 3)
      ..close();

    canvas.drawShadow(path, Colors.amber.shade50.withOpacity(0.8), 16, true);
    canvas.drawPath(path, p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
