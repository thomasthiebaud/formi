import 'package:flutter/widgets.dart';
import 'package:formi/field.dart';

class Formi extends StatefulWidget {
  final Widget child;
  final Map<String, dynamic>? initialValue;

  Formi({
    required this.child,
    this.initialValue,
    Key? key,
  }) : super(key: key);

  @override
  FormiState createState() => FormiState();

  static FormiState of(BuildContext context) {
    final result = context.findAncestorStateOfType<FormiState>();
    assert(
      result != null,
      'Could not find FormiState. Make sure your form is wrapped into a Formi component',
    );
    return result!;
  }
}

class FormiState extends State<Formi> {
  final _formKey = GlobalKey<FormState>();
  final _fields = <String, FormiFieldState>{};
  final _value = <String, dynamic>{};

  Map<String, FormiFieldState> get fields => _fields;
  Map<String, dynamic>? get initialValue => widget.initialValue;
  Map<String, dynamic> get value => Map<String, dynamic>.unmodifiable(_value);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: widget.child,
    );
  }

  void registerField(String name, FormiFieldState field) {
    _fields[name] = field;
  }

  void removeInternalFieldValue(String name) {
    setState(() {
      _value.remove(name);
    });
  }

  void reset() {
    _formKey.currentState?.reset();
  }

  void save() {
    _formKey.currentState?.save();
  }

  void setFieldValue(String name, dynamic value) {
    setState(() {
      _value[name] = value;
    });
  }

  void unregisterField(String name, FormiFieldState field) {
    assert(_fields.containsKey(name));
    if (field == _fields[name]) {
      _fields.remove(name);
    }
  }

  bool validate() {
    return _formKey.currentState?.validate() ?? false;
  }
}
