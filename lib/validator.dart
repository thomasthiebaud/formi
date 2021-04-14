import 'core.dart';

typedef FormiValidator<T> = String? Function(T? value, FormiState state);
