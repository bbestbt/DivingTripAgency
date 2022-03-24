import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/hotel.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pbgrpc.dart';
import 'package:diving_trip_agency/screens/diveresort/dialog.dart';
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

List<RoomType> roomtypes = [];
GetProfileResponse user_profile = new GetProfileResponse();
var profile;
List<TripWithTemplate> details=[];
GetHotelResponse hotelDetial = new GetHotelResponse();
var hotel;

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class DiveResortDetailScreen extends StatefulWidget {
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
  final MenuController _controller = Get.put(MenuController());
  int index;
  List<TripWithTemplate> details;
  _DiveResortDetailScreenState(int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
  }

  @override
  Widget build(BuildContext context) {
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
    //print("before try catch");
    await getHotelDetail();
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
    listroomrequest.hotelId = details[widget.index].tripTemplate.hotelId;
    // Int64(2);

    roomtypes.clear();
    // print('test');
    try {
      // print('test2');
      await for (var feature in stub.listRoomTypes(listroomrequest)) {
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
    //print("before try catch");
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

    print(hotelDetial.hotel.name);
    return hotelDetial.hotel.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: "Dive resorts",
          color: Color(0xFFFF78a2cc),
        ),
        Text("Hotel : " +

            // details[widget.index].tripTemplate.hotelId.toString()),
            hotelDetial.hotel.name),

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
                    : Image.network(details[widget.index]
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
                    : Image.network(details[widget.index]
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
                    : Image.network(details[widget.index]
                        .tripTemplate
                        .images[2]
                        .link
                        .toString())),
          ],
        ),
        SizedBox(
          height: 10,
        ),

        //  RaisedButton(
        //           onPressed: () {
        //            getHotelDetail();
        //           },
        //           color: Colors.amber,
        //           shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(10)),
        //           child: Text("get hotel"),
        //         ),
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

    // var bookRequest = CreateReservationRequest();
    // bookRequest.reservation.diverId = user_profile.diver.id;
    // // bookRequest.reservation.price = roomtypes[widget.index].price+details[widget.index].price;
    // bookRequest.reservation.totalDivers =
    //     Int64(roomtypes[widget.index].maxGuest);
    // bookRequest.reservation.tripId = details[widget.index].id;
    // // bookRequest.reservation.rooms.add(roomtypes[widget.index]);

    // try {
    //   var response = stub.createReservation(bookRequest);
    //   print('response: ${response}');
    // } catch (e) {
    //   print(e);
    // }
  }



  Future<void> showInformationDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController =
              TextEditingController();
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
                        controller: _textEditingController,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration:
                            InputDecoration(hintText: "Enter room quantity"),
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
                  child: Text('Confirm'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // bookTrips();
                      print(details[widget.index].price);
                      print(roomtypes[widget.index].price);
                      // print((roomtypes[widget.index].price+details[widget.index].price).toString());
                      // Do something like updating SharedPreferences or User Settings etc.
                      Navigator.of(context).pop();
                      print('done');
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
                child: roomtypes[widget.index].roomImages.length == 0
                    ? new Container(
                        color: Colors.green,
                      )
                    : Image.network(' http://139.59.101.136/static/' +
                            roomtypes[widget.index].roomImages[0].toString()
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

                  onPressed: () async {

                    // print('bf');
                    // bookTrips();
                    // print('af');


                    await showInformationDialog(context);

                  },
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
