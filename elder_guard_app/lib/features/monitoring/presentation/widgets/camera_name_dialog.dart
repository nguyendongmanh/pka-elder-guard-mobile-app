import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CameraNameDialog extends StatefulWidget {
  const CameraNameDialog({
    required this.title,
    required this.initialValue,
    required this.label,
    required this.hint,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.validationMessage,
    super.key,
  });

  final String title;
  final String initialValue;
  final String label;
  final String hint;
  final String cancelLabel;
  final String confirmLabel;
  final String validationMessage;

  @override
  State<CameraNameDialog> createState() => _CameraNameDialogState();
}

class _CameraNameDialogState extends State<CameraNameDialog> {
  late final TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      backgroundColor: Colors.white.withValues(alpha: 0.97),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.deepTeal,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            TextField(
              controller: _controller,
              autofocus: true,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: InputDecoration(
                labelText: widget.label,
                hintText: widget.hint,
                errorText: _errorText,
                filled: true,
                fillColor: AppColors.creamLight.withValues(alpha: 0.72),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(
                    color: AppColors.tealPrimary.withValues(alpha: 0.16),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(
                    color: AppColors.tealPrimary,
                    width: 1.4,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(widget.cancelLabel),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _submit,
                  child: Text(widget.confirmLabel),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final trimmed = _controller.text.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _errorText = widget.validationMessage;
      });
      return;
    }

    Navigator.of(context).pop(trimmed);
  }
}
