import 'package:flutter/material.dart';

/// Widget [BadgeWidget] : The BadgeWidget is use to show badge reminder for items in cart
class BadgeWidget extends StatelessWidget {
  final Widget child;
  final String value;
  final Color? color;

  const BadgeWidget({
    Key? key,
    required this.child,
    required this.value,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: color ?? Theme.of(context).colorScheme.secondary,
            ),
            constraints: const BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
