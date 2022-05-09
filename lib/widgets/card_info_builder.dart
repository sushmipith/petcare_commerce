import 'package:flutter/material.dart';

import 'text_with_icon.dart';

///Widget [CardInfoBuilder] : To build card info for simple view
class CardInfoBuilder extends StatelessWidget {
  final Widget description;
  final String title;
  final IconData iconType;

  const CardInfoBuilder(
      {required this.description, required this.title, required this.iconType});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithIcon(
              padding: const EdgeInsets.all(0),
              text: title,
              icon: Icon(
                iconType,
                size: 20,
              ),
              spacing: 30,
              textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87),
            ),
            const SizedBox(
              height: 20,
            ),
            description
          ],
        ),
      ),
    );
  }
}
