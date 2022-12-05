import 'dart:convert';
import 'dart:ffi';
import 'package:blurrycontainer/blurrycontainer.dart';

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:jiffy/jiffy.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Map<String, dynamic>? weathermap;
  Map<String, dynamic>? forecastmap;
  determinePosition() async {
    Position? position;
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    position = await Geolocator.getCurrentPosition();

    setState(() {
      latitude = position!.latitude;
      longitude = position.longitude;
    });
    datafromapi();

    print("langitude: $latitude");
    print(longitude);
  }

  var latitude;
  var longitude;
  datafromapi() async {
    String mylink =
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=f92bf340ade13c087f6334ed434f9761&fbclid=IwAR3Qbmh63CbAq5t3ef1nT6nqLO-SoTtn-IeSJWS5EfIXCdevRlAeMBz1Mz4";

    var response = await http.get(Uri.parse(mylink));
    String forecastlink =
        "https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&units=metric&appid=f92bf340ade13c087f6334ed434f9761&fbclid=IwAR0mv7VFOAcD6ciFaVa2P225sRcNPhgKbvuNnPcsobwPtk7-xlXN7I6mNr4";

    var forcastresponse = await http.get(Uri.parse(forecastlink));

    setState(() {
      weathermap = Map<String, dynamic>.from(jsonDecode(response.body));
      forecastmap = Map<String, dynamic>.from(jsonDecode(forcastresponse.body));
    });
  }

  @override
  void initState() {
    determinePosition();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: weathermap == null && forecastmap == null
            ? Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1512511708753-3150cd2ec8ee?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=580&q=80'),
                      fit: BoxFit.cover),
                ),
                child: Center(child: CircularProgressIndicator()))
            : Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: weathermap!['main']['temp'] > 26
                            ? NetworkImage(
                                "https://images.unsplash.com/photo-1527482797697-8795b05a13fe?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80")
                            : NetworkImage(
                                "https://images.unsplash.com/photo-1590552515252-3a5a1bce7bed?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80"),
                        fit: BoxFit.fitHeight)),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "${Jiffy(DateTime.now()).format("MMMM do yyyy, h:mm a")}\n${weathermap!['name']}",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.09),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              width: MediaQuery.of(context).size.width * 0.18,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                image: DecorationImage(
                                  image: weathermap!['main']['temp'] > 25
                                      ? NetworkImage(
                                          "https://cdn-icons-png.flaticon.com/512/1163/1163662.png")
                                      : weathermap!['main']['temp'] > 18
                                          ? NetworkImage(
                                              "https://cdn-icons-png.flaticon.com/512/1163/1163763.png")
                                          : NetworkImage(
                                              "https://cdn-icons-png.flaticon.com/512/1146/1146860.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            "${weathermap!['main']['temp'].toString().substring(0, 2)}°",
                            style: TextStyle(
                                fontSize: 26,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Feel Likes ${weathermap!['main']['feels_like']}\n${weathermap!['weather'][0]['description']}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Text(
                      "Humidity :${weathermap!['main']['humidity']}, Pressure :${weathermap!['main']['pressure']} ",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Sunrise :${Jiffy(DateTime.fromMillisecondsSinceEpoch(weathermap!['sys']['sunrise'] * 1000)).format("h:mm a")} , Sunset :${Jiffy(DateTime.fromMillisecondsSinceEpoch(weathermap!['sys']['sunset'] * 1000)).format("h:mm a")} ",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 30),
                        height: MediaQuery.of(context).size.height * 0.28,
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: forecastmap!['cnt'],
                            itemBuilder: ((context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: BlurryContainer(
                                  blur: 5,
                                  width:
                                      MediaQuery.of(context).size.height * 0.2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.2,
                                  elevation: 0,
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(8),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20)),
                                  child: Column(
                                    children: [
                                      Text(
                                        "${Jiffy((forecastmap!['list'][index]['dt_txt'])).format("EEE, h:mm a")}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Container(
                                        child: Image.network(
                                            "https://openweathermap.org/img/wn/${forecastmap!['list'][index]['weather'][0]['icon']}@2x.png"),
                                      ),
                                      Text(
                                        "${(forecastmap!['list'][index]['main']['temp_min']).toString().substring(0, 2)}/ ${(forecastmap!['list'][index]['main']['temp_max']).toString().substring(0, 2)}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${(forecastmap!['list'][index]['weather'][0]['description'])}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            })))
                  ],
                ),
              ), //${weathermap!["base"]}
      ),
    );
  }
}
