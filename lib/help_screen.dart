import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moru/app/modules/home/views/home_view.dart';
import 'package:moru/utils/size_helper.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 5), () => Get.to(() => HomeView()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
            image: const AssetImage("assets/bg.png"),
            height: displayHeight(context),
            fit: BoxFit.fitHeight,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: displayHeight(context) * 0.45),
              child: Column(
                children: [
                  const Text(
                    "We show\nweather for you",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () => Get.offAll(() => HomeView()),
                    color: Colors.blue.withOpacity(0.8),
                    child: const Text(
                      "Skip",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
