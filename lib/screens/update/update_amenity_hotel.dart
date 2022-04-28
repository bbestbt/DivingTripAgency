import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/amenity.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/hotel.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';

class updateAmenityHotelForm extends StatefulWidget {
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue = [[new Amenity()]];
  Hotel eachHotel;
  GetHotelResponse hotelDetial = new GetHotelResponse();
  var hotel;

  updateAmenityHotelForm(Hotel eachHotel, int blue, int pinkcount,
      List<List<Amenity>> blueValue, GetHotelResponse hotelDetial) {
    this.eachHotel = eachHotel;
    this.bluecount = blue;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.hotelDetial = hotelDetial;
    // print(eachHotel.id);
  }
  @override
  _updateAmenityHotelFormState createState() => _updateAmenityHotelFormState(
      this.eachHotel,
      this.bluecount,
      this.pinkcount,
      this.blueValue,
      this.hotelDetial);
}

class _updateAmenityHotelFormState extends State<updateAmenityHotelForm> {
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue =  [[new Amenity()]];
  GetHotelResponse hotelDetial = new GetHotelResponse();
  var hotel;

  Hotel eachHotel;
  _updateAmenityHotelFormState(Hotel eachHotel, int bluecount, int pinkcount,
      List<List<Amenity>> blueValue, GetHotelResponse hotelDetial) {
    this.eachHotel = eachHotel;
    this.bluecount = bluecount;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.hotelDetial = hotelDetial;
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
                  (index) => InfoCard(index, blueValue, pinkcount, hotelDetial),
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
  List<List<Amenity>> blueValue =  [[new Amenity()]];
  int bluecount;
  GetHotelResponse hotelDetial = new GetHotelResponse();
  var hotel;

  InfoCard(int index, List<List<Amenity>> blueValue, int pinkcount,
      GetHotelResponse hotelDetial) {
    this.index = index;
    this.blueValue = blueValue;
    this.pinkcount = pinkcount;
    this.hotelDetial = hotelDetial;
    // print("pc info "+pinkcount.toString());
  }

  @override
  State<InfoCard> createState() => _InfoCardState(
      this.index, this.blueValue, this.pinkcount, this.hotelDetial);
}

class _InfoCardState extends State<InfoCard> {
  int index;
  int pinkcount;
  List<List<Amenity>> blueValue =  [[new Amenity()]];
  List<DropdownMenuItem<String>> listAmenity = [];
  List<String> amenity = [];
  String amenitySelected;
  Map<String, dynamic> amenityMap = {};
  GetHotelResponse hotelDetial = new GetHotelResponse();
  var hotel;

  _InfoCardState(this.index, this.blueValue, this.pinkcount, this.hotelDetial);

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
                hint: Text(hotelDetial
                    .hotel.roomTypes[pinkcount].amenities[index].name),
                iconSize: 40,
                onChanged: (value) {
                  // if (value != null) {
                  setState(() {
                    amenitySelected = value;
                    amenity.forEach((element) {
                      if (element == amenitySelected) {
                        hotelDetial.hotel.roomTypes[pinkcount].amenities[index]
                            .name = amenitySelected;
                        hotelDetial.hotel.roomTypes[pinkcount].amenities[index]
                            .id = amenityMap[element];
                        // print(hotelDetial);
                        

                        blueValue[pinkcount][index].name = hotelDetial
                            .hotel.roomTypes[pinkcount].amenities[index].name;
                        // print(blueValue);
                        // blueValue[pinkcount][index].id = hotelDetial
                        //     .hotel.roomTypes[pinkcount].amenities[index].id;
                      }
                    });
                  });
                  // }
                },
              ),
            ),
          ),

          // Text(pinkcount.toString()),
          // Text(index.toString())
          // SizedBox(height: 20),
        ]),
      ),
    );
  }
}