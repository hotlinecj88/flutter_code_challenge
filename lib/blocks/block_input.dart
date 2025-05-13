import 'package:flutter/material.dart';

class BlockInput extends StatelessWidget {

  final String placeholder;
  final TextEditingController? controller;
  final EdgeInsets contentPadding;

  BlockInput({
    super.key,
    this.placeholder = 'Placeholder Input',
    this.controller,
    this.contentPadding = const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
  });

  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    return TextFormField(
      enableSuggestions: false,
      controller: controller,
      decoration: InputDecoration(
        hintText: placeholder,
        contentPadding: contentPadding,
        isDense: true,
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.inputDecorationTheme.enabledBorder?.borderSide.color ?? Colors.grey,
          )
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: theme.inputDecorationTheme.focusedBorder?.borderSide.color ?? Colors.blue,
          )
        )
      ),
    );
    
  }

}