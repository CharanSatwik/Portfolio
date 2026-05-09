import 'package:flutter/material.dart';
import 'package:portfolio/components/custom_cursor.dart';

class EditorialButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;
  final Color? hoverColor;
  final double borderRadius;
  final EdgeInsets? padding;

  const EditorialButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.hoverColor,
    this.borderRadius = 0,
    this.padding,
  });

  @override
  State<EditorialButton> createState() => _EditorialButtonState();
}

class _EditorialButtonState extends State<EditorialButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = _isHovered
        ? (widget.hoverColor ?? theme.colorScheme.primary)
        : theme.colorScheme.onSurface;
    final textColor = theme.colorScheme.surface;

    return CustomCursorArea(
      cursorColor: const Color.fromARGB(255, 255, 255, 255),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding:
                widget.padding ??
                const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: Text(
              widget.label.toUpperCase(),
              style: theme.textTheme.labelLarge?.copyWith(
                color: textColor,
                height: 1.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
