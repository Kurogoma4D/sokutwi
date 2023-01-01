import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sokutwi/usecases/tweet_text.dart';

class TweetCard extends ConsumerWidget {
  final FocusNode focus;

  const TweetCard({Key? key, required this.focus}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomPaint(
      painter: _CardPainter(),
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
