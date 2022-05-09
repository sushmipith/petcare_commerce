import 'package:flutter/material.dart';
import 'package:petcare_commerce/core/constants/assets_source.dart';
import 'package:petcare_commerce/core/constants/constants.dart';

/// Widget [ApiErrorWidget] : The ApiErrorWidget is use when data load fails
/// showing try again button and image
class ApiErrorWidget extends StatelessWidget {
  final VoidCallback tryAgain;

  const ApiErrorWidget({Key? key, required this.tryAgain}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 16),
        alignment: Alignment.center,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(AssetsSource.appLogo, height: 250),
              const SizedBox(height: 32),
              const Text(
                'Something went wrong. Please try again!',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                  primaryColor,
                )),
                onPressed: tryAgain,
                child: const Text(
                  'Try again',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ]));
  }
}
