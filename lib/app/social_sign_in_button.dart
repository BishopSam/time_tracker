import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/custom_elevated_button.dart';

class SocialSignInButton extends CustomElevatedButton {
  SocialSignInButton({
    required String assetName,
    required String text,
    required Color? color,
    required Color textColor,
    required VoidCallback? onPressed,
   
  }) : assert(color !=null, 'Color can\'t be null, assign a color' ),
  super(
            color: color,
            onPressed: onPressed,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(assetName),
                  Text(text, style: TextStyle(color: textColor),),
                  Opacity(opacity: 0, child: Image.asset(assetName)),
                ],
              ),);
}
