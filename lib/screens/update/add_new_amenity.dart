import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/amenity.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';

import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/amenity.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';

class AddMoreAmenityNew extends StatefulWidget {
  List<List<Amenity>> blueValue;

  int pinkcount;
  AddMoreAmenityNew(
    int pinkcount,
    List<List<Amenity>> blueValue,
  ) {
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
  }
  @override
  _AddMoreAmenityState createState() => _AddMoreAmenityState(
        this.pinkcount,
        this.blueValue,
      );
}

class _AddMoreAmenityState extends State<AddMoreAmenityNew> {
  int bluecount = 1;
  int pinkcount;
  List<List<Amenity>> blueValue;
  List<String> errors = [];
  _AddMoreAmenityState(
    int pinkcount,
    List<List<Amenity>> blueValue,
  ) {
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            shrinkWrap: true,
            itemCount: bluecount,
            itemBuilder: (BuildContext context, int index) {
              return amenityFormNew(bluecount, pinkcount, this.blueValue);
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  bluecount += 1;
                  // blueValue[pinkcount - 1].add(new Amenity());
                });
              },
              color: Color(0xfff8fcaca),
              textColor: Colors.white,
              child: Icon(
                Icons.add,
                size: 20,
              ),
            ),
            SizedBox(width: 30),
            MaterialButton(
              onPressed: () {
                setState(() {
                  bluecount -= 1;
                  // blueValue[pinkcount - 1].remove(new Amenity());
                });
              },
              color: Color(0xfff8fcaca),
              textColor: Colors.white,
              child: Icon(
                Icons.remove,
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

class amenityFormNew extends StatefulWidget {
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;

  amenityFormNew(
    int blue,
    int pinkcount,
    List<List<Amenity>> blueValue,
  ) {
    this.bluecount = blue;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
  }
  @override
  _amenityFormState createState() => _amenityFormState(
        this.bluecount,
        this.pinkcount,
        this.blueValue,
      );
}

class _amenityFormState extends State<amenityFormNew> {
  String amenity_name;
  String amenity_descption;
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;
  //load
  List<DropdownMenuItem<String>> listAmenity = [];
  List<String> amenity = [];
  String amenitySelected;
  Map<String, dynamic> amenityMap = {};

  _amenityFormState(
    int bluecount,
    int pinkcount,
    List<List<Amenity>> blueValue,
  ) {
    this.bluecount = bluecount;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    await getAmenity();
    setState(() {
      listAmenity = [];
      listAmenity = amenity
          .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
          .toList();
    });
    // print('amenity');
    // amenity.forEach((element) {
    //   print(element);
    // });
  }

  getAmenity() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = AmenityServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var listamenityrequest = ListAmenitiesRequest();
    listamenityrequest.limit = Int64(20);
    listamenityrequest.offset = Int64(0);

    try {
      await for (var feature in stub.listAmenities(listamenityrequest)) {
        amenity.add(feature.amenities.name);
        amenityMap[feature.amenities.name] = feature.amenities.id;
        // print(amenityMap);
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          Text((bluecount-1).toString()),
          SizedBox(height: 20),
          Container(
            color: Color(0xfffd4f0f0),
            //color: Color(0xFFFd0efff),
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: amenitySelected,
                items: listAmenity,
                dropdownColor: Color(0xfffd4f0f0),
                hint: Text('  Select amenity'),
                iconSize: 40,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      amenitySelected = value;
                      // print(amenitySelected);
                      // print(amenity);
                      amenity.forEach((element) {
                        // print(amenity);
                        // print('d');
                        // print(element);
                        // print(amenityMap[element]);
                        // print(amenitySelected);
                        if (element == amenitySelected) {
                          // print(amenityMap[element]);
                          blueValue[pinkcount][bluecount-1].name =
                              amenitySelected;
                          blueValue[pinkcount][bluecount-1].id =
                              amenityMap[element];
                        }
                      });
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }
}
