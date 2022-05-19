import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/hotel.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/addMoreAmenity.dart';
import 'package:diving_trip_agency/screens/create_hotel/add_hotel_form.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/update/add_new_amenity_hotel.dart';
//import 'package:diving_trip_agency/screens/update/update_amenity_hotel.dart';
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

import 'InfoCard.dart';



class RoomFormHotelUpdate extends StatefulWidget {
  List<RoomType> allRoom = [];
  Hotel eachHotel;
  final customFunction;
  GlobalKey<AnimatedListState> _key;

  var f2 = File();
  RoomFormHotelUpdate(
      Hotel eachHotel, List<RoomType> allRoom, this.customFunction, GlobalKey<AnimatedListState> _key) {
    this.eachHotel = eachHotel;
    this.allRoom = allRoom;
    this._key = _key;
  }
  @override
  _RoomFormHotelUpdateState createState() =>
      _RoomFormHotelUpdateState(this.eachHotel, this.allRoom, _key);
}

class _RoomFormHotelUpdateState extends State<RoomFormHotelUpdate> {
  List<RoomType> allRoom = [];
  Hotel eachHotel;
  GlobalKey<AnimatedListState> _key;

  _RoomFormHotelUpdateState(this.eachHotel, this.allRoom, this._key);
  getRoomType() async {
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
    listroomrequest.hotelId = eachHotel.id;
    print("allroom");
    print(allRoom);
    allRoom.clear();
    try {
      await for (var feature in stub.listRoomTypes(listroomrequest)) {
        allRoom.add(feature.roomType);

      }
    } catch (e) {
      print('ERROR: $e');
    }
    // print('--');
    // print(allRoom);
    print("allroom");
    print(allRoom);
    return allRoom;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 1110,
      child: FutureBuilder(
        future: getRoomType(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return
              Wrap(
                  spacing: 20,
                  runSpacing: 40,
                  children: List.generate(
                      allRoom.length,
                          (index) => InfoCard(
                          index, allRoom, eachHotel, widget.customFunction,_key)));
          } else {
            return Center(child: Text('No room'));
          }
        },
      ),
    );
  }
}