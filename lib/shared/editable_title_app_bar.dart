import 'package:flutter/material.dart';
import 'package:smart_documents_scanner/core/themes/app_colors.dart';

class EditableTitleAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;
  final ValueChanged<String> onChanged;
  final List<Widget>? actions;

  const EditableTitleAppBar({
    super.key,
    required this.title,
    required this.onChanged,
    this.actions,
  });

  @override
  State<EditableTitleAppBar> createState() => _EditableTitleAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _EditableTitleAppBarState extends State<EditableTitleAppBar> {
  late TextEditingController _controller;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.title);
  }

  @override
  void didUpdateWidget(covariant EditableTitleAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.title != widget.title && !_isEditing) {
      _controller.text = widget.title;
    }
  }

  void _save() {
    widget.onChanged(_controller.text);
    setState(() => _isEditing = false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      leading: const BackButton(),

      title: _isEditing
          ? TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              cursorColor: colorScheme.textLight,
              onSubmitted: (_) => _save(),
              style: TextStyle(color: colorScheme.textLight),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
            )
          : Text(widget.title),

      actions: [
        ...?widget.actions,

        IconButton(
          icon: Icon(_isEditing ? Icons.check : Icons.edit),
          onPressed: () {
            if (_isEditing) {
              _save();
            } else {
              setState(() => _isEditing = true);
            }
          },
        ),
      ],
    );
  }
}
