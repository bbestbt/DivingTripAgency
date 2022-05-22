import 'package:carousel_slider/carousel_slider.dart';
import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/boat.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/boat.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/hotel.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/roomtype.pbgrpc.dart';
import 'package:diving_trip_agency/screens/diveresort/dialog.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/payment/payment_screen.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:diving_trip_agency/screens/weatherforecast/forecast_widget.dart';
import 'package:weather/weather.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_map/flutter_map.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:diving_trip_agency/screens/ShopCart/ShopcartWidget.dart';
import 'package:latlong2/latlong.dart';

List<RoomType> roomtypes = [];
GetProfileResponse user_profile = new GetProfileResponse();
var profile;
List<TripWithTemplate> details;
GetHotelResponse hotelDetial = new GetHotelResponse();
var hotel;
var boat;
GetBoatResponse boatDetial = new GetBoatResponse();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final TextEditingController _textEditingQuantity = TextEditingController();
final TextEditingController _textEditingDiver = TextEditingController();
enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }
int reservation_id;
double total_price;
var combine = List();

class _ChartData {
  _ChartData(this.day, this.temp);
  final String day;
  final double temp;
}

class DiveResortDetailScreen extends StatefulWidget {
  List<Weather> _data = [];
  double latc, lonc;
  int index;
  List<TripWithTemplate> details;
  DiveResortDetailScreen(int index, List<TripWithTemplate> details) {
    this.details = details;
    this.index = index;
  }

  @override
  State<DiveResortDetailScreen> createState() =>
      _DiveResortDetailScreenState(this.index, this.details);
}

class _DiveResortDetailScreenState extends State<DiveResortDetailScreen> {
  String cityname = "";
  String key = "cc27393688bcc7bbe2999c2e9366c65d";
  WeatherFactory ws;

  List<Weather> _data = [];
  // final MenuController _controller = Get.put(MenuController());
  int index;
  List<TripWithTemplate> details;
  _DiveResortDetailScreenState(int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _controller.scaffoldkey,

        endDrawer: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: SideMenu(),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Header(),
                // SizedBox(height: 30),
                detail(this.index, this.details),
              ],
            ),
          ),
        ));
  }
}

class detail extends StatefulWidget {
  int index;
  List<TripWithTemplate> details;
  detail(int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
  }

  @override
  State<detail> createState() => _detailState(this.index, this.details);
}

class _detailState extends State<detail> {
  String key = '856822fd8e22db5e1ba48c0e7d69844a';
  WeatherFactory ws;
  List<Weather> _data = [];
  AppState _state = AppState.NOT_DOWNLOADED;
  int index;
  List<TripWithTemplate> details;
  String cityname = "Phuket";
  double txtsize = 15;
  double latc, lonc;
  List<_ChartData> tempdata = [];
  _detailState(int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
  }

  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);

    // Future.delayed(Duration.zero, () async {
    //   await getImage();
    // });
  }

  getImage() async {
    combine.add(details[index].tripTemplate.images);
    print('trip');
    print(combine);
    await getBoat();
    combine.add(boatDetial.boat.images);
    print('boat');
    print(combine);
    return combine;
  }

  getData() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = RoomTypeServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));

    var listroomrequest = ListRoomTypesByTripRequest();
    listroomrequest.limit = Int64(20);
    listroomrequest.offset = Int64(0);
    listroomrequest.hotelId = details[widget.index].tripTemplate.hotelId;
    listroomrequest.tripId = details[widget.index].id;
    //  Int64(2);

    roomtypes.clear();
    // print('test');
    try {
      // print('test2');
      await for (var feature in stub.listRoomTypesByTrip(listroomrequest)) {
        // print('test3');
        roomtypes.add(feature.roomType);
        // print(roomtypes);
      }
    } catch (e) {
      print('ERROR: $e');
    }

    return roomtypes;
  }

  getHotelDetail() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = HotelServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var hotelrequest = GetHotelRequest();
    hotelrequest.id = details[widget.index].tripTemplate.hotelId;
    // Int64(2);
    print(hotelrequest.id);
    hotel = await stub.getHotel(hotelrequest);
    hotelDetial = hotel;

    // print(hotelDetial.hotel.name);
    return hotelDetial.hotel.name;
  }

  getBoat() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = BoatServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));

    var listboatrequest = GetBoatRequest();

    listboatrequest.id = details[widget.index].tripTemplate.boatId;

    boat = await stub.getBoat(listboatrequest);
    boatDetial = boat;

    return boatDetial;
  }

  void queryWeather() async {
    /// Removes keyboard
    ///
    cityname = details[widget.index].tripTemplate.address.city;

    FocusScope.of(context).requestFocus(FocusNode());
    var url = "http://api.openweathermap.org/geo/1.0/direct?q=" +
        cityname +
        "&limit=1&appid=" +
        key;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonbody = json.decode(response.body);
      print(jsonbody);
      // var parsedData =
      List loclist = jsonbody;
      //print(loclist[0]['lat']);
      //print(loclist[0]['lon']);
      latc = loclist[0]['lat'];
      lonc = loclist[0]['lon'];
      //print(cityname);
      // print(latc);
      // print(lonc);
      // print(json.decode(response.body));
    }
    setState(() {
      _state = AppState.DOWNLOADING;
    });

    List<Weather> weather = await ws.fiveDayForecastByCityName(cityname);
    //print("_data");
    // print([weather]);
    setState(() {
      _data = weather;

      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget contentFinishedDownload() {
    String Weathercode = "wi-day-snow";

    double txtsize;
    if (kIsWeb) {
      txtsize = 20.0;
    } else {
      txtsize = 15.0;
    }
    tempdata = [];
    for (int i = 0; i < _data.length; i++) {
      //print(_data[0].date.day);
      tempdata.add(_ChartData(
          _data[i].date.day.toString(), _data[i].temperature.celsius));
      //tempdata.add(_ChartData("2", 36));
      //tempdata.add(_ChartData("3", 14));
      //tempdata.add(_ChartData("4", 36));
      //tempdata.add(_ChartData("5", 14));
    }
    print(tempdata);

    //if _data[index].weatherDescription
    return Center(
        child: Column(children: [
      Container(
          child: Text(_data[0].areaName,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w100,
              ))),
      Container(
        child: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Temperature forecast'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_ChartData, String>>[
                LineSeries<_ChartData, String>(
                    dataSource: tempdata,
                    xValueMapper: (_ChartData sales, _) => sales.day,
                    yValueMapper: (_ChartData sales, _) => sales.temp,
                    name: 'Temp',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
        ]),
      ),
      Container(
        height: 150,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _data.length,
          itemBuilder: (context, index) {
            return Container(
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/' +
                            _data[index].weatherIcon +
                            '.jpg'),
                        fit: BoxFit.cover),
                    border: Border.all(color: Colors.indigo, width: 1)),
                child: Column(children: [
                  Image(
                      image: NetworkImage('http://openweathermap.org/img/w/' +
                          _data[index].weatherIcon +
                          '.png')),
                  Stack(children: [
                    Text(DateFormat.Hm().format(_data[index].date).toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black)),
                    Text(DateFormat.Hm().format(_data[index].date).toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            color: Colors.white))
                  ]),
                  Stack(children: [
                    Text(DateFormat.E().format(_data[index].date).toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black)),
                    Text(DateFormat.E().format(_data[index].date).toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            color: Colors.white))
                  ]),
                  Stack(children: [
                    Text(_data[index].temperature.toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black)),
                    Text(_data[index].temperature.toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            color: Colors.white))
                  ]),
                  Stack(children: [
                    Text(_data[index].windGust.toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black)),
                    Text(_data[index].windGust.toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            color: Colors.white))
                  ]),
                ]));
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ),
      Container(
          decoration: BoxDecoration(color: Colors.greenAccent),
          width: MediaQuery.of(context).size.width * 0.9,
          height: 70,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(latc, lonc),
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                attributionBuilder: (_) {
                  return Text("© OpenStreetMap contributors");
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(51.5, -0.09),
                    builder: (ctx) => Container(
                      child: FlutterLogo(),
                    ),
                  ),
                ],
              ),
            ],
          ))
    ]));
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
  CarouselController carouselController = new CarouselController();

  @override
  Widget build(BuildContext context) {
    // print(details[widget.index].tripTemplate.images);
    return Column(
      children: [
        // SectionTitle(
        //   title: "Dive resorts",
        //   color: Color(0xFFFF78a2cc),
        // ),
        SizedBox(height: 20),
        FutureBuilder(
          future: getHotelDetail(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return FittedBox(
                child: Container(
                    height: MediaQuery.of(context).size.height / 2,
                    // padding: EdgeInsets.only(top: 50),
                    child: Stack(
                      children: [
                        CarouselSlider(
                            items: details[widget.index]
                                .tripTemplate
                                .images
                                .map((e) => Container(
                                      child: ClipRRect(
                                        child: Image.network(
                                          e.link.toString(),
                                          fit: BoxFit.cover,
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ))
                                .toList(),
                            options: CarouselOptions(
                                enlargeCenterPage: true,
                                autoPlay: true,
                                aspectRatio: 18 / 8)),
                        AspectRatio(
                          aspectRatio: 18 / 8,
                        )
                      ],
                    )),
              );
            } else {
              return Center(child: Text('no trip images'));
            }
          },
        ),
        SizedBox(height: 20),

        Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          constraints: BoxConstraints(maxWidth: 1110),
          child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  TabBar(
                      indicatorColor: Color(0xfffe8c68),
                      unselectedLabelColor: Color(0xff555555),
                      labelColor: Color(0xfffe8c68),
                      tabs: [
                        Tab(text: "Trip"),
                        Tab(text: "Boat"),
                        Tab(text: "Divesite"),
                        Tab(text: "Room")
                      ]),
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    constraints: BoxConstraints(maxWidth: 1110),
                    child: Container(
                      height: MediaQuery.of(context).size.height / 2,
                      child: TabBarView(
                        children: [
                          Center(
                            child: Container(
                              // decoration: BoxDecoration(
                              // color: Colors.blue[100],
                              // borderRadius: BorderRadius.circular(10)),

                              // height:
                              //     MediaQuery.of(context).size.height / 2,
                              // width: MediaQuery.of(context).size.width / 2,

                              child: FutureBuilder(
                                future: getHotelDetail(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return SingleChildScrollView(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // SizedBox(height: 20),

                                              Text("Trip name : " +
                                                  details[widget.index]
                                                      .tripTemplate
                                                      .name),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Hotel : " +
                                                  hotelDetial.hotel.name),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("From : " +
                                                  DateFormat("dd/MM/yyyy")
                                                      .format(
                                                          details[widget.index]
                                                              .startDate
                                                              .toDateTime())),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("To : " +
                                                  DateFormat("dd/MM/yyyy")
                                                      .format(
                                                          details[widget.index]
                                                              .endDate
                                                              .toDateTime())),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Address : " +
                                                  details[widget.index]
                                                      .tripTemplate
                                                      .address
                                                      .addressLine1),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Address2 : " +
                                                  details[widget.index]
                                                      .tripTemplate
                                                      .address
                                                      .addressLine2),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text('City : ' +
                                                  details[widget.index]
                                                      .tripTemplate
                                                      .address
                                                      .city),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text("Country : " +
                                                  details[widget.index]
                                                      .tripTemplate
                                                      .address
                                                      .country),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text('Region : ' +
                                                  details[widget.index]
                                                      .tripTemplate
                                                      .address
                                                      .region),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text('Postcode : ' +
                                                  details[widget.index]
                                                      .tripTemplate
                                                      .address
                                                      .postcode),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2,
                                                  child: Text(
                                                    "Description : " +
                                                        details[widget.index]
                                                            .tripTemplate
                                                            .description,
                                                    maxLines: 20,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              // Text("Price : " + details[widget.index].price.toString()),
                                              // SizedBox(
                                              //   height: 10,
                                              // ),
                                              Text('Total capacity : ' +
                                                  details[widget.index]
                                                      .maxGuest
                                                      .toString()),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text('Schedule : ' +
                                                  details[widget.index]
                                                      .schedule),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ]),
                                      ),
                                    );
                                  } else {
                                    return Align(
                                        alignment: Alignment.center,
                                        child: Text('no detail'));
                                  }
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            constraints: BoxConstraints(maxWidth: 1110),
                            decoration: BoxDecoration(
                                // color: Colors.teal[100],
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    SizedBox(height: 20),
                                    Container(
                                      // margin: EdgeInsets.symmetric(vertical: 20),
                                      constraints:
                                          BoxConstraints(maxWidth: 1110),
                                      child: FutureBuilder(
                                        future: getBoat(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Container(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 400,
                                                      height: 400,
                                                      child: CarouselSlider(
                                                        options:
                                                            CarouselOptions(
                                                          enlargeCenterPage:
                                                              true,
                                                          enableInfiniteScroll:
                                                              false,
                                                          autoPlay: true,
                                                        ),
                                                        items: boatDetial
                                                            .boat.images
                                                            .map((e) =>
                                                                Image.network(
                                                                  e.link
                                                                      .toString(),
                                                                ))
                                                            .toList(),
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text("Boat name : " +
                                                            boatDetial
                                                                .boat.name),
                                                        SizedBox(height: 10),
                                                        Container(
                                                          width: 500,
                                                          child: Text(
                                                            "Boat description : " +
                                                                boatDetial.boat
                                                                    .description,
                                                            maxLines: 20,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text("Total capacity : " +
                                                            boatDetial.boat
                                                                .totalCapacity
                                                                .toString()),
                                                        SizedBox(height: 10),
                                                        Text("Diver capacity : " +
                                                            boatDetial.boat
                                                                .diverCapacity
                                                                .toString()),
                                                        SizedBox(height: 10),
                                                        Text("Staff capacity : " +
                                                            boatDetial.boat
                                                                .staffCapacity
                                                                .toString()),
                                                        SizedBox(height: 10),
                                                        Text("Address line 1 : " +
                                                            boatDetial
                                                                .boat
                                                                .address
                                                                .addressLine1),
                                                        SizedBox(height: 10),
                                                        Text("Address line 2 : " +
                                                            boatDetial
                                                                .boat
                                                                .address
                                                                .addressLine2),
                                                        SizedBox(height: 10),
                                                        Text("Country : " +
                                                            boatDetial
                                                                .boat
                                                                .address
                                                                .country),
                                                        SizedBox(height: 10),
                                                        Text("City: " +
                                                            boatDetial.boat
                                                                .address.city),
                                                        SizedBox(height: 10),
                                                        Text("Region : " +
                                                            boatDetial
                                                                .boat
                                                                .address
                                                                .region),
                                                        SizedBox(height: 10),
                                                        Text("Postcode: " +
                                                            boatDetial
                                                                .boat
                                                                .address
                                                                .postcode),
                                                        SizedBox(height: 10),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          } else {
                                            return Center(
                                                child: Text('no boat detail'));
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            child: FutureBuilder(
                              future: getHotelDetail(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Center(
                                      child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Container(
                                            child: Column(children: <Widget>[
                                          Container(
                                              child: Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                2,
                                            child: ListView.builder(
                                              itemCount: details[widget.index]
                                                  .diveSites
                                                  .length,
                                              itemBuilder: (context, each) {
                                                return Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: SingleChildScrollView(
                                                    child: Card(
                                                      // color: Colors
                                                      //     .deepPurple[100],
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12.0),
                                                      ),
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Container(
                                                          child: Column(
                                                            children: [
                                                              SizedBox(
                                                                  height: 20),
                                                              Row(
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            8.0,
                                                                        right:
                                                                            10),
                                                                    child: Text(
                                                                      "Divesite " +
                                                                          ((each + 1)
                                                                              .toString()),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              20),
                                                                    ),
                                                                  ),
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text("Name : " +
                                                                          details[widget.index]
                                                                              .diveSites[each]
                                                                              .name),
                                                                      Container(
                                                                        alignment:
                                                                            Alignment.topLeft,
                                                                        width:
                                                                            500,
                                                                        child: details[widget.index].diveSites[each].description ==
                                                                                ''
                                                                            ? Text('Description : - ')
                                                                            : Text(
                                                                                "Description : " + details[widget.index].diveSites[each].description,
                                                                                maxLines: 20,
                                                                                overflow: TextOverflow.ellipsis,
                                                                              ),
                                                                      ),
                                                                      details[widget.index].diveSites[each].maxDepth ==
                                                                              0
                                                                          ? Text(
                                                                              "Max Dept : - ")
                                                                          : Text("Max Dept : " +
                                                                              details[widget.index].diveSites[each].maxDepth.toString()),
                                                                      details[widget.index].diveSites[each].minDepth ==
                                                                              0
                                                                          ? Text(
                                                                              "Min Dept : - ")
                                                                          : Text("Min Dept : " +
                                                                              details[widget.index].diveSites[each].minDepth.toString()),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                  height: 20),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ))
                                        ])),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ));
                                } else {
                                  return Center(child: Text(' no divesite '));
                                }
                              },
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 20),
                            constraints: BoxConstraints(maxWidth: 1110),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    FutureBuilder(
                                      future: getData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return Center(
                                              child: Container(
                                                  child: SingleChildScrollView(
                                            // scrollDirection: Axis.horizontal,
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 500,
                                                  child: FutureBuilder(
                                                    future: getHotelDetail(),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasData) {
                                                        return CarouselSlider(
                                                            items: hotelDetial
                                                                .hotel.images
                                                                .map((e) =>
                                                                    Container(
                                                                      child:
                                                                          ClipRRect(
                                                                        child: Image
                                                                            .network(
                                                                          e.link
                                                                              .toString(),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                    ))
                                                                .toList(),
                                                            options:
                                                                CarouselOptions(
                                                              viewportFraction:
                                                                  1,
                                                              autoPlay:
                                                                  true,
                                                            ));
                                                      } else {
                                                        return Center(
                                                            child: Text(
                                                                'no hotel image'));
                                                      }
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Wrap(
                                                    spacing: 20,
                                                    runSpacing: 40,
                                                    children: List.generate(
                                                      roomtypes.length,
                                                      (candy) => Center(
                                                        child: InfoCard(candy,
                                                            details, index),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          )));
                                        } else {
                                          return Center(
                                              child: Text(' no room '));
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
        ),

//old
        // Container(
        //   margin: EdgeInsets.symmetric(vertical: 20),
        //   constraints: BoxConstraints(maxWidth: 1110),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       SizedBox(width: 20),
        //       Expanded(
        //         flex: 2,
        //         child: LayoutBuilder(
        //           builder: (context, constraints) => Container(
        //             child: Center(
        //               child: Container(
        //                 decoration: BoxDecoration(
        //                     color: Colors.blue[100],
        //                     borderRadius: BorderRadius.circular(20)),
        //                 // color: Colors.blue[100],
        //                 height: MediaQuery.of(context).size.height / 2,
        //                 width: MediaQuery.of(context).size.width / 2,
        //                 child: FutureBuilder(
        //                   future: getHotelDetail(),
        //                   builder: (context, snapshot) {
        //                     if (snapshot.hasData) {
        //                       return SingleChildScrollView(
        //                         child: Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: [
        //                             SizedBox(height: 20),
        //                             Align(
        //                               alignment: Alignment.topLeft,
        //                               child: Text(
        //                                 "Trip detail",
        //                                 style: TextStyle(fontSize: 20),
        //                               ),
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 10),
        //                               child: Text("Trip name : " +
        //                                   details[widget.index]
        //                                       .tripTemplate
        //                                       .name),
        //                             ),
        //                             SizedBox(
        //                               height: 10,
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 10),
        //                               child: Text("Hotel : " +
        //                                   // details[widget.index].tripTemplate.hotelId.toString()),
        //                                   hotelDetial.hotel.name),
        //                             ),
        //                             SizedBox(
        //                               height: 10,
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 10),
        //                               child: Text("From : " +
        //                                   DateFormat("dd/MM/yyyy").format(
        //                                       details[widget.index]
        //                                           .startDate
        //                                           .toDateTime())),
        //                             ),
        //                             SizedBox(
        //                               height: 10,
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 10),
        //                               child: Text("To : " +
        //                                   DateFormat("dd/MM/yyyy").format(
        //                                       details[widget.index]
        //                                           .endDate
        //                                           .toDateTime())),
        //                             ),
        //                             SizedBox(
        //                               height: 10,
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 10),
        //                               child: Text("Address : " +
        //                                   details[widget.index]
        //                                       .tripTemplate
        //                                       .address
        //                                       .addressLine1),
        //                             ),
        //                             SizedBox(
        //                               height: 10,
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 10),
        //                               child: Text("Address2 : " +
        //                                   details[widget.index]
        //                                       .tripTemplate
        //                                       .address
        //                                       .addressLine2),
        //                             ),
        //                             SizedBox(
        //                               height: 10,
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 10),
        //                               child: Text('City : ' +
        //                                   details[widget.index]
        //                                       .tripTemplate
        //                                       .address
        //                                       .city),
        //                             ),
        //                             SizedBox(
        //                               height: 10,
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 10),
        //                               child: Text("Country : " +
        //                                   details[widget.index]
        //                                       .tripTemplate
        //                                       .address
        //                                       .country),
        //                             ),
        //                             SizedBox(
        //                               height: 10,
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 10),
        //                               child: Text('Region : ' +
        //                                   details[widget.index]
        //                                       .tripTemplate
        //                                       .address
        //                                       .region),
        //                             ),
        //                             SizedBox(
        //                               height: 10,
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 10),
        //                               child: Text('Postcode : ' +
        //                                   details[widget.index]
        //                                       .tripTemplate
        //                                       .address
        //                                       .postcode),
        //                             ),
        //                             SizedBox(
        //                               height: 10,
        //                             ),
        //                             Padding(
        //                               padding: const EdgeInsets.only(left: 10),
        //                               child: Container(
        //                                   width:
        //                                       MediaQuery.of(context).size.width,
        //                                   child: Text(
        //                                     "Description : " +
        //                                         details[widget.index]
        //                                             .tripTemplate
        //                                             .description,
        //                                     // textAlign: TextAlign.center,
        //                                     maxLines: 20,
        //                                     overflow: TextOverflow.ellipsis,
        //                                   )),
        //                             ),
        //                             SizedBox(
        //                               height: 10,
        //                             ),

        //                             // Text("Price : " + details[widget.index].price.toString()),
        //                             // SizedBox(
        //                             //   height: 10,
        //                             // ),
        //                             // SingleChildScrollView(
        //                             //   scrollDirection: Axis.horizontal,
        //                             //   child: Row(
        //                             //     mainAxisAlignment: MainAxisAlignment.center,
        //                             //     children: [
        //                             //       SizedBox(
        //                             //         width: 10,
        //                             //       ),
        //                             //       Container(
        //                             //         width: MediaQuery.of(context).size.width,
        //                             //         height: MediaQuery.of(context).size.height / 5,
        //                             //         child: ListView.builder(
        //                             //           scrollDirection: Axis.horizontal,
        //                             //           itemBuilder: (BuildContext ctx, int each) {
        //                             //             return SingleChildScrollView(
        //                             //               scrollDirection: Axis.horizontal,
        //                             //               child: Row(
        //                             //                 children: [
        //                             //                   Container(
        //                             //                     width:
        //                             //                         MediaQuery.of(context).size.width /
        //                             //                             5,
        //                             //                     height:
        //                             //                         MediaQuery.of(context).size.height /
        //                             //                             5,
        //                             //                     child: Image.network(
        //                             //                         details[widget.index]
        //                             //                             .tripTemplate
        //                             //                             .images[each]
        //                             //                             .link
        //                             //                             .toString()),
        //                             //                   ),
        //                             //                 ],
        //                             //               ),
        //                             //             );
        //                             //           },
        //                             //           itemCount: details[widget.index]
        //                             //               .tripTemplate
        //                             //               .images
        //                             //               .length,
        //                             //         ),
        //                             //       ),
        //                             //     ],
        //                             //   ),
        //                             // ),
        //                           ],
        //                         ),
        //                       );
        //                     } else {
        //                       return Align(
        //                           alignment: Alignment.center,
        //                           child: Text('no divesites '));
        //                     }
        //                   },
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //       SizedBox(width: 20),
        //       Expanded(
        //         flex: 3,
        //         child: LayoutBuilder(
        //           builder: (context, constraints) => Container(
        //             // color: Colors.white,
        //             child: SizedBox(
        //               width: MediaQuery.of(context).size.width / 2,
        //               child: FutureBuilder(
        //                 future: getHotelDetail(),
        //                 builder: (context, snapshot) {
        //                   if (snapshot.hasData) {
        //                     return Center(
        //                         child: Column(
        //                       children: [
        //                         // Text(
        //                         //   "Divesites",
        //                         //   style: TextStyle(fontSize: 20),
        //                         // ),
        //                         // SizedBox(height: 10),
        //                         SingleChildScrollView(
        //                             child: Container(
        //                                 child: Column(children: <Widget>[
        //                           Container(
        //                               child: Container(
        //                             padding: EdgeInsets.symmetric(
        //                               horizontal: 16.0,
        //                             ),
        //                             //vertical: 24.0
        //                             // height:
        //                             //     MediaQuery.of(context).size.height *
        //                             //         0.25,
        //                             height:
        //                                 MediaQuery.of(context).size.height / 2,
        //                             child: ListView.builder(
        //                               // scrollDirection: Axis.horizontal,
        //                               itemCount: details[widget.index]
        //                                   .diveSites
        //                                   .length,
        //                               itemBuilder: (context, each) {
        //                                 return Container(
        //                                   width: MediaQuery.of(context)
        //                                           .size
        //                                           .width *
        //                                       0.25,
        //                                   child: SingleChildScrollView(
        //                                     child: Card(
        //                                       color: Colors.deepPurple[100],
        //                                       shape: RoundedRectangleBorder(
        //                                         borderRadius:
        //                                             BorderRadius.circular(12.0),
        //                                       ),
        //                                       // elevation: 8,
        //                                       child: SingleChildScrollView(
        //                                         scrollDirection:
        //                                             Axis.horizontal,
        //                                         child: Container(
        //                                           child: Column(
        //                                             children: [
        //                                               SizedBox(height: 20),
        //                                               Row(
        //                                                 children: [
        //                                                   Padding(
        //                                                     padding:
        //                                                         const EdgeInsets
        //                                                                 .only(
        //                                                             left: 8.0,
        //                                                             right: 10),
        //                                                     child: Text(
        //                                                       "Divesite " +
        //                                                           ((each + 1)
        //                                                               .toString()),
        //                                                       style: TextStyle(
        //                                                           fontSize: 20),
        //                                                     ),
        //                                                   ),
        //                                                   Column(
        //                                                     crossAxisAlignment:
        //                                                         CrossAxisAlignment
        //                                                             .start,
        //                                                     children: [
        //                                                       Text("Name : " +
        //                                                           details[widget
        //                                                                   .index]
        //                                                               .diveSites[
        //                                                                   each]
        //                                                               .name),
        //                                                       Container(
        //                                                         alignment:
        //                                                             Alignment
        //                                                                 .topLeft,
        //                                                         width: 500,
        //                                                         child: Text(
        //                                                           "Description : " +
        //                                                               details[widget
        //                                                                       .index]
        //                                                                   .diveSites[
        //                                                                       each]
        //                                                                   .description,
        //                                                           maxLines: 20,
        //                                                           overflow:
        //                                                               TextOverflow
        //                                                                   .ellipsis,
        //                                                         ),
        //                                                       ),
        //                                                       Text("Max Dept : " +
        //                                                           details[widget
        //                                                                   .index]
        //                                                               .diveSites[
        //                                                                   each]
        //                                                               .maxDepth
        //                                                               .toString()),
        //                                                       Text("Min Dept : " +
        //                                                           details[widget
        //                                                                   .index]
        //                                                               .diveSites[
        //                                                                   each]
        //                                                               .minDepth
        //                                                               .toString()),
        //                                                     ],
        //                                                   ),
        //                                                 ],
        //                                               ),
        //                                               SizedBox(height: 20),
        //                                             ],
        //                                           ),
        //                                         ),
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 );
        //                               },
        //                             ),
        //                           ))
        //                         ]))),
        //                         // Container(
        //                         //   child: CarouselSlider(
        //                         //     options: CarouselOptions(
        //                         //       enlargeCenterPage: true,
        //                         //       enableInfiniteScroll: false,
        //                         //       autoPlay: true,
        //                         //     ),
        //                         //     items: details[widget.index]
        //                         //         .tripTemplate
        //                         //         .images
        //                         //         .map((e) =>
        //                         //             //  Text(e.filename)
        //                         //             Container(
        //                         //               width: 500,
        //                         //               height: 500,
        //                         //               child: Image.network(
        //                         //                 e.link.toString(),
        //                         //                 // fit: BoxFit.cover,
        //                         //               ),
        //                         //             ))
        //                         //         .toList(),
        //                         //   ),
        //                         // ),
        //                         // Text(
        //                         //   "Trip images",
        //                         //   style: TextStyle(fontSize: 20),
        //                         // ),
        //                         // SizedBox(height: 20),
        //                         // SingleChildScrollView(
        //                         //   child: Container(
        //                         //     child: Column(
        //                         //       children: <Widget>[
        //                         //         Container(
        //                         //           child: Container(
        //                         //             padding: EdgeInsets.symmetric(
        //                         //                 horizontal: 16.0, vertical: 24.0),
        //                         //             height:
        //                         //                 MediaQuery.of(context).size.height * 0.50,
        //                         //             child: ListView.builder(
        //                         //               scrollDirection: Axis.horizontal,
        //                         //               itemCount: details[widget.index]
        //                         //                   .tripTemplate
        //                         //                   .images
        //                         //                   .length,
        //                         //               itemBuilder: (context, each) {
        //                         //                 return Container(
        //                         //                   width:
        //                         //                       MediaQuery.of(context).size.width *
        //                         //                           0.5,
        //                         //                   child: Card(
        //                         //                     child: Container(
        //                         //                       child: Image.network(
        //                         //                           details[widget.index]
        //                         //                               .tripTemplate
        //                         //                               .images[each]
        //                         //                               .link
        //                         //                               .toString()),
        //                         //                     ),
        //                         //                   ),
        //                         //                 );
        //                         //               },
        //                         //             ),
        //                         //           ),
        //                         //         ),
        //                         //       ],
        //                         //     ),
        //                         //   ),
        //                         // ),
        //                         SizedBox(height: 20),

        //                         SizedBox(
        //                           height: 10,
        //                         ),
        //                       ],
        //                     ));
        //                   } else {
        //                     return Center(child: Text(' '));
        //                   }
        //                 },
        //               ),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),
        // Container(
        //   margin: EdgeInsets.symmetric(vertical: 20),
        //   constraints: BoxConstraints(maxWidth: 1110),
        //   decoration: BoxDecoration(
        //       color: Colors.teal[100], borderRadius: BorderRadius.circular(20)),
        //   child: Padding(
        //     padding: const EdgeInsets.only(left: 8.0),
        //     child: Column(
        //       children: [
        //         SizedBox(height: 20),
        //         Align(
        //           alignment: Alignment.topLeft,
        //           child: Text(
        //             "Boat detail",
        //             style: TextStyle(fontSize: 20),
        //           ),
        //         ),
        //         SizedBox(height: 10),
        //         Container(
        //           // margin: EdgeInsets.symmetric(vertical: 20),
        //           constraints: BoxConstraints(maxWidth: 1110),
        //           child: FutureBuilder(
        //             future: getBoat(),
        //             builder: (context, snapshot) {
        //               if (snapshot.hasData) {
        //                 return SingleChildScrollView(
        //                   scrollDirection: Axis.horizontal,
        //                   child: Container(
        //                     child: Row(
        //                       children: [
        //                         Container(
        //                           width: 400,
        //                           height: 400,
        //                           child: CarouselSlider(
        //                             options: CarouselOptions(
        //                               enlargeCenterPage: true,
        //                               enableInfiniteScroll: false,
        //                               autoPlay: true,
        //                             ),
        //                             items: boatDetial.boat.images
        //                                 .map((e) => Image.network(
        //                                       e.link.toString(),
        //                                     ))
        //                                 .toList(),
        //                           ),
        //                         ),
        //                         Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: <Widget>[
        //                             Text("Boat name : " + boatDetial.boat.name),
        //                             SizedBox(height: 10),
        //                             Container(
        //                               width: 500,
        //                               child: Text(
        //                                 "Boat description : " +
        //                                     boatDetial.boat.description,
        //                                 maxLines: 20,
        //                                 overflow: TextOverflow.ellipsis,
        //                               ),
        //                             ),
        //                             SizedBox(height: 10),
        //                             Text("Total capacity : " +
        //                                 boatDetial.boat.totalCapacity
        //                                     .toString()),
        //                             SizedBox(height: 10),
        //                             Text("Diver capacity : " +
        //                                 boatDetial.boat.diverCapacity
        //                                     .toString()),
        //                             SizedBox(height: 10),
        //                             Text("Staff capacity : " +
        //                                 boatDetial.boat.staffCapacity
        //                                     .toString()),
        //                             SizedBox(height: 10),
        //                             Text("Address line 1 : " +
        //                                 boatDetial.boat.address.addressLine1),
        //                             SizedBox(height: 10),
        //                             Text("Address line 2 : " +
        //                                 boatDetial.boat.address.addressLine2),
        //                             SizedBox(height: 10),
        //                             Text("Country : " +
        //                                 boatDetial.boat.address.country),
        //                             SizedBox(height: 10),
        //                             Text("City: " +
        //                                 boatDetial.boat.address.city),
        //                             SizedBox(height: 10),
        //                             Text("Region : " +
        //                                 boatDetial.boat.address.region),
        //                             SizedBox(height: 10),
        //                             Text("Postcode: " +
        //                                 boatDetial.boat.address.postcode),
        //                             SizedBox(height: 10),

        //                             // Row(
        //                             //     mainAxisAlignment: MainAxisAlignment.center,
        //                             //     children: <Widget>[
        //                             //       RaisedButton(
        //                             //         textColor: Colors.white,
        //                             //         color: Colors.pink,
        //                             //         child: Text("Previous"),
        //                             //         onPressed: () {
        //                             //           carouselController.previousPage();
        //                             //         },
        //                             //       ),
        //                             //       SizedBox(
        //                             //         width: 15,
        //                             //       ),
        //                             //       RaisedButton(
        //                             //         textColor: Colors.white,
        //                             //         color: Colors.pink,
        //                             //         child: Text("Next"),
        //                             //         onPressed: () {
        //                             //           carouselController.nextPage();
        //                             //         },
        //                             //       ),
        //                             // ])
        //                           ],
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 );
        //               } else {
        //                 return Center(child: Text('no boat details'));
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // // SizedBox(height: 10),

        // // Container(
        // //     width: MediaQuery.of(context).size.width / 4,
        // //     height: MediaQuery.of(context).size.width / 4,
        // //     child: details[widget.index].tripTemplate.images[0] == null
        // //         ? new Container(
        // //             color: Colors.pink,
        // //           )
        // //         : Image.network(
        // //             // 'http://139.59.101.136/static/'+
        // //             details[widget.index]
        // //                 .tripTemplate
        // //                 .images[0]
        // //                 .link
        // //                 .toString())),
        // // SizedBox(
        // //   width: 10,
        // // ),
        // // Container(
        // //     width: MediaQuery.of(context).size.width / 4,
        // //     height: MediaQuery.of(context).size.width / 4,
        // //     child: details[widget.index].tripTemplate.images[1] == null
        // //         ? new Container(
        // //             color: Colors.pink,
        // //           )
        // //         : Image.network(
        // //             // 'http://139.59.101.136/static/'+
        // //             details[widget.index]
        // //                 .tripTemplate
        // //                 .images[1]
        // //                 .link
        // //                 .toString())),
        // // SizedBox(
        // //   width: 10,
        // // ),
        // // Container(
        // //     width: MediaQuery.of(context).size.width / 4,
        // //     height: MediaQuery.of(context).size.width / 4,
        // //     child: details[widget.index].tripTemplate.images[2] == null
        // //         ? new Container(
        // //             color: Colors.pink,
        // //           )
        // //         : Image.network(
        // //             // 'http://139.59.101.136/static/'+
        // //             details[widget.index]
        // //                 .tripTemplate
        // //                 .images[2]
        // //                 .link
        // //                 .toString())),
        // // SizedBox(
        // //   width: 10,
        // // ),
        // // Container(
        // //     width: MediaQuery.of(context).size.width / 4,
        // //     height: MediaQuery.of(context).size.width / 4,
        // //     child: details[widget.index].tripTemplate.images[3] == null
        // //         ? new Container(
        // //             color: Colors.pink,
        // //           )
        // //         : Image.network(
        // //             // 'http://139.59.101.136/static/'+
        // //             details[widget.index]
        // //                 .tripTemplate
        // //                 .images[3]
        // //                 .link
        // //                 .toString())),
        // // SizedBox(
        // //   width: 10,
        // // ),
        // // Container(
        // //     width: MediaQuery.of(context).size.width / 4,
        // //     height: MediaQuery.of(context).size.width / 4,
        // //     child: details[widget.index].tripTemplate.images[4] == null
        // //         ? new Container(
        // //             color: Colors.pink,
        // //           )
        // //         : Image.network(
        // //             // 'http://139.59.101.136/static/'+
        // //             details[widget.index]
        // //                 .tripTemplate
        // //                 .images[4]
        // //                 .link
        // //                 .toString())),
        // // SizedBox(
        // //   width: 10,
        // // ),
        // // Container(
        // //     width: MediaQuery.of(context).size.width / 4,
        // //     height: MediaQuery.of(context).size.width / 4,
        // //     child: details[widget.index].tripTemplate.images[5] == null
        // //         ? new Container(
        // //             color: Colors.pink,
        // //           )
        // //         : Image.network(
        // //             // 'http://139.59.101.136/static/'+
        // //             details[widget.index]
        // //                 .tripTemplate
        // //                 .images[5]
        // //                 .link
        // //                 .toString())),
        // // SizedBox(
        // //   width: 10,
        // // ),
        // // Container(
        // //     width: MediaQuery.of(context).size.width / 4,
        // //     height: MediaQuery.of(context).size.width / 4,
        // //     child: details[widget.index].tripTemplate.images[6] == null
        // //         ? new Container(
        // //             color: Colors.pink,
        // //           )
        // //         : Image.network(
        // //             // 'http://139.59.101.136/static/'+
        // //             details[widget.index]
        // //                 .tripTemplate
        // //                 .images[6]
        // //                 .link
        // //                 .toString())),

        // //  RaisedButton(
        // //           onPressed: () {
        // //            getHotelDetail();
        // //           },
        // //           color: Colors.amber,
        // //           shape: RoundedRectangleBorder(
        // //               borderRadius: BorderRadius.circular(10)),
        // //           child: Text("get hotel"),
        // //         ),
        // Container(
        //   // margin: EdgeInsets.symmetric(vertical: 20),
        //   constraints: BoxConstraints(maxWidth: 1110),
        //   child: Align(
        //     alignment: Alignment.topLeft,
        //     child: Text(
        //       "Room types",
        //       style: TextStyle(fontSize: 20),
        //     ),
        //   ),
        // ),
        // SizedBox(height: 20),
        // Container(
        //   // margin: EdgeInsets.symmetric(vertical: 20),
        //   constraints: BoxConstraints(maxWidth: 1110),
        //   // decoration: BoxDecoration(
        //   //     color: Color(0xFFFF89cfef),
        //   //     borderRadius: BorderRadius.circular(10)),
        //   child: Padding(
        //     padding: const EdgeInsets.all(10),
        //     child: Column(
        //       children: [
        //         FutureBuilder(
        //           future: getData(),
        //           builder: (context, snapshot) {
        //             if (snapshot.hasData) {
        //               return Center(
        //                   child: Container(
        //                       child: SingleChildScrollView(
        //                 scrollDirection: Axis.horizontal,
        //                 child: Wrap(
        //                     spacing: 20,
        //                     runSpacing: 40,
        //                     children: List.generate(
        //                       roomtypes.length,
        //                       (candy) => Center(
        //                         child: InfoCard(candy, details, index),
        //                       ),
        //                     )),
        //               )));
        //             } else {
        //               return Center(
        //                   child: CircularProgressIndicator(strokeWidth: 10));
        //               //  Align(
        //               //     alignment: Alignment.center,
        //               //     child: Text(' '));
        //             }
        //           },
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        // SizedBox(
        //   height: 20,
        // ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            constraints: BoxConstraints(maxWidth: 1110),
            decoration: BoxDecoration(
                // color: Colors.white,
                color: Color(0xFFFdaf0ff),
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width,
            child: Container(
              child: Column(children: [
                Text("5-day weather forecast"),
                Text("Weather example"),
                Container(
                  margin: EdgeInsets.all(5),
                  child: TextButton(
                    child: Text(
                      'Fetch forecast',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: queryWeather,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                  ),
                ),
                Container(
                  child: _resultView(),
                )
              ]),
            ))
      ],
    );
  }
}

class InfoCard extends StatefulWidget {
  List<TripWithTemplate> details;
  int indexRoom;
  int indexDetail;

  //  InfoCard({
  //   this.index,
  // });
  InfoCard(int indexRoom, List<TripWithTemplate> details, int indexDetail) {
    this.indexRoom = indexRoom;
    this.details = details;
    this.indexDetail = indexDetail;
    // print(details);
    // print(indexRoom);
    // for (int i =0;i<details.length;i++){
    //   print('index detail');
    //   print(indexDetail);
    //   print('price');
    //   print(details[i].price);
    // }
  }

  @override
  State<InfoCard> createState() =>
      _InfoCardState(this.indexRoom, this.details, this.indexDetail);
}

class _InfoCardState extends State<InfoCard> {
  List<TripWithTemplate> details;
  int indexRoom;
  int indexDetail;
  _InfoCardState(this.indexRoom, this.details, this.indexDetail);

  getProfile() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');
    final pf = AccountClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    profile = await pf.getProfile(new Empty());

    user_profile = profile;
    return user_profile;
  }

  bookTrips() async {
    await getProfile();
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = ReservationServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));

    var room = Reservation_Room();
    for (int i = 0; i < roomtypes.length; i++) {
      room.quantity = int.parse(_textEditingQuantity.text);
      room.roomTypeId = roomtypes[indexRoom].id;
      room.noDivers = int.parse(_textEditingDiver.text);
      // print(room.quantity);
      // print(room.noDivers);
    }

    var reservation = Reservation()..rooms.add(room);
    reservation.tripId = details[indexDetail].id;
    // Int64(28);
    reservation.diverId = user_profile.diver.id;
    reservation.price =
        details[indexDetail].tripRoomTypePrices[indexRoom].price *
            int.parse(_textEditingQuantity.text);
    // (roomtypes[indexRoom].price * int.parse(_textEditingQuantity.text)) +
    //     details[indexDetail].price;
    reservation.totalDivers = Int64(int.parse(_textEditingDiver.text));

    var bookRequest = CreateReservationRequest()..reservation = reservation;

    try {
      var response = await stub.createReservation(bookRequest);
      print('response: ${response}');
      print('book');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PaymentScreen(
                  reservation_id,
                  details[indexDetail].tripRoomTypePrices[indexRoom].price *
                      int.parse(_textEditingQuantity.text),
                  details[indexDetail])));
      // print('id');
      // print(bookRequest.reservation.id);
      // print(response.reservation.id);
      reservation_id = int.parse(response.reservation.id.toString());
      total_price = total_price = response.reservation.price;
      // print(reservation_id);
      return [reservation_id, total_price];
    } on GrpcError catch (e) {
      // Handle exception of type GrpcError
      print('codeName: ${e.codeName}');
      print('details: ${e.details}');
      print('message: ${e.message}');
      print('rawResponse: ${e.rawResponse}');
      print('trailers: ${e.trailers}');
     showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(e.message),
            actions: <Widget>[],
          );
        });
    } catch (e) {
      print(e);
    }
  }

  Future<void> showInformationDialog(BuildContext context) async {
    // print(details.length);
    return await showDialog(
        context: context,
        builder: (context) {
          // bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _textEditingQuantity,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration:
                            InputDecoration(hintText: "Enter room quantity"),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _textEditingDiver,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration:
                            InputDecoration(hintText: "Enter number of diver"),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Confirmation"),
                      //     Checkbox(
                      //         value: isChecked,
                      //         onChanged: (checked) {
                      //           setState(() {
                      //             isChecked = checked;
                      //           });
                      //         })
                      //   ],
                      // )
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('Add room to cart'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      final box = Hive.box('userInfo');
                      Cartlist.add([
                        /*
                        details[indexDetail].tripTemplate.images.length == 0
                            ? new Container(
                                color: Colors.pink,
                              )
                            : Image.network(details[indexDetail]
                                .tripTemplate
                                .images[0]
                                .link
                                .toString()),//0*/

                        details[indexDetail].tripTemplate.images.length == 0
                            ? ""
                            : details[indexDetail]
                                .tripTemplate
                                .images[0]
                                .link
                                .toString(), //0
                        details[indexDetail].tripTemplate.name, //1
                        hotelDetial.hotel.name, //2
                        roomtypes[indexRoom].name, //3
                        // (roomtypes[indexRoom].price *
                        //         int.parse(_textEditingQuantity.text)) +
                        //     details[indexDetail].price,
                        details[indexDetail]
                                .tripRoomTypePrices[indexRoom]
                                .price *
                            int.parse(_textEditingQuantity.text), //4
                        //details,
                        /* jsonEncode((details as List<TripWithTemplate>)
                            .map((e) => e.toProto3Json())
                            .toList())*/
                        "", //5
                        //roomtypes,
                        /*jsonEncode((roomtypes as List<RoomType>)
                            .map((e) => e.toProto3Json())
                            .toList())*/
                        "", //6

                        indexRoom, //7
                        indexDetail, //8
                        int.parse(_textEditingQuantity.text), //9
                        int.parse(_textEditingDiver.text), //10
                        roomtypes[indexRoom].id.toInt(), //11
                        details[indexDetail].id.toInt(), //12
                        box.get("usernanme"), //13
                      ]);
                      // print("Cartlist: ");
                      //print(Cartlist);
                      //print("Cartlist[0][2]: ");
                      //print(Cartlist[0][2]);
                      //print("Cartlist[0][1]: ");
                      //print(Cartlist[0][1]);
                      // Do something like updating SharedPreferences or User Settings etc.
                      Navigator.of(context).pop();
                    }
                  },
                ),
                TextButton(
                  child: Text('Book'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // print(details[indexDetail].price);
                      // print('--');
                      // print((roomtypes[indexRoom].price *
                      //     int.parse(_textEditingQuantity.text)));
                      // print((roomtypes[indexRoom].price *
                      //         int.parse(_textEditingQuantity.text)) +
                      //     details[indexDetail].price);
                      await bookTrips();
                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return AlertDialog(
                      //         title: Text("Booking"),
                      //         content: Text("done"),
                      //         actions: <Widget>[
                      //           // FlatButton(
                      //           //child: Text("OK"),
                      //           //     ),
                      //         ],
                      //       );
                      //     });

                      // Navigator.of(context).pop();

                    }
                  },
                ),
              ],
            );
          });
        });
  }

  getHotelDetail() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = HotelServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var hotelrequest = GetHotelRequest();
    hotelrequest.id = details[widget.indexDetail].tripTemplate.hotelId;
    // Int64(2);
    print(hotelrequest.id);
    hotel = await stub.getHotel(hotelrequest);
    hotelDetial = hotel;

    // print(hotelDetial.hotel.name);
    return hotelDetial.hotel.name;
  }

  @override
  Widget build(BuildContext context) {
    // for (int i = 0; i < roomtypes.length; i++) {
    //   print(roomtypes);
    // }
    return InkWell(
      child: Container(
        // constraints: BoxConstraints(
        //   maxHeight: double.infinity,
        //   maxWidth: double.infinity,
        //   minHeight: 320, //minimum height
        //   minWidth: 500, // minimum width
        // ),
        height: 320,
        width: 800,
        decoration: BoxDecoration(
            //  color: Color(0xFFFf8f0c6),
            color: Color(0xfffd7e5f0),
            // border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SizedBox(width: 20),
            Container(
              width: 200,
              height: 200,
              child: CarouselSlider(
                options: CarouselOptions(
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  autoPlay: true,
                ),
                items: roomtypes[widget.indexRoom]
                    .roomImages
                    .map((e) =>
                        //  Text(e.filename)
                        Image.network(
                          e.link.toString(),
                          // fit: BoxFit.cover,
                        ))
                    .toList(),
              ),
            ),

            // Container(
            //     width: 200,
            //     height: 200,
            //     child: roomtypes[widget.indexRoom].roomImages.length == 0
            //         ? new Container(
            //             color: Colors.green,
            //           )
            //         : Image.network(
            //             // 'http://139.59.101.136/static/' +
            //             roomtypes[widget.indexRoom]
            //                 .roomImages[0]
            //                 .link
            //                 .toString()
            //             // trips[widget.index].tripTemplate.images[0].toString()
            //             )),
            SizedBox(
              width: 20,
            ),
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text('Room type : ' + roomtypes[widget.indexRoom].name),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 500,
                    child: Text(
                      'Room description: ' +
                          roomtypes[widget.indexRoom].description,
                      maxLines: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Max capacity : ' +
                      roomtypes[widget.indexRoom].maxGuest.toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text('Room quantity : ' +
                      roomtypes[widget.indexRoom].quantity.toString()),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: 200,
                    child: FutureBuilder(
                      future: getHotelDetail(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: hotelDetial.hotel
                                .roomTypes[widget.indexRoom].amenities.length,
                            itemBuilder: (context, each) {
                              return Text(hotelDetial
                                  .hotel
                                  .roomTypes[widget.indexRoom]
                                  .amenities[each]
                                  .name);
                            },
                          );
                        } else {
                          return Center(child: Text('no amenity'));
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  details[indexDetail].tripRoomTypePrices.length == 0
                      ? Text('Price : no price')
                      : Text('Price : ' +
                          // roomtypes[widget.indexRoom].price.toString()
                          details[indexDetail]
                              .tripRoomTypePrices[widget.indexRoom]
                              .price
                              .toString()),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(
                    onPressed: roomtypes[widget.indexRoom].quantity == 0
                        ? null
                        : () async {
                            // print('bf');
                            // bookTrips();
                            // print('af');

                            await showInformationDialog(context);
                          },
                    color: Colors.amber,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text("Book room"),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
