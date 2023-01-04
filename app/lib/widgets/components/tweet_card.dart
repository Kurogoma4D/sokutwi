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
    final stroke = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final path = Path()
      ..moveTo(4.0, 0.0)
      ..lineTo(size.width - 4, 0.0)
      ..relativeArcToPoint(
        const Offset(4, 4),
        radius: const Radius.circular(4),
      )
      ..lineTo(size.width, size.height - cutRadius * 0.8)
      ..relativeLineTo(-cutRadius * 1.6, cutRadius * 0.8)
      ..lineTo(4.0, size.height)
      ..relativeArcToPoint(
        const Offset(-4, -4),
        radius: const Radius.circular(4),
      )
      ..close();
    final strokePath = Path()
      ..moveTo(4.0, 0.0)
      ..lineTo(size.width - 4, 0.0)
      ..relativeArcToPoint(
        const Offset(4, 4),
        radius: const Radius.circular(4),
      )
      ..lineTo(size.width, size.height - cutRadius)
      ..relativeQuadraticBezierTo(0, cutRadius / 2, -cutRadius * 0.6, 0)
      ..quadraticBezierTo(size.width - cutRadius, size.height,
          size.width - cutRadius * 2, size.height)
      ..lineTo(4.0, size.height)
      ..relativeArcToPoint(
        const Offset(-4, -4),
        radius: const Radius.circular(4),
      )
      ..close();

    canvas.drawPath(path, p);
    canvas.drawPath(strokePath, stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
