import 'package:flutter/material.dart';
import 'package:formi/formi.dart';

class ColorPicker extends StatelessWidget {
  final Color value;
  final void Function(Color) onChange;
  final List<Color> availableColors;

  ColorPicker(
    this.value,
    this.onChange,
    this.availableColors,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: availableColors
            .map(
              (color) => ColorCheckbox(
                color,
                () => onChange(color),
                checked: color == value,
              ),
            )
            .toList(),
      ),
    );
  }
}

class ColorCheckbox extends StatelessWidget {
  final Color color;
  final bool checked;
  final void Function() onTap;
  ColorCheckbox(this.color, this.onTap, {this.checked = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: checked
            ? Padding(
                padding: EdgeInsets.all(8),
                child: Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 16,
                ),
              )
            : SizedBox.shrink(),
      ),
    );
  }
}

class FormiColor extends FormiField<Color> {
  final String label;
  final List<Color> availableColors;
  FormiColor({
    required this.label,
    required this.availableColors,
    required String name,
    List<FormiValidator<Color>>? validators,
    DateTime? initialPickerDate,
  }) : super(
          name: name,
          validators: validators,
          builder: (field) {
            return InputDecorator(
              decoration: InputDecoration(
                labelText: label,
                border: InputBorder.none,
                errorText: field.errorText,
                fillColor: Colors.transparent,
              ),
              child: ColorPicker(
                field.value!,
                field.didChange,
                availableColors,
              ),
            );
          },
        );
}
