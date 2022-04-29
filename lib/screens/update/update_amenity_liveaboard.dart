import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/amenity.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';

GetLiveaboardResponse liveaboardDetial = new GetLiveaboardResponse();
var liveaboard;

class updateAmenityLiveaboardForm extends StatefulWidget {
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;
  Liveaboard eachLiveaboard;

  updateAmenityLiveaboardForm(
    Liveaboard eachLiveaboard,
    int blue,
    int pinkcount,
    List<List<Amenity>> blueValue,
  ) {
    this.eachLiveaboard = eachLiveaboard;
    this.bluecount = blue;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    // print(eachLiveaboard.id);
  }
  @override
  _updateAmenityLiveaboardFormState createState() =>
      _updateAmenityLiveaboardFormState(
          this.eachLiveaboard, this.bluecount, this.pinkcount, this.blueValue);
}

class _updateAmenityLiveaboardFormState
    extends State<updateAmenityLiveaboardForm> {
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;

  Liveaboard eachLiveaboard;
  _updateAmenityLiveaboardFormState(
    Liveaboard eachLiveaboard,
    int bluecount,
    int pinkcount,
    List<List<Amenity>> blueValue,
  ) {
    this.eachLiveaboard = eachLiveaboard;
    this.bluecount = bluecount;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
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

    final stub = LiveaboardServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var listamenityliveaboardrequest = GetLiveaboardRequest();

    listamenityliveaboardrequest.id = eachLiveaboard.id;

    liveaboard = await stub.getLiveaboard(listamenityliveaboardrequest);

    liveaboardDetial = liveaboard;

    return liveaboardDetial.liveaboard.roomTypes[pinkcount].amenities;
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
                  liveaboardDetial
                      .liveaboard.roomTypes[pinkcount].amenities.length,
                  (index) => InfoCard(index, blueValue, pinkcount),
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

  InfoCard(int index, List<List<Amenity>> blueValue, int pinkcount) {
    this.index = index;
    this.blueValue = blueValue;
    this.pinkcount = pinkcount;
  }

  @override
  State<InfoCard> createState() =>
      _InfoCardState(this.index, this.blueValue, this.pinkcount);
}

class _InfoCardState extends State<InfoCard> {
  int index;
  int pinkcount;
  List<List<Amenity>> blueValue;
  List<DropdownMenuItem<String>> listAmenity = [];
  List<String> amenity = [];
  String amenitySelected;
  Map<String, dynamic> amenityMap = {};
  _InfoCardState(this.index, this.blueValue, this.pinkcount);

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
    print(listAmenity);
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
                hint: Text(liveaboardDetial
                    .liveaboard.roomTypes[pinkcount].amenities[index].name),
                iconSize: 40,
                onChanged: (value) {
                  // if (value != null) {
                  setState(() {
                    amenitySelected = value;
                    amenity.forEach((element) {
                      if (element == amenitySelected) {
                        blueValue[pinkcount - 1][index - 1].name =
                            amenitySelected;
                        blueValue[pinkcount - 1][index - 1].id =
                            amenityMap[element];
                      }
                    });
                  });
                  // }
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
