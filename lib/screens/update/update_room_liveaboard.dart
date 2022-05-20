import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/addMoreAmenity.dart';
import 'package:diving_trip_agency/screens/create_hotel/add_hotel_form.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/update/add_new_amenity_hotel.dart';
import 'package:diving_trip_agency/screens/update/add_new_amenity_liveaboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'dart:io' as io;
import 'package:fixnum/fixnum.dart';

import 'update_amenity_liveaboard.dart';
import 'RoomFormliveaboard.dart';
import 'RoomFormLiveaboardUpdate.dart';

GetLiveaboardResponse liveaboardDetial = new GetLiveaboardResponse();
var liveaboard;
var rt;
final GlobalKey<AnimatedListState> _key = GlobalKey();

class AddMoreRoomUpdateLiveaboard extends StatefulWidget {
  List<RoomType> pinkValue = [];
  Liveaboard eachLiveaboard;
  final customFunction;

  List<List<Amenity>> blueValue;
  AddMoreRoomUpdateLiveaboard(Liveaboard eachLiveaboard, this.customFunction) {
    this.eachLiveaboard = eachLiveaboard;
  }
  @override
  _AddMoreRoomUpdateLiveaboardState createState() =>
      _AddMoreRoomUpdateLiveaboardState(this.eachLiveaboard);
}
class _AddMoreRoomUpdateLiveaboardState extends State<AddMoreRoomUpdateLiveaboard> {
  int pinkcount = 0;
  List<List<Amenity>> blueValue;
  List<RoomType> pinkValue = [];
  Liveaboard eachLiveaboard;
  List<RoomType> allRoom = [];

  _AddMoreRoomUpdateLiveaboardState(Liveaboard eachLiveaboard) {
    this.eachLiveaboard = eachLiveaboard;
  }

  getRoomLength() async {
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
    var listamenityliveaboardrequest = GetLiveaboardRequest();

    listamenityliveaboardrequest.id = eachLiveaboard.id;

    liveaboard = await stub.getLiveaboard(listamenityliveaboardrequest);

    liveaboardDetial = liveaboard;

    return liveaboardDetial.liveaboard.roomTypes.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
            RoomFormLiveaboardUpdate(
                this.eachLiveaboard, this.allRoom,
                widget.customFunction, _key),
            FutureBuilder(
              future: getRoomLength(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.separated(
                      separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                        thickness: 5,
                        indent: 20,
                        endIndent: 20,
                      ),
                      shrinkWrap: true,
                      itemCount: pinkcount,
                      itemBuilder: (BuildContext context, int index) {
                        return RoomFormliveaboard(
                            pinkcount,
                            this.pinkValue,
                            this.blueValue,
                            index + liveaboardDetial.liveaboard.roomTypes.length,
                            eachLiveaboard,
                            widget.customFunction,
                          this.allRoom
                        );
                      });
                } else {
                  return Center(child: Text('No room'));
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    print("---eachLiveaboard--");
                    print(eachLiveaboard);
                    setState(() {
                      pinkcount = 1;
                      rt = RoomType();
                      rt.name = '';
                      rt.description = '';
                      rt.quantity = 0;
                      rt.maxGuest = 0;
                      rt.roomImages.add(new File());
                      rt.roomImages.add(new File());
                      rt.roomImages.add(new File());
                      eachLiveaboard.roomTypes.add(rt);
                      // pinkValue.add(new RoomType());
                      // blueValue.add([new Amenity()]);
                    });
                  },
                  color: Color(0xfff45b6fe),
                  textColor: Colors.white,
                  child: Icon(
                    Icons.add,
                    size: 20,
                  ),
                ),

              ],
            ),
            SizedBox(height: 30),

          ])),
    );
  }
}