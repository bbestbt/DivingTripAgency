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
import 'package:diving_trip_agency/screens/update/update_amenity_hotel.dart';
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

import 'RoomForm.dart';
import 'RoomFormHotelUpdate.dart';

GetHotelResponse hotelDetial = new GetHotelResponse();
var hotel;
var rt;
final GlobalKey<AnimatedListState> _key = GlobalKey();

class AddMoreRoomUpdateHotel extends StatefulWidget {
  List<RoomType> pinkValue = [];
  Hotel eachHotel;
  final customFunction;
  List<List<Amenity>> blueValue;
  AddMoreRoomUpdateHotel(Hotel eachHotel, this.customFunction
      ) {
    this.eachHotel = eachHotel;
  }
  @override
  _AddMoreRoomUpdateHotelState createState() =>
      _AddMoreRoomUpdateHotelState(this.eachHotel);
}

class _AddMoreRoomUpdateHotelState extends State<AddMoreRoomUpdateHotel> {
  int pinkcount = 0;
  List<List<Amenity>> blueValue;
  List<RoomType> pinkValue = [];
  Hotel eachHotel;
  List<RoomType> allRoom = [];

  _AddMoreRoomUpdateHotelState(
      Hotel eachHotel,
      ) {
    this.eachHotel = eachHotel;
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

    final stub = HotelServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var listamenityhotelrequest = GetHotelRequest();

    listamenityhotelrequest.id = eachHotel.id;

    hotel = await stub.getHotel(listamenityhotelrequest);

    hotelDetial = hotel;
     print("key updateroom "+_key.toString());
    return hotelDetial.hotel.roomTypes.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
            RoomFormHotelUpdate(
              this.eachHotel,
              this.allRoom,
              widget.customFunction,
              _key
            ),
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
                        return RoomForm(
                            pinkcount,
                            this.pinkValue,
                            this.blueValue,
                            index + hotelDetial.hotel.roomTypes.length,
                            eachHotel,
                            widget.customFunction,
                            this.allRoom);
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
                    setState(() {
                      pinkcount += 1;
                      rt = RoomType();
                      rt.name = '';
                      rt.description = '';
                      rt.quantity = 0;
                      rt.maxGuest = 0;
                      rt.roomImages.add(new File());
                      rt.roomImages.add(new File());
                      rt.roomImages.add(new File());
                     // rt.roomImages[0];
                    //  rt.roomImages[1];
                     // rt.roomImages[2];
                      eachHotel.roomTypes.add(rt);
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