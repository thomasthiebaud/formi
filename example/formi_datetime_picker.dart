import 'package:flutter/material.dart';
import 'package:formi/formi.dart';

class FormiDateTime extends FormiField<DateTime> {
  final String hintText;

  FormiDateTime({
    required this.hintText,
    required String name,
    List<FormiValidator<DateTime>>? validators,
    DateTime? initialPickerDate,
  }) : super(
          name: name,
          validators: validators,
          builder: (field) {
            final state = field as FormiDateTimeState;

            return TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: hintText,
                errorText: field.errorText,
              ),
              controller: state.controller,
              onTap: () async {
                final initialDate =
                    initialPickerDate ?? state.initialValue ?? DateTime.now();

                final date = await showDatePicker(
                  context: field.context,
                  initialDate: initialDate,
                  firstDate: initialDate,
                  lastDate: initialDate.add(Duration(days: 365)),
                );
                if (date != null) {
                  final time = await showTimePicker(
                    context: field.context,
                    initialTime: TimeOfDay.fromDateTime(initialDate),
                  );

                  if (time != null) {
                    field.didChange(DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    ));
                  }
                }
              },
            );
          },
        );

  @override
  FormiDateTimeState createState() => FormiDateTimeState();
}

class FormiDateTimeState
    extends FormiFieldState<FormiField<DateTime>, DateTime> {
  late TextEditingController controller = TextEditingController(
    text: initialValue != null ? initialValue!.toString() : '',
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      controller.text = initialValue != null ? initialValue!.toString() : '';
    });
  }

  @override
  void save() {
    super.save();
    formState.setFieldValue(widget.name, value?.toUtc());
  }

  @override
  void didChange(DateTime? value) {
    super.didChange(value);
    if (value != null) {
      final formatedDate = value.toIso8601String();

      if (controller.text != formatedDate) {
        controller.text = formatedDate;
      }
    }
  }
}
