import 'package:flutter/material.dart';

class LocationErrorWidget extends StatelessWidget {
  String? errorText;
  LocationErrorWidget({Key? key, this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.warning,
          size: 40,
          color: Colors.red,
        ),
        Text(
          errorText!,
          textAlign: TextAlign.center,
          style: const TextStyle(
              height: 1.4, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
