import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_elevated_button.dart';

class FormSubmitButton extends CustomElevatedButton {
  FormSubmitButton({
    required String text,
    required VoidCallback? onPressed,
  }) : super(
            child: Text(
              text,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            color: Colors.indigo,
            onPressed: onPressed);
}
