import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pbgrpc.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:diving_trip_agency/screens/ShopCart/ShopcartWidget.dart';

GetLiveaboardResponse liveaboardDetial = new GetLiveaboardResponse();
var liveaboard;
List<RoomType> roomtypes = [];
final TextEditingController _textEditingQuantity = TextEditingController();
final TextEditingController _textEditingDiver = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    // await getLiveaboardDetail();
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
        Text("Trip name : " + details[widget.index].tripTemplate.name),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: 1110,
          child: FutureBuilder(
            future: getLiveaboardDetail(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child:
                      Text("Liveaboard : " + liveaboardDetial.liveaboard.name),
                );
              } else {
                return Align(
                    alignment: Alignment.center, child: Text('No name'));
              }
            },
          ),
        ),
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
                                      (candy) => Center(
                                        child: InfoCard(candy, details, index),
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
  }
//   const InfoCard({
//     Key key,
//     this.index,
//   }) : super(key: key);

//   final int index;

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
    print("before try catch");
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

  void bookTrips() async {
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
      room.roomTypeId = roomtypes[i].id;
      room.noDivers = int.parse(_textEditingDiver.text);
      // print(room.quantity);
      // print(room.noDivers);
    }

    var reservation = Reservation()..rooms.add(room);
    reservation.tripId = details[indexDetail].id;
    // Int64(28);
    reservation.diverId = user_profile.diver.id;
    reservation.price =
        (roomtypes[indexRoom].price * int.parse(_textEditingQuantity.text)) +
            details[indexDetail].price;
    reservation.totalDivers = Int64(roomtypes[indexRoom].maxGuest);

    var bookRequest = CreateReservationRequest()..reservation = reservation;

    try {
      var response = stub.createReservation(bookRequest);
      print('response: ${response}');
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
                      Cartlist.add([
                        "5.jpg",
                        details[indexDetail].tripTemplate.name,
                        liveaboardDetial.liveaboard.name,
                        roomtypes[indexRoom].name,
                        (roomtypes[indexRoom].price *
                                int.parse(_textEditingQuantity.text)) +
                            details[indexDetail].price,
                        details,
                        roomtypes,
                        indexRoom,
                        indexDetail,
                        int.parse(_textEditingQuantity.text),
                        int.parse(_textEditingDiver.text)
                      ]);

                      // Do something like updating SharedPreferences or User Settings etc.
                      Navigator.of(context).pop();
                      print('done');
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
                      //           //     child: Text("OK"),
                      //           //     ),
                      //         ],
                      //       );
                      //     });
                      Navigator.of(context).pop();
                      print('book');
                    }
                  },
                ),
              ],
            );
          });
        });
  }

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
                child: roomtypes[widget.indexRoom].roomImages.length == 0
                    ? new Container(
                        color: Colors.green,
                      )
                    : Image.network(
                        // 'http://139.59.101.136/static/' +
                        roomtypes[widget.indexRoom]
                            .roomImages[0]
                            .link
                            .toString()
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
                Text('Room type : ' + roomtypes[widget.indexRoom].name),
                SizedBox(
                  height: 20,
                ),
                Text('Room description: ' +
                    roomtypes[widget.indexRoom].description),
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
                Text('Price : ' + roomtypes[widget.indexRoom].price.toString()),
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
