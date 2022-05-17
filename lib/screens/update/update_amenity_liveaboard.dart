import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/amenity.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';

class AddMoreAmenityUpdateLiveaboard extends StatefulWidget {
  List<List<Amenity>> blueValue;
  Liveaboard eachLiveaboard;
  int bluecount;
  final customFunction;
  int pinkcount;
  AddMoreAmenityUpdateLiveaboard(
      Liveaboard eachLiveaboard,
      // int bluecount,
      int pinkcount,
      this.customFunction
      // List<List<Amenity>> blueValue,
      ) {
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.eachLiveaboard = eachLiveaboard;
    // this.bluecount = bluecount;
  }
  @override
  _AddMoreAmenityUpdateLiveaboardState createState() =>
      _AddMoreAmenityUpdateLiveaboardState(this.eachLiveaboard, this.pinkcount);
}

class _AddMoreAmenityUpdateLiveaboardState
    extends State<AddMoreAmenityUpdateLiveaboard> {
  int bluecount = 0;
  int pinkcount;
  List<List<Amenity>> blueValue;
  Liveaboard eachLiveaboard;

  _AddMoreAmenityUpdateLiveaboardState(
    Liveaboard eachLiveaboard,
    // int bluecount,
    int pinkcount,
    // List<List<Amenity>> blueValue,
  ) {
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.eachLiveaboard = eachLiveaboard;
    // this.bluecount = bluecount;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        updateAmenityLiveaboardForm(this.eachLiveaboard, this.bluecount,
            this.pinkcount, this.blueValue, widget.customFunction),
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
                      liveaboardDetial
                          .liveaboard.roomTypes[pinkcount].amenities.length,
                  this.eachLiveaboard,
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
            // SizedBox(width: 30),
            // MaterialButton(
            //   onPressed: () {
            //     setState(() {
            //       bluecount -= 1;
            //       // blueValue[pinkcount].remove(new Amenity());
            //     });
            //   },
            //   color: Color(0xfff8fcaca),
            //   textColor: Colors.white,
            //   child: Icon(
            //     Icons.remove,
            //     size: 20,
            //   ),
            // ),
          ],
        ),
        SizedBox(height: 30),
        // FlatButton(onPressed: () {
        //   print(eachLiveaboard.roomTypes[pinkcount].amenities);
        // }),
      ])),
    );
  }
}

GetLiveaboardResponse liveaboardDetial = new GetLiveaboardResponse();
var liveaboard;

class updateAmenityLiveaboardForm extends StatefulWidget {
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;
  Liveaboard eachLiveaboard;
  final customFunction;
  updateAmenityLiveaboardForm(Liveaboard eachLiveaboard, int blue,
      int pinkcount, List<List<Amenity>> blueValue, this.customFunction) {
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
                  (index) => InfoCard(index, blueValue, pinkcount,
                      eachLiveaboard, widget.customFunction),
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
  Liveaboard eachLiveaboard;
  final customFunction;
  InfoCard(int index, List<List<Amenity>> blueValue, int pinkcount,
      Liveaboard eachLiveaboard, this.customFunction) {
    this.index = index;
    this.blueValue = blueValue;
    this.pinkcount = pinkcount;
    this.eachLiveaboard = eachLiveaboard;
  }

  @override
  State<InfoCard> createState() => _InfoCardState(
      this.index, this.blueValue, this.pinkcount, this.eachLiveaboard);
}

class _InfoCardState extends State<InfoCard> {
  int index;
  int pinkcount;
  List<List<Amenity>> blueValue;
  List<DropdownMenuItem<String>> listAmenity = [];
  List<String> amenity = [];
  String amenitySelected;
  Map<String, dynamic> amenityMap = {};
  Liveaboard eachLiveaboard;
  _InfoCardState(
      this.index, this.blueValue, this.pinkcount, this.eachLiveaboard);

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
          // Text(index.toString()),
          SizedBox(height: 20),
          Container(
            color: Color(0xfffd4f0f0),
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
                  setState(() {
                    amenitySelected = value;
                    amenity.forEach((element) {
                      if (element == amenitySelected) {
                        eachLiveaboard.roomTypes[pinkcount].amenities[index]
                            .name = amenitySelected;
                        eachLiveaboard.roomTypes[pinkcount].amenities[index]
                            .id = amenityMap[element];
                        print(eachLiveaboard);
                        widget.customFunction(
                            eachLiveaboard.roomTypes[pinkcount].amenities);
                      }
                    });
                  });
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

class amenityForm extends StatefulWidget {
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;
  int indexForm;
  Liveaboard eachLiveaboard;
  final customFunction;
  amenityForm(int blue, int pinkcount, List<List<Amenity>> blueValue,
      int indexForm, Liveaboard eachLiveaboard, this.customFunction) {
    this.bluecount = blue;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.indexForm = indexForm;
    this.eachLiveaboard = eachLiveaboard;
  }
  @override
  _amenityFormState createState() => _amenityFormState(this.bluecount,
      this.pinkcount, this.blueValue, this.indexForm, this.eachLiveaboard);
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
  Liveaboard eachLiveaboard;

  _amenityFormState(int bluecount, int pinkcount, List<List<Amenity>> blueValue,
      int indexForm, Liveaboard eachLiveaboard) {
    this.bluecount = bluecount;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.indexForm = indexForm;
    this.eachLiveaboard = eachLiveaboard;
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
          // Text(indexForm.toString()),
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
                          var am = Amenity();
                          am.name = amenitySelected;
                          am.id = amenityMap[element];
                          eachLiveaboard.roomTypes[pinkcount].amenities.add(am);
                          eachLiveaboard.roomTypes[pinkcount]
                              .amenities[indexForm].name = amenitySelected;
                          eachLiveaboard.roomTypes[pinkcount]
                              .amenities[indexForm].id = amenityMap[element];
                          widget.customFunction(
                              eachLiveaboard.roomTypes[pinkcount].amenities);
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
