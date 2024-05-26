import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class BlurryCard extends StatelessWidget {
  final Widget child;
  final double blur;
  final Color bgColor;
  final double borderRadius;

  const BlurryCard({
    super.key,
    required this.child,
    this.blur = 3,
    this.bgColor = Colors.black54,
    this.borderRadius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: child,
      ),
    );
  }
}

void showErrorDialog(String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          'Ошибка',
          style: TextStyle(color: Colors.redAccent),
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ).animate().shake(rotation: 0.05);
    },
  );
}

Widget autoCompleteTextField(
  String labelText,
  TextEditingController controller,
  List<String> options,
  IconData? prefixIcon,
  void Function(VoidCallback) setState, {
  bool? isEmptyController,
  int? maxLines,
  int? minLines,
}) {
  onChanged(String value) {
    setState(() {
      controller.text = value;
      if (isEmptyController != null) {
        isEmptyController = true;
      }
    });
  }

  onSelected(String value) {
    setState(() {
      controller.text = value;
      if (isEmptyController != null) {
        isEmptyController = false;
      }
    });
  }

  return Autocomplete<String>(
    initialValue: controller.value,
    optionsBuilder: (TextEditingValue textEditingValue) {
      final filteredOptions = options.where((String option) {
        return option
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase());
      }).toList();
      return filteredOptions;
    },
    onSelected: onSelected,
    fieldViewBuilder: (BuildContext context,
        TextEditingController fieldTextEditingController,
        FocusNode fieldFocusNode,
        VoidCallback onFieldSubmitted) {
      return TextField(
        controller: fieldTextEditingController,
        focusNode: fieldFocusNode,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
          errorText: isEmptyController != null &&
                  isEmptyController! &&
                  controller.text.isEmpty
              ? 'Поле обязательно'
              : null,
        ),
        onChanged: onChanged,
        onSubmitted: (String value) {
          setState(() {
            onFieldSubmitted();
          });
        },
        minLines: minLines ?? 1,
        maxLines: maxLines ?? 1,
      );
    },
    optionsMaxHeight: 150,
  );
}

// ----------------------------------------------------------------------------

String formatDate(DateTime date) {
  return DateFormat('dd.MM.yyyy').format(date);
}

String formatWeekday(DateTime date) {
  final formatter = DateFormat('EEEE', 'ru');
  String weekday = formatter.format(date);
  return '${weekday[0].toUpperCase()}${weekday.substring(1)}';
}

TimeOfDay convertDateTimeToTimeOfDay(DateTime dateTime) {
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}

TimeOfDay convertTimestampToTimeOfDay(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}

DateTime convertTimeOfDayToDateTime(DateTime date, TimeOfDay time) {
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

DateTime splitDateTimeAndTime(DateTime date1, DateTime date2) {
  return DateTime(date1.year, date1.month, date1.day, date2.hour, date2.minute);
}

String formatTime(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
