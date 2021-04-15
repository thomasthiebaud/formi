import 'package:flutter/material.dart';
import 'package:formi/formi.dart';

class Validators {
  static FormiValidator<T> required<T>(
    BuildContext context, {
    String? errorText,
  }) {
    return (value, state) {
      if (value == null ||
          (value is String && value.isEmpty) ||
          (value is Iterable && value.isEmpty) ||
          (value is Map && value.isEmpty)) {
        return errorText ?? 'This field cannot be empty.';
      }
      return null;
    };
  }
}

class FormiCheckbox extends FormiField<bool> {
  final String title;
  final String? subtitle;
  FormiCheckbox({
    required this.title,
    required String name,
    this.subtitle,
    List<FormiValidator<bool>>? validators,
    bool? initialValue,
    bool? enabled = true,
  }) : super(
          name: name,
          validators: validators,
          initialValue: initialValue,
          enabled: enabled,
          builder: (field) {
            return CheckboxListTile(
              dense: true,
              title: Text(title),
              value: field.value ?? false,
              onChanged: field.didChange,
              contentPadding: EdgeInsets.zero,
            );
          },
        );
}

class FormiSubmit extends StatelessWidget {
  final Widget Function(FormiState) builder;
  FormiSubmit({required this.builder});

  @override
  Widget build(BuildContext context) {
    final _formiState = Formi.of(context);
    return builder(_formiState);
  }
}

void main() {
  runApp(
    Formi(
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              Text('Privacy preferences'),
              FormiCheckbox(
                name: 'strict',
                title: 'Strictly necesary',
                subtitle: 'Required for the app to run as expected',
                initialValue: true,
                enabled: false,
              ),
              FormiCheckbox(
                name: 'analytics',
                title: 'Analytics',
                subtitle:
                    'Allow us to collect information about how you use the app',
                validators: [Validators.required(context)],
              ),
              FormiSubmit(
                builder: (formiState) {
                  return OutlinedButton(
                    onPressed: () {
                      formiState.save();
                      if (formiState.validate()) {
                        // Do something
                      }
                    },
                    child: Text('Submit'),
                  );
                },
              )
            ],
          );
        },
      ),
    ),
  );
}
