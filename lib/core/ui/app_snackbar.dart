import 'package:flutter/material.dart';

class AppSnackbar {
  static const _infoColor = Color(0xFF2196F3);
  static const _warningColor = Color(0xFFFF9800);
  static const _errorColor = Color(0xFFF44336);

  static void info(BuildContext context, String message) {
    _show(context, message, backgroundColor: _infoColor);
  }

  static void warning(BuildContext context, String message) {
    _show(context, message, backgroundColor: _warningColor);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, backgroundColor: _errorColor);
  }

  static void _show(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 5),
  }) {
    final overlay = Overlay.of(context);
    if (overlay == null) return;

    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 60,
        left: 16,
        right: 16,
        child: SafeArea(
          child: Material(
            color: Colors.transparent,
            child: _SnackbarWidget(
              message: message,
              backgroundColor: backgroundColor,
              onClose: () {
                if (overlayEntry.mounted) overlayEntry.remove();
              },
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(duration, () {
      if (overlayEntry.mounted) overlayEntry.remove();
    });
  }
}

class _SnackbarWidget extends StatefulWidget {
  final String message;
  final Color backgroundColor;
  final VoidCallback onClose;

  const _SnackbarWidget({
    required this.message,
    required this.backgroundColor,
    required this.onClose,
    Key? key,
  }) : super(key: key);

  @override
  State<_SnackbarWidget> createState() => _SnackbarWidgetState();
}

class _SnackbarWidgetState extends State<_SnackbarWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorSchemeTheme = theme.colorScheme;

    return SlideTransition(
      position: _offsetAnimation,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: widget.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.message,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorSchemeTheme.onPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: widget.onClose,
                child: Icon(Icons.close, color: colorSchemeTheme.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
