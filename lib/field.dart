import 'package:flutter/widgets.dart';
import 'package:formi/core.dart';
import 'package:formi/validator.dart';

class FormiField<T> extends FormField<T> {
  final String name;
  final List<FormiValidator<T>>? validators;

  const FormiField({
    required this.name,
    this.validators = const [],
    required FormFieldBuilder<T> builder,
    Key? key,
    FormFieldSetter<T>? onSaved,
    T? initialValue,
    AutovalidateMode? autovalidateMode,
    bool? enabled = true,
  }) : super(
          key: key,
          onSaved: onSaved,
          initialValue: initialValue,
          autovalidateMode: autovalidateMode,
          enabled: enabled ?? true,
          builder: builder,
        );

  @override
  FormiFieldState<FormiField<T>, T> createState() =>
      FormiFieldState<FormiField<T>, T>();
}

class FormiFieldState<W extends FormiField<T>, T> extends FormFieldState<T> {
  @override
  String? errorText;
  late FormiState _formiState;
  bool get enabled => widget.enabled;

  FormiState get formState => _formiState;
  @override
  bool get hasError => errorText != null;

  T? get initialValue {
    if (widget.initialValue != null) {
      return widget.initialValue;
    }

    final containsValue = _formiState.initialValue?.containsKey(widget.name);
    if (containsValue != null && containsValue) {
      return _formiState.initialValue?[widget.name] as T;
    }

    return null;
  }

  @override
  W get widget => super.widget as W;

  @override
  void dispose() {
    _formiState.unregisterField(widget.name, this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _formiState = Formi.of(context);
    _formiState.registerField(widget.name, this);
    setValue(initialValue);
  }

  @override
  void reset() {
    super.reset();
    setValue(initialValue);
  }

  @override
  void save() {
    super.save();
    _formiState.setFieldValue(
      widget.name,
      value,
    );
  }

  @override
  bool validate() {
    super.validate();
    return (widget.validators ?? []).every(
      (validator) {
        final res = validator(value, _formiState);
        setState(() {
          errorText = res;
        });
        return res == null;
      },
    );
  }
}
