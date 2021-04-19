# formi

A minimalist form builder, with null safetty and no dependencies. Inspired by https://pub.dev/packages/flutter_form_builder.

## Getting Started

`formi` does not include UI components but it will help you to build yours so you have **full control**.

You can check the **example** folder that contains some components to get you started.

### 1. Create a widget that extends FormiField

For example you could create a Checkbox field like this

```
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
```

### 2. Wrap your form in a Formi container

Fields in `Formi` needs a unique `name` that is used to keep the value of the field

```
Formi(
  child: Column(
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
            subtitle: 'Allow us to collect information about how you use the app',
        ),
        OutlinedButton(
            child: Text('Submit'),
            onPressed: () {
                final formiState = Formi.of(context);
                formiState.save();
                if (formiState.validate()) {
                    // Retrieve the form state with formiState.value
                }
            }
        ),
    ]
  ),
)
```

### 3. Add custom validators

A validator is a function that takes the field value and the form state and returns:
- a `String` if there is an error
- `null` otherwise

```
FormiValidator<T> required<T>(
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
```

### 4. Create more components to fit your needs

For example the submit button could be written as

```
class FormiSubmit extends StatelessWidget {
  final Widget Function(FormiState) builder;
  FormiSubmit({required this.builder});

  @override
  Widget build(BuildContext context) {
    final _formiState = Formi.of(context);
    return builder(_formiState);
  }
}
```