import 'package:flutter/material.dart';
import 'package:formi/formi.dart';

class FormiText extends FormiField<String> {
  final String hintText;
  final bool autocorrect;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines;

  FormiText({
    required this.hintText,
    required String name,
    this.keyboardType,
    this.autocorrect = true,
    this.minLines,
    this.maxLines,
    List<FormiValidator<String>>? validators,
    String? initialValue,
    bool? enabled = true,
  }) : super(
          name: name,
          validators: validators,
          initialValue: initialValue,
          enabled: enabled,
          builder: (field) {
            return TextFormField(
              initialValue: field.value,
              onChanged: field.didChange,
              decoration: InputDecoration(
                hintText: hintText,
                errorText: field.errorText,
              ),
              minLines: minLines,
              maxLines: maxLines,
              keyboardType: keyboardType,
              autocorrect: autocorrect,
            );
          },
        );
}
