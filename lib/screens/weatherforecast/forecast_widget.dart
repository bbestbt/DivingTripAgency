import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }
class WForecast extends StatefulWidget {
  @override
  _WForecastState createState() => _WForecastState();
}

class _WForecastState extends State<WForecast> {
  @override
  String cityname = "";
  String key = "cc27393688bcc7bbe2999c2e9366c65d";
  String dropdownValue = 'Bangkok'; //Default value for the dropdown

  WeatherFactory ws;
  List<Weather> _data = [];
  AppState _state = AppState.NOT_DOWNLOADED;


  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
  }

  void queryForecast() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _state = AppState.DOWNLOADING;
    });

    List<Weather> forecasts = await ws.fiveDayForecastByCityName(cityname);
    setState(() {
      _data = forecasts;
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget _CityInputs() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              margin: EdgeInsets.all(5),
              child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter City'),

                  keyboardType: TextInputType.text,
                  onChanged: _saveCity,
                  onSubmitted: _saveCity)),
        ),
        Icon(Icons.search_outlined)
      ],
    );
  }
  void _saveCity(String input) {
    cityname = input;
    print(cityname);
  }

  void queryWeather() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    setState(() {
      _state = AppState.DOWNLOADING;
    });

    Weather weather = await ws.currentWeatherByCityName(cityname);
    setState(() {
      _data = [weather];
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }




  Widget contentFinishedDownload() {
    String Weathercode = "wi-day-snow";
    //if _data[index].weatherDescription
    return Center(
      child: ListView.separated(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          return //ListTile(
            //title: //Text(_data[index].toString()),
            //Text("Hello Boy!!!"),
            Container(
              decoration: BoxDecoration(
                //color: Colors.grey,
                image : DecorationImage(image: AssetImage('assets/images/'+_data[index].weatherIcon+'.jpg'),fit: BoxFit.cover
                  //image : DecorationImage(image: AssetImage('assets/images/03d.jpg'),fit: BoxFit.cover

                  ),
                border:Border.all(color:Colors.indigo,width:1)

              ),
              child:
                Column(
                      children: [
                        //Icon(WeatherIcons.fromString(Weathercode),size:80,color:Colors.blue),
                        Image(image:NetworkImage('http://openweathermap.org/img/w/'+_data[index].weatherIcon+'.png')),
                        //Text(_data[index].weatherIcon,  style:TextStyle(fontSize:80, fontWeight:FontWeight.w100)),
                        Stack(
                          children: [
                              Text(_data[index].areaName,  style:TextStyle(fontSize:80, fontWeight:FontWeight.w100,foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black)),
                            Text(_data[index].areaName,  style:TextStyle(fontSize:80, fontWeight:FontWeight.w100, color:Colors.white))
                          ]
                        ),
                        Stack(
                            children: [
                              Text(_data[index].weatherDescription,  style:TextStyle(fontSize:60, fontWeight:FontWeight.w100,foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = Colors.black)),
                              Text(_data[index].weatherDescription,  style:TextStyle(fontSize:60, fontWeight:FontWeight.w100, color:Colors.white))
                            ]
                        ),
                        Stack(
                            children: [
                              Text(DateFormat.yMMMMd().format(_data[index].date).toString(),  style:TextStyle(fontSize:60, fontWeight:FontWeight.w100,foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = Colors.black)),
                              Text(DateFormat.yMMMMd().format(_data[index].date).toString(),  style:TextStyle(fontSize:60, fontWeight:FontWeight.w100, color:Colors.white))
                            ]
                        ),
                        Stack(
                            children: [
                              Text(DateFormat.jm().format(_data[index].date).toString(),  style:TextStyle(fontSize:60, fontWeight:FontWeight.w100,foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = Colors.black)),
                              Text(DateFormat.jm().format(_data[index].date).toString(),  style:TextStyle(fontSize:60, fontWeight:FontWeight.w100, color:Colors.white))
                            ]
                        ),
                        Stack(
                            children: [
                              Text(_data[index].temperature.toString(),  style:TextStyle(fontSize:60, fontWeight:FontWeight.w100,foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = Colors.black)),
                              Text(_data[index].temperature.toString(),  style:TextStyle(fontSize:60, fontWeight:FontWeight.w100, color:Colors.white))
                            ]
                        ),
                        Stack(
                            children: [
                              Text("Humidity: "+_data[index].humidity.toString(),  style:TextStyle(fontSize:30, fontWeight:FontWeight.w100,foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 6
                                ..color = Colors.black)),
                              Text("Humidity: "+_data[index].humidity.toString(),  style:TextStyle(fontSize:30, fontWeight:FontWeight.w100, color:Colors.white))
                            ]
                        ),


                ]
              )
            );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
      ),
    );
  }

  Widget contentDownloading() {
    return Container(
      margin: EdgeInsets.all(25),
      child: Column(children: [
        Text(
          'Fetching Weather...',
          style: TextStyle(fontSize: 20),
        ),
        Container(
            margin: EdgeInsets.only(top: 50),
            child: Center(child: CircularProgressIndicator(strokeWidth: 10)))
      ]),
    );
  }

  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Press the button to download the Weather forecast',
          ),
        ],
      ),
    );
  }

  Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == AppState.DOWNLOADING
      ? contentDownloading()
      : contentNotDownloaded();

  Widget _CityDropdown(){
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        },
        );
        _saveCity(dropdownValue);
      },
      items: <String>['Bangkok', 'Phuket', 'Ko Samui', 'Chiang Mai']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          child: TextButton(
            child: Text(
              'Fetch weather',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: queryWeather,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: TextButton(
            child: Text(
              'Fetch forecast',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: queryForecast,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    return Container(
      child: Column(
          children: [
          Column(
            children: [//<Widget>[
              _CityInputs(),
              _CityDropdown(),
              _buttons(),
            Text(
              'Output:',
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              height: 20.0,
              thickness: 2.0,
            ),
            //Expanded(child: _resultView())
                  Container(
                    child: _resultView(),
                      height: 800,
                      width: width,
                  )

          ],
        ),
      ]
      ),
    );
  }
}
