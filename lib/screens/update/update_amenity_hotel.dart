import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/amenity.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/hotel.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';

class AddMoreAmenityUpdateHotel extends StatefulWidget {
  List<List<Amenity>> blueValue;
  Hotel eachHotel;
  int bluecount;
  final customFunction;
  int pinkcount;
  AddMoreAmenityUpdateHotel(
      Hotel eachHotel,
      // int bluecount,
      int pinkcount,
      this.customFunction
      // List<List<Amenity>> blueValue,
      ) {
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.eachHotel = eachHotel;
    // this.bluecount = bluecount;
  }
  @override
  _AddMoreAmenityUpdateHotelState createState() =>
      _AddMoreAmenityUpdateHotelState(this.eachHotel, this.pinkcount);
}

class _AddMoreAmenityUpdateHotelState extends State<AddMoreAmenityUpdateHotel> {
  int bluecount = 0;
  int pinkcount;
  List<List<Amenity>> blueValue;
  Hotel eachHotel;

  _AddMoreAmenityUpdateHotelState(
    Hotel eachHotel,
    // int bluecount,
    int pinkcount,
    // List<List<Amenity>> blueValue,
  ) {
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.eachHotel = eachHotel;
    // this.bluecount = bluecount;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        updateAmenityHotelForm(this.eachHotel, this.bluecount, this.pinkcount,
            this.blueValue, widget.customFunction),
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            shrinkWrap: true,
            itemCount: bluecount,
            itemBuilder: (BuildContext context, int index) {
              return amenityForm(
                  bluecount,
                  pinkcount,
                  this.blueValue,
                  index +
                      hotelDetial.hotel.roomTypes[pinkcount].amenities.length,
                  this.eachHotel,
                  widget.customFunction);
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  bluecount += 1;
                  // blueValue[pinkcount].add(new Amenity());
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
                  // blueValue[pinkcount].remove(new Amenity());
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
        FlatButton(onPressed: () {
          print(eachHotel.roomTypes[pinkcount].amenities);
          // print(hotelDetial.hotel.roomTypes[pinkcount].amenities);
        }),
      ])),
    );
  }
}

GetHotelResponse hotelDetial = new GetHotelResponse();
var hotel;

class updateAmenityHotelForm extends StatefulWidget {
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;
  Hotel eachHotel;
  final customFunction;

  updateAmenityHotelForm(Hotel eachHotel, int blue, int pinkcount,
      List<List<Amenity>> blueValue, this.customFunction) {
    this.eachHotel = eachHotel;
    this.bluecount = blue;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    // print(eachHotel.id);
  }
  @override
  _updateAmenityHotelFormState createState() => _updateAmenityHotelFormState(
      this.eachHotel, this.bluecount, this.pinkcount, this.blueValue);
}

class _updateAmenityHotelFormState extends State<updateAmenityHotelForm> {
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;

  Hotel eachHotel;
  _updateAmenityHotelFormState(
    Hotel eachHotel,
    int bluecount,
    int pinkcount,
    List<List<Amenity>> blueValue,
  ) {
    this.eachHotel = eachHotel;
    this.bluecount = bluecount;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    // print('pc  '+pinkcount.toString());
  }

  selectAmenity() async {
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
    // print('1   '+eachHotel.id.toString());
    listamenityhotelrequest.id = eachHotel.id;
    //  print('2  '+listamenityhotelrequest.id.toString());
    hotel = await stub.getHotel(listamenityhotelrequest);
    // print('amen');
    // print(hotel);
    hotelDetial = hotel;
    // print(hotelDetial.hotel.roomTypes);
    return hotelDetial.hotel.roomTypes[pinkcount].amenities;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 1110,
      child: FutureBuilder(
        future: selectAmenity(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Wrap(
                spacing: 20,
                runSpacing: 40,
                children: List.generate(
                  hotelDetial.hotel.roomTypes[pinkcount].amenities.length,
                  (index) => InfoCard(index, blueValue, pinkcount, eachHotel,
                      widget.customFunction),
                ));
          } else {
            return Center(child: Text('No amenity'));
          }
        },
      ),
    );
  }
}

class InfoCard extends StatefulWidget {
  int index;
  List<RoomType> allRoom = [];
  int pinkcount;
  List<RoomType> pinkValue;
  List<List<Amenity>> blueValue;
  int bluecount;
  Hotel eachHotel;
  final customFunction;

  InfoCard(int index, List<List<Amenity>> blueValue, int pinkcount,
      Hotel eachHotel, this.customFunction) {
    this.index = index;
    this.blueValue = blueValue;
    this.pinkcount = pinkcount;
    this.eachHotel = eachHotel;
    // print("pc info "+pinkcount.toString());
  }

  @override
  State<InfoCard> createState() => _InfoCardState(
      this.index, this.blueValue, this.pinkcount, this.eachHotel);
}

class _InfoCardState extends State<InfoCard> {
  int index;
  int pinkcount;
  List<List<Amenity>> blueValue;
  List<DropdownMenuItem<String>> listAmenity = [];
  List<String> amenity = [];
  String amenitySelected;
  Map<String, dynamic> amenityMap = {};
  Hotel eachHotel;
  _InfoCardState(this.index, this.blueValue, this.pinkcount, this.eachHotel);

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
    // print(listAmenity);
  }

  @override
  Widget build(BuildContext context) {
    // print(listAmenity);
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          Text(index.toString()),
          SizedBox(height: 20),
          Container(
            color: Color(0xfffd4f0f0),
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: amenitySelected,
                items: listAmenity,
                dropdownColor: Color(0xfffd4f0f0),
                hint: Text(hotelDetial
                    .hotel.roomTypes[pinkcount].amenities[index].name),
                iconSize: 40,
                onChanged: (value) {
                  setState(() {
                    amenitySelected = value;
                    amenity.forEach((element) {
                      if (element == amenitySelected) {
                        eachHotel.roomTypes[pinkcount].amenities[index].name =
                            amenitySelected;
                        eachHotel.roomTypes[pinkcount].amenities[index].id =
                            amenityMap[element];
                        // print('gg');
                        // print( eachHotel.roomTypes[pinkcount].amenities[index]);
                        widget.customFunction(
                            eachHotel.roomTypes[pinkcount].amenities);
                      }
                    });
                  });
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class amenityForm extends StatefulWidget {
  int bluecount;
  int pinkcount;
  int indexForm;
  List<List<Amenity>> blueValue;
  Hotel eachHotel;
  final customFunction;

  amenityForm(int blue, int pinkcount, List<List<Amenity>> blueValue,
      int indexForm, Hotel eachHotel, this.customFunction) {
    this.bluecount = blue;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.indexForm = indexForm;
    this.eachHotel = eachHotel;
  }
  @override
  _amenityFormState createState() => _amenityFormState(this.bluecount,
      this.pinkcount, this.blueValue, this.indexForm, this.eachHotel);
}

class _amenityFormState extends State<amenityForm> {
  String amenity_name;
  String amenity_descption;
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;
  int indexForm;
  List<DropdownMenuItem<String>> listAmenity = [];
  List<String> amenity = [];
  String amenitySelected;
  Map<String, dynamic> amenityMap = {};
  Hotel eachHotel;

  _amenityFormState(int bluecount, int pinkcount, List<List<Amenity>> blueValue,
      int indexForm, Hotel eachHotel) {
    this.bluecount = bluecount;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.indexForm = indexForm;
    this.eachHotel = eachHotel;
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
          Text(indexForm.toString()),
          SizedBox(height: 20),
          Container(
            color: Color(0xfffd4f0f0),
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
                          //พัง
                          // print(amenityMap[element]);
                          print(
                              eachHotel.roomTypes[pinkcount].amenities.length);

                          var am = Amenity();
                          am.name = amenitySelected;
                          am.id = amenityMap[element];
                          eachHotel.roomTypes[pinkcount].amenities.add(am);
                          eachHotel.roomTypes[pinkcount].amenities[indexForm]
                              .name = amenitySelected;
                          eachHotel.roomTypes[pinkcount].amenities[indexForm]
                              .id = amenityMap[element];
                          widget.customFunction(
                              eachHotel.roomTypes[pinkcount].amenities);
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
