import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pbgrpc.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';

GetLiveaboardResponse liveaboardDetial = new GetLiveaboardResponse();
var liveaboard;
List<RoomType> roomtypes = [];

class LiveaboardDetailScreen extends StatefulWidget {
  int index;
  List<TripWithTemplate> details;
  LiveaboardDetailScreen(int index, List<TripWithTemplate> details) {
    this.details = details;
    this.index = index;
  }
  @override
  State<LiveaboardDetailScreen> createState() =>
      _LiveaboardDetailScreenState(this.index, this.details);
}

class _LiveaboardDetailScreenState extends State<LiveaboardDetailScreen> {
  int index;
  List<TripWithTemplate> details;
  _LiveaboardDetailScreenState(int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
    //  print(index.toString());
    //   print('detail');
    // print(details);
  }
  final MenuController _controller = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    // print('build'+index.toString());
    return Scaffold(
        key: _controller.scaffoldkey,
        drawer: SideMenu(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Header(),
                SizedBox(height: 30),
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
    // print('detail');
    // print(details);
    // print("index");
    // print(index.toString());
  }
  @override
  State<detail> createState() => _detailState(this.index, this.details);
}

class _detailState extends State<detail> {
  int index;
  List<TripWithTemplate> details;
  _detailState(int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
  }

  getData() async {
    await getLiveaboardDetail();
    //print("before try catch");
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = AgencyServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));

    var listroomrequest = ListRoomTypesRequest();
    listroomrequest.limit = Int64(20);
    listroomrequest.offset = Int64(0);
    listroomrequest.liveaboardId =
        details[widget.index].tripTemplate.liveaboardId;
    // Int64(2);

    roomtypes.clear();
    print('test');
    try {
      print('test2');
      await for (var feature in stub.listRoomTypes(listroomrequest)) {
        print('test3');
        roomtypes.add(feature.roomType);
        print(roomtypes);
      }
    } catch (e) {
      print('ERROR: $e');
    }

    return roomtypes;
  }

  getLiveaboardDetail() async {
    //print("before try catch");
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = LiveaboardServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var liveaboardrequest = GetLiveaboardRequest();
    liveaboardrequest.id = details[widget.index].tripTemplate.liveaboardId;

    liveaboard = await stub.getLiveaboard(liveaboardrequest);
    liveaboardDetial = liveaboard;
    // print('dd');
    // print(liveaboardDetial.liveaboard.name);
    return liveaboardDetial.liveaboard.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: "Liveaboard",
          color: Color(0xFFFF78a2cc),
        ),
        Text("Liveaboard : " + liveaboardDetial.liveaboard.name),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("From : " +
                details[widget.index].fromDate.toDateTime().toString()),
            SizedBox(
              width: 10,
            ),
            Text("From : " +
                details[widget.index].toDate.toDateTime().toString()),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text("Address : " +
            details[widget.index].tripTemplate.address.addressLine1),
        SizedBox(
          height: 10,
        ),
        Text("Address2 : " +
            details[widget.index].tripTemplate.address.addressLine2),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('City : ' + details[widget.index].tripTemplate.address.city),
            SizedBox(
              width: 20,
            ),
            Text("Country : " +
                details[widget.index].tripTemplate.address.country),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Region : ' +
                details[widget.index].tripTemplate.address.region),
            SizedBox(
              width: 20,
            ),
            Text('Postcode : ' +
                details[widget.index].tripTemplate.address.postcode),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text("Description : " + details[widget.index].tripTemplate.description),
        SizedBox(
          height: 10,
        ),
        Text("Price : " + details[widget.index].price.toString()),
        SizedBox(
          height: 10,
        ),
        Text('Total capacity : ' + details[widget.index].maxGuest.toString()),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 300,
                height: 300,
                child: details[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(
                      // 'http://139.59.101.136/static/'+
                      details[widget.index]
                        .tripTemplate
                        .images[0]
                        .link
                        .toString())),
            SizedBox(
              width: 10,
            ),
            Container(
                width: 300,
                height: 300,
                child: details[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(
                      // 'http://139.59.101.136/static/'+
                      details[widget.index]
                        .tripTemplate
                        .images[1]
                        .link
                        .toString())),
            SizedBox(
              width: 10,
            ),
            Container(
                width: 300,
                height: 300,
                child: details[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(
                      // 'http://139.59.101.136/static/'+
                      details[widget.index]
                        .tripTemplate
                        .images[2]
                        .link
                        .toString())),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          // decoration: BoxDecoration(
          //     color: Color(0xFFFF89cfef),
          //     borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  width: 1110,
                  child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                            child: Container(
                                child: Wrap(
                                    spacing: 20,
                                    runSpacing: 40,
                                    children: List.generate(
                                      roomtypes.length,
                                      (index) => Center(
                                        child: InfoCard(
                                          index: index,
                                        ),
                                      ),
                                    ))));
                      } else {
                          getLiveaboardDetail();
                        return Align(
                            alignment: Alignment.center,
                            child: Text('No data'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class InfoCard extends StatefulWidget {
  const InfoCard({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  Map<String, dynamic> hotelTypeMap = {};
  List<String> hotel = [];

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 320,
        width: 500,
        decoration: BoxDecoration(
            // color: Colors.white,
            color: Color(0xFFFF89cfef),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SizedBox(width: 20),
            Container(
                width: 200,
                height: 200,
                child: roomtypes[widget.index].roomImages.length == 0
                    ? new Container(
                        color: Colors.green,
                      )
                    : Image.network(
                      // 'http://139.59.101.136/static/' +
                            roomtypes[widget.index].roomImages[0].link.toString()
                        // trips[widget.index].tripTemplate.images[0].toString()
                        )),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Text('Room type : ' + roomtypes[widget.index].name),
                SizedBox(
                  height: 20,
                ),
                Text(
                    'Room description: ' + roomtypes[widget.index].description),
                SizedBox(
                  height: 20,
                ),
                Text('Max capacity : ' +
                    roomtypes[widget.index].maxGuest.toString()),
                SizedBox(
                  height: 20,
                ),
                Text('Room quantity : ' +
                    roomtypes[widget.index].quantity.toString()),
                SizedBox(
                  height: 20,
                ),
                Text('Price : ' + roomtypes[widget.index].price.toString()),
                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  onPressed: () {},
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("Book"),
                ),
              ],
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