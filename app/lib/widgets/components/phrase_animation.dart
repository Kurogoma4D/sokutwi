import 'package:flutter/material.dart';
import 'package:sokutwi/constants/constants.dart';

const _opacityCurve = Cubic(.33, .33, .98, .35);

OverlayEntry createPhraseAnimationOverlay(
  Offset initialPosition,
  Offset targetPosition,
  Widget card,
) {
  return OverlayEntry(
    builder: (_) => _Overlay(
      initialPosition: initialPosition,
      targetPosition: targetPosition,
      card: card,
    ),
  );
}

class _Overlay extends StatefulWidget {
  const _Overlay({
    required this.initialPosition,
    required this.targetPosition,
    required this.card,
  });

  final Offset initialPosition;
  final Offset targetPosition;
  final Widget card;

  @override
  State<_Overlay> createState() => _OverlayState();
}

class _OverlayState extends State<_Overlay>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
    vsync: this,
    duration: fixedPhraseAnimationDuration,
  );
  late final Animation<Offset> _position;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _position = Tween(
      begin: widget.initialPosition,
      end: widget.targetPosition,
    ).chain(CurveTween(curve: Curves.easeInBack)).animate(_controller);
    _scale = Tween(
      begin: 1.0,
      end: 0.25,
    ).chain(CurveTween(curve: Curves.easeInBack)).animate(_controller);
    _opacity = Tween(
      begin: 1.0,
      end: 0.0,
    ).chain(CurveTween(curve: _opacityCurve)).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) => Positioned(
        top: _position.value.dy,
        left: _position.value.dx,
        child: Transform.scale(
          alignment: Alignment.topLeft,
          scale: _scale.value,
          child: Opacity(
            opacity: _opacity.value,
            child: child!,
          ),
        ),
      ),
      child: widget.card,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
