import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';

class AppSnackbar {
  static void info(BuildContext context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    _showBottom(context, message);
  }

  static void warning(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _showTop(
      context,
      message,
      backgroundColor: Theme.of(context).colorScheme.snackbarWarning,
    );
  }

  static void error(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _showTop(
      context,
      message,
      backgroundColor: Theme.of(context).colorScheme.snackbarError,
    );
  }

  static void success(
    BuildContext context,
    String message, {
    Duration? duration,
  }) {
    _showTop(
      context,
      message,
      backgroundColor: Theme.of(context).colorScheme.snackbarSuccess,
    );
  }

  static void _showBottom(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  static void _showTop(
    BuildContext context,
    String message, {
    required Color backgroundColor,
    Duration duration = const Duration(seconds: 5),
  }) {
    final overlay = Overlay.of(context);

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
  });

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
