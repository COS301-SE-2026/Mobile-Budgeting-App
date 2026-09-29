import 'package:flutter/material.dart';

class RevealOnScroll extends StatefulWidget {
  const RevealOnScroll({
    super.key,
    this.child,
    this.builder,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 480),
    this.slide = 0.06,
    this.triggerFraction = 0.9,
  }) : assert(child != null || builder != null,
            'Give RevealOnScroll either a child or a builder.');

  final Widget? child;

  final Widget Function(BuildContext context, bool shown)? builder;

  final Duration delay;
  final Duration duration;
  final double slide;
  final double triggerFraction;

  @override
  State<RevealOnScroll> createState() => _RevealOnScrollState();
}

class _RevealOnScrollState extends State<RevealOnScroll> {
  bool _shown = false;
  ScrollPosition? _position;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
        setState(() => _shown = true);
        return;
      }
      _position = Scrollable.maybeOf(context)?.position;
      _position?.addListener(_check);
      _check();
    });
  }

  void _check() {
    if (_shown || !mounted) return;
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final top = box.localToGlobal(Offset.zero).dy;
    final viewport = MediaQuery.of(context).size.height;
    if (top >= viewport * widget.triggerFraction) return;

    _position?.removeListener(_check);
    _position = null;

    if (widget.delay == Duration.zero) {
      setState(() => _shown = true);
    } else {
      Future.delayed(widget.delay, () {
        if (mounted) setState(() => _shown = true);
      });
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.builder != null) return widget.builder!(context, _shown);

    return AnimatedSlide(
      offset: _shown ? Offset.zero : Offset(0, widget.slide),
      duration: widget.duration,
      curve: Curves.easeOutCubic,
      child: AnimatedOpacity(
        opacity: _shown ? 1 : 0,
        duration: widget.duration,
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class Parallax extends StatefulWidget {
  const Parallax({super.key, required this.child, this.factor = 0.18});

  final Widget child;
  final double factor;

  @override
  State<Parallax> createState() => _ParallaxState();
}

class _ParallaxState extends State<Parallax> {
  final ValueNotifier<double> _pixels = ValueNotifier<double>(0);
  ScrollPosition? _position;
  bool _reduceMotion = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
      if (_reduceMotion) return;
      _position = Scrollable.maybeOf(context)?.position;
      _position?.addListener(_onScroll);
      _onScroll();
    });
  }

  void _onScroll() {
    final pos = _position;
    if (pos == null || !pos.hasPixels) return;
    _pixels.value = pos.pixels;
  }

  @override
  void dispose() {
    _position?.removeListener(_onScroll);
    _pixels.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_reduceMotion) return widget.child;
    return ValueListenableBuilder<double>(
      valueListenable: _pixels,
      builder: (context, pixels, child) => Transform.translate(
        offset: Offset(0, -pixels * widget.factor),
        child: child,
      ),
      child: widget.child,
    );
  }
}