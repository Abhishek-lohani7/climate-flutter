import 'package:flutter/material.dart';
import 'package:clima/utilities/constants.dart';
import 'package:clima/services/weather.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});

  final locationWeather;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = new WeatherModel();

  int temp;
  String weatherIcon;
  String cityName;
  String weatherMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updadteUI(widget.locationWeather);
  }

  void updadteUI(dynamic weatherData) {
    setState(() {

    if(weatherData == null){
      temp = 0;
      weatherIcon= 'Error';
      weatherMessage = 'Unable to get weather data';
      cityName = '';
      return;
    }
    double temperature = weatherData['main']['temp'];
    temp = temperature.toInt();
     var condition = weatherData['weather'][0]['id'];
     weatherIcon=weather.getWeatherIcon(condition);
     weatherMessage = weather.getMessage(temp);
    cityName = weatherData['name'];

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                Colors.white.withOpacity(0.8), BlendMode.dstATop),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FlatButton(
                    onPressed: () async{
                      var weatherData = await weather.getLocationWeather();
                      updadteUI(weatherData);
                    },
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  FlatButton(
                    onPressed: () async {

                      var typedName=
                      await Navigator.push(context, MaterialPageRoute
                        (builder: (context){
                        return CityScreen();
                      },
                      ),
                      );
                      if (typedName!= null ){
                        weather.getCityWeather(typedName);
                        var weatherData = await weather.getCityWeather(typedName);
                        updadteUI(weatherData);

                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temp°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  '$weatherMessage in $cityName',
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// var temp= jsonDecode(data)['main']['temp'];
// var condition= jsonDecode(data)['weather'][0]['id'];
// var cityName= jsonDecode(data)['name'];