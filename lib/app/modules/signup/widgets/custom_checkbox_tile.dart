import 'package:flutter/material.dart';

class CustomCheckboxTile extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String text;

  const CustomCheckboxTile({
    super.key,
    required this.value,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        text,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}
