import 'package:flutter/material.dart';

/// Widget [TextWithIcon] : The TextWithIcon for displaying text with icon
class TextWithIcon extends StatelessWidget {
  final Icon icon;
  final String text;
  final MainAxisAlignment? mainAxisAlignment;
  final TextStyle textStyle;
  final EdgeInsets? padding;
  final double? spacing;

  const TextWithIcon(
      {required this.icon,
      required this.text,
      this.mainAxisAlignment,
      required this.textStyle,
      this.spacing,
      this.padding});

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQuery = MediaQuery.of(context);
    var _mWidth = _mediaQuery.size.width;
    return Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
        children: [
          icon,
          SizedBox(
            width: spacing ?? _mWidth * 0.03,
          ),
          Flexible(
            fit: FlexFit.loose,
            child: Text(
              text,
              maxLines: 2,
              style: textStyle,
            ),
          ),
        ],
      ),
    );
  }
}
