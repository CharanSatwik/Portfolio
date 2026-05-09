import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class CustomCursorProvider extends InheritedWidget {
  final ValueNotifier<bool> isHovering;
  final ValueNotifier<String?> label;
  final ValueNotifier<Color?> cursorColor;

  const CustomCursorProvider({
    super.key,
    required this.isHovering,
    required this.label,
    required this.cursorColor,
    required super.child,
  });

  static CustomCursorProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CustomCursorProvider>();
  }

  @override
  bool updateShouldNotify(CustomCursorProvider oldWidget) =>
      isHovering != oldWidget.isHovering ||
      label != oldWidget.label ||
      cursorColor != oldWidget.cursorColor;
}

class CustomCursor extends StatefulWidget {
  final Widget child;
  const CustomCursor({super.key, required this.child});

  @override
  State<CustomCursor> createState() => _CustomCursorState();
}

class _CustomCursorState extends State<CustomCursor>
    with TickerProviderStateMixin {
  final ValueNotifier<Offset> _pointerOffset = ValueNotifier(Offset.zero);
  final ValueNotifier<bool> _isHovering = ValueNotifier(false);
  final ValueNotifier<String?> _label = ValueNotifier(null);
  final ValueNotifier<Color?> _cursorColor = ValueNotifier(null);

  // Smooth trailing positions using ValueNotifiers for performance
  final ValueNotifier<Offset> _dotNotifier = ValueNotifier(Offset.zero);
  final ValueNotifier<Offset> _ringNotifier = ValueNotifier(Offset.zero);
  final ValueNotifier<Color> _colorNotifier = ValueNotifier(Colors.black);

  late final Ticker _ticker;
  Offset _dotOffset = Offset.zero;
  Offset _ringOffset = Offset.zero;
  Color _smoothedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((duration) {
      if (!mounted) return;

      // Calculate smoothed positions without triggering full widget rebuilds
      // Subtle smoothing for the main dot to filter out mouse jitter
      _dotOffset =
          Offset.lerp(_dotOffset, _pointerOffset.value, 0.85) ??
          _pointerOffset.value;
      _dotNotifier.value = _dotOffset;

      // Fluid trailing for the ring - tightened for closer tracking
      _ringOffset = Offset.lerp(_ringOffset, _dotOffset, 0.3) ?? _dotOffset;
      _ringNotifier.value = _ringOffset;

      // Smoothly interpolate cursor color
      final targetColor =
          _cursorColor.value ?? Theme.of(context).colorScheme.onSurface;
      _smoothedColor =
          Color.lerp(_smoothedColor, targetColor, 0.15) ?? targetColor;
      _colorNotifier.value = _smoothedColor;
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _pointerOffset.dispose();
    _isHovering.dispose();
    _label.dispose();
    _cursorColor.dispose();
    _dotNotifier.dispose();
    _ringNotifier.dispose();
    _colorNotifier.dispose();
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCursorProvider(
      isHovering: _isHovering,
      label: _label,
      cursorColor: _cursorColor,
      child: MouseRegion(
        cursor: SystemMouseCursors.none,
        child: Listener(
          onPointerHover: (event) {
            _pointerOffset.value = event.localPosition;
          },
          onPointerMove: (event) {
            _pointerOffset.value = event.localPosition;
          },
          onPointerDown: (event) {
            _pointerOffset.value = event.localPosition;
          },
          child: Stack(
            children: [
              // Removed the massive RepaintBoundary that was wrapping the entire app.
              // On Flutter Web, this forces the browser to cache the entire scrollable height
              // as a single bitmap, leading to GBs of memory usage.
              widget.child,

              // Use ListenableBuilder to only rebuild the cursor components
              ListenableBuilder(
                listenable: Listenable.merge([
                  _dotNotifier,
                  _ringNotifier,
                  _colorNotifier,
                  _isHovering,
                  _label,
                ]),
                builder: (context, _) {
                  final isHovering = _isHovering.value;
                  final label = _label.value;
                  final hasLabel = label != null;
                  final cursorColor = _colorNotifier.value;
                  final dotPos = _dotNotifier.value;
                  final ringPos = _ringNotifier.value;

                  return RepaintBoundary(
                    child: Stack(
                      children: [
                        // The Trailing Ring
                        Positioned(
                          left:
                              ringPos.dx -
                              (isHovering ? (hasLabel ? 45 : 30) : 20),
                          top:
                              ringPos.dy -
                              (isHovering ? (hasLabel ? 45 : 30) : 20),
                          child: IgnorePointer(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutExpo,
                              width: isHovering ? (hasLabel ? 90 : 60) : 40,
                              height: isHovering ? (hasLabel ? 90 : 60) : 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: cursorColor.withValues(
                                    alpha: isHovering ? 0.6 : 0.8,
                                  ),
                                  width: isHovering ? 2.0 : 1.0,
                                ),
                                color: isHovering
                                    ? cursorColor.withValues(alpha: 0.04)
                                    : Colors.transparent,
                                boxShadow: [
                                  if (isHovering)
                                    BoxShadow(
                                      color: cursorColor.withValues(alpha: 0.1),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // The Center Dot & Label
                        Positioned(
                          left: dotPos.dx - (hasLabel ? 40 : 4),
                          top: dotPos.dy - (hasLabel ? 12 : 4),
                          child: IgnorePointer(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: cursorColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                if (hasLabel) ...[
                                  const SizedBox(width: 8),
                                  Text(
                                    label,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          color: cursorColor,
                                          fontSize: 12,
                                          letterSpacing: 2,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A wrapper to easily add hover effects to interactive elements
class CustomCursorArea extends StatelessWidget {
  final Widget child;
  final String? label;
  final Color? cursorColor;
  final bool expand;

  const CustomCursorArea({
    super.key,
    required this.child,
    this.label,
    this.cursorColor,
    this.expand = true,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        final provider = CustomCursorProvider.of(context);
        if (expand) provider?.isHovering.value = true;
        if (label != null) provider?.label.value = label;
        if (cursorColor != null) provider?.cursorColor.value = cursorColor;
      },
      onHover: (_) {
        final provider = CustomCursorProvider.of(context);
        if (expand && provider?.isHovering.value == false) {
          provider?.isHovering.value = true;
        }
        if (label != null && provider?.label.value != label) {
          provider?.label.value = label;
        }
        if (cursorColor != null && provider?.cursorColor.value != cursorColor) {
          provider?.cursorColor.value = cursorColor;
        }
      },
      onExit: (_) {
        final provider = CustomCursorProvider.of(context);
        if (expand) provider?.isHovering.value = false;
        provider?.label.value = null;
        if (provider?.cursorColor.value == cursorColor) {
          provider?.cursorColor.value = null;
        }
      },
      child: child,
    );
  }
}
