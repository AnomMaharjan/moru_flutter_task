import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moru/constants/constants.dart';
import 'package:moru/help_screen.dart';
import 'package:moru/utils/size_helper.dart';
import 'package:moru/widgets/location_error_widget.dart';
import 'package:moru/widgets/temperature_card.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  final HomeController _controller = Get.put(HomeController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text('Weather'),
          centerTitle: true,
          leading: const SizedBox(),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () => Get.to(() => const HelpScreen()),
                icon: const Icon(
                  Icons.help,
                ),
                tooltip: "Help",
              ),
            ),
          ],
        ),
        body: Obx(
          () => ListView(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            children: [
              _controller.isLoading.value
                  ? Center(
                      child: SizedBox(
                          height: displayHeight(context) * 0.3,
                          child: const Center(
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 2,
                            ),
                          )))
                  : _controller.weatherResponse != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                "Temperature in ${_controller.weatherResponse!.location!.name!}",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w800),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TemperatureCard(
                                      tempFarenheit: _controller.degreesInF,
                                      iconUrl:
                                          "https:${_controller.weatherResponse!.current!.condition!.icon}",
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: TemperatureCard(
                                      tempCelsius: _controller.degreesInC,
                                      iconUrl:
                                          "https:${_controller.weatherResponse!.current!.condition!.icon}",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        )
                      : SizedBox(
                          height: displayHeight(context) * 0.3,
                          child: LocationErrorWidget(
                              errorText: _controller.errorText)),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                              hintText: "Search Location"),
                          controller: _controller.searchFieldController,
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Location cannot be empty";
                            } else {
                              return null;
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Flexible(
                        flex: 1,
                        child: _controller.searching.value
                            ? const Center(
                                child: CircularProgressIndicator.adaptive())
                            : MaterialButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                minWidth: displayWidth(context) * 0.6,
                                height: 45,
                                color: Colors.blueAccent.withOpacity(0.7),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    if (_controller.searchFieldController.text
                                            .trim() ==
                                        "") {
                                      if (_controller.locationEnabled!) {
                                        _controller.searchLocation(
                                            "${_controller.latitude},${_controller.longitude}");
                                        _controller.sharedPreferencesManager
                                            .putString("latLong",
                                                "${_controller.latitude},${_controller.longitude}");
                                      } else {
                                        _controller.searchLocation(
                                            "$defaultLatitude,$defaultLongitude");
                                        _controller.sharedPreferencesManager
                                            .putString("latLong",
                                                "$defaultLatitude,$defaultLongitude");
                                      }
                                    } else {
                                      _controller.searchLocation(_controller
                                          .searchFieldController.text
                                          .trim());
                                      _controller.sharedPreferencesManager
                                          .putString(
                                              "latLong",
                                              _controller
                                                  .searchFieldController.text
                                                  .trim());
                                    }
                                  } else {
                                    return;
                                  }
                                },
                                child: const Text(
                                  "Search",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                              ))
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
