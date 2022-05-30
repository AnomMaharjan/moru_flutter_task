import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:moru/app/modules/home/views/home_view.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
        const Duration(seconds: 5),
        () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => HomeView())));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          CachedNetworkImage(
            imageUrl:
                "https://www.vhv.rs/dpng/d/427-4270068_gold-retro-decorative-frame-png-free-download-transparent.png",

            height: height,
            fit: BoxFit.fitHeight,
          ),
          // Image.network(
          //   "https://www.vhv.rs/dpng/d/427-4270068_gold-retro-decorative-frame-png-free-download-transparent.png",
          //   height: height,
          //   fit: BoxFit.fitHeight,
          // ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: height * 0.5),
              child: Column(
                children: [
                  const Text(
                    "We show weather for you",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => HomeView())),
                    color: Colors.blue.withOpacity(0.8),
                    child: Text(
                      "Skip",
                      style: TextStyle(fontSize: 20),
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
