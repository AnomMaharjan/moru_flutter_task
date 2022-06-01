import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class TemperatureCard extends StatelessWidget {
  final String? iconUrl;
  final double? tempCelsius, tempFarenheit;
  const TemperatureCard(
      {Key? key, this.iconUrl, this.tempCelsius, this.tempFarenheit})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 0.5),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Image(
            image: NetworkImage("$iconUrl"),
            height: 100,
          ),
          AutoSizeText(
            tempFarenheit != null
                ? "$tempFarenheit \u2109"
                : "$tempCelsius \u2103",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
