import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/bg/weather_bg.dart';
import 'package:flutter_weather_bg_null_safety/utils/weather_type.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/model/weather_model.dart';
import 'package:weather_app/service/api_service.dart';
import 'package:weather_app/views/today_weather.dart';


import '../constants/constants.dart';



class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ApiService apiService = ApiService();
  final _textFieldController = TextEditingController();
  String queryText = "auto:ip";

  Future<void> _showTextInputDialog(BuildContext context) async {
    final text = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Search Location'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Search by city, zip"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                if (_textFieldController.text.isEmpty) {
                  return;
                }
                Navigator.pop(context, _textFieldController.text);
              },
            ),
          ],
        );
      },
    );

    if (text != null) {
      setState(() {
        queryText = text;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent.shade100,
        title: const Text(
          " Weather App",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              _textFieldController.clear();
              await _showTextInputDialog(context);
            },
            icon: const Icon(Icons.search, size: 35),
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<WeatherModel>(
          future: apiService.getWeatherData(queryText),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              WeatherModel? weatherModel = snapshot.data;
              return SizedBox(
                width: double.infinity,
                child: Flexible(
                  child: Column(
                    children: [
                      TodaysWeather(weatherModel: weatherModel),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return const Center(
                child: Text("An error occurred",
                    style: TextStyle(color: Colors.white)),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
