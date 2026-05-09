import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  final List<String> items;
  final double speed; // Pixels per second

  const MarqueeText({super.key, required this.items, this.speed = 50.0});

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..addListener(_scroll);

    // Start scrolling as soon as the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _animationController.repeat();
    });
  }

  void _scroll() {
    if (!_scrollController.hasClients) return;

    double newOffset = _scrollController.offset + (widget.speed / 60);
    _scrollController.jumpTo(newOffset);
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: theme.colorScheme.onSurface,
            width: 0.5,
          ),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final text = widget.items[index % widget.items.length];
          return Container(
            alignment: Alignment.center,
            child: Row(
              children: [
                Text(
                  text.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: 48),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
          );
        },
      ),
    );
  }
}
