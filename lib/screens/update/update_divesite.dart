import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:flutter/services.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

var ds;

class AddMoreDiveSiteUpdate extends StatefulWidget {
  List<DiveSite> pinkValue = [];
  TripWithTemplate eachTrip;
  final customFunction;
  AddMoreDiveSiteUpdate(List<DiveSite> pinkValue, TripWithTemplate eachTrip,
      this.customFunction) {
    this.pinkValue = pinkValue;
    this.eachTrip = eachTrip;
  }
  @override
  _AddMoreDiveSiteUpdateState createState() =>
      _AddMoreDiveSiteUpdateState(this.pinkValue, this.eachTrip);
}

class _AddMoreDiveSiteUpdateState extends State<AddMoreDiveSiteUpdate> {
  int pinkcount = 0;
  List<DiveSite> pinkValue = [];
  TripWithTemplate eachTrip;
  List<DiveSite> allDivesite = [];
  _AddMoreDiveSiteUpdateState(
      List<DiveSite> pinkValue, TripWithTemplate eachTrip) {
    this.pinkValue = pinkValue;
    this.eachTrip = eachTrip;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDivesite();
  }

  getDivesite() async {
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
    var listdivesiterequest = ListDiveSitesByTripRequest();
    listdivesiterequest.tripId = eachTrip.id;

    allDivesite.clear();
    try {
      await for (var feature in stub.listDiveSitesByTrip(listdivesiterequest)) {
        allDivesite.add(feature.diveSite);
      }
    } catch (e) {
      print('ERROR: $e');
    }
    // print('list ' + allDivesite.length.toString());
    return allDivesite.length;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        SizedBox(
          height: 20,
        ),
        Align(alignment: Alignment.topLeft, child: Text('  Divesite')),
        DiveSiteFormUpdate(this.pinkcount, this.pinkValue, this.eachTrip,
            widget.customFunction),
        Divider(
          thickness: 5,
          indent: 20,
          endIndent: 20,
        ),
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                ),
            shrinkWrap: true,
            itemCount: pinkcount,
            itemBuilder: (BuildContext context, int index) {
              // print('new form' + index.toString());
              // print('all dive form' + allDivesite.length.toString());
              return DiveSiteForm(pinkcount, this.pinkValue, this.eachTrip,
                  index + allDivesite.length, widget.customFunction);
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  pinkcount += 1;
                  ds = DiveSite();
                  ds.name = '';
                  ds.description = '';
                  ds.maxDepth = 0;
                  ds.minDepth = 0;
                  // print(eachTrip.diveSites.length);
                  eachTrip.diveSites.add(ds);
                  // print(eachTrip.diveSites.length);
                  // pinkValue.add(new DiveSite());
                });
              },
              color: Color(0xfff45b6fe),
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
            //       // pinkcount -= 1;
            //       // pinkValue.remove(new DiveSite());
            //       if (eachTrip.diveSites.length > 1) {
            //         eachTrip.diveSites.removeLast();
            //         print(eachTrip.diveSites);
            //       } else {
            //         pinkcount = 0;
            //       }
            //     });
            //   },
            //   color: Color(0xfff45b6fe),
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
        //   print(eachTrip.diveSites);
        // }),
      ])),
    );
  }
}

class DiveSiteFormUpdate extends StatefulWidget {
  int pinkcount;
  List<DiveSite> pinkValue;
  TripWithTemplate eachTrip;
  final customFunction;
  DiveSiteFormUpdate(int pinkcount, List<DiveSite> pinkValue,
      TripWithTemplate eachTrip, this.customFunction) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.eachTrip = eachTrip;
  }
  @override
  _DiveSiteFormUpdateState createState() =>
      _DiveSiteFormUpdateState(this.pinkcount, this.pinkValue, this.eachTrip);
}

class _DiveSiteFormUpdateState extends State<DiveSiteFormUpdate> {
  int pinkcount;
  String name;
  String description;
  String min_depth;
  String max_depth;
  TripWithTemplate eachTrip;
  List<DiveSite> pinkValue;
  List<DiveSite> allDivesite = [];

  _DiveSiteFormUpdateState(
      int pinkcount, List<DiveSite> pinkValue, TripWithTemplate eachTrip) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.eachTrip = eachTrip;
  }
  getDivesite() async {
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
    var listdivesiterequest = ListDiveSitesByTripRequest();
    listdivesiterequest.tripId = eachTrip.id;

    allDivesite.clear();
    try {
      await for (var feature in stub.listDiveSitesByTrip(listdivesiterequest)) {
        allDivesite.add(feature.diveSite);
      }
    } catch (e) {
      print('ERROR: $e');
    }

    return allDivesite;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        // Align(alignment: Alignment.topLeft, child: Text('  Divesite')),
        FutureBuilder(
          future: getDivesite(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Wrap(
                  spacing: 20,
                  runSpacing: 40,
                  children: List.generate(
                    allDivesite.length,
                    (index) => InfoCard(index, pinkcount, pinkValue, eachTrip,
                        widget.customFunction),
                  ));
            } else {
              return Center(child: Text('No divesite'));
            }
          },
        ),
      ],
    );
  }
}

class InfoCard extends StatefulWidget {
  int pinkcount;
  String name;
  String description;
  String min_depth;
  String max_depth;
  int index;
  TripWithTemplate eachTrip;
  final customFunction;
  List<DiveSite> pinkValue;

  InfoCard(int index, int pinkcount, List<DiveSite> pinkValue,
      TripWithTemplate eachTrip, this.customFunction) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.index = index;
    this.eachTrip = eachTrip;
  }
  @override
  State<InfoCard> createState() =>
      _InfoCardState(this.pinkcount, this.pinkValue, this.index, this.eachTrip);
}

class _InfoCardState extends State<InfoCard> {
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerMax = TextEditingController();
  final TextEditingController _controllerMin = TextEditingController();

  final TextEditingController _controllerName = TextEditingController();
  int pinkcount;
  String name;
  String description;
  String min_depth;
  String max_depth;
  int index;
  TripWithTemplate eachTrip;
  List<DiveSite> pinkValue;
  _InfoCardState(this.pinkcount, this.pinkValue, this.index, this.eachTrip);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerDescription.text = eachTrip.diveSites[index].description;
    _controllerMax.text = eachTrip.diveSites[index].maxDepth.toString();
    _controllerMin.text = eachTrip.diveSites[index].minDepth.toString();
    _controllerName.text = eachTrip.diveSites[index].name;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          // Text(index.toString()),
          SizedBox(height: 20),
          buildNameFormField(),
          SizedBox(height: 20),
          buildDescriptionFormField(),
          SizedBox(height: 20),
          buildMaxFormField(),
          SizedBox(height: 20),
          buildMinFormField(),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      controller: _controllerDescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => description = newValue,
      onChanged: (value) {
        // print(value);
        eachTrip.diveSites[index].description = value;
      },
      decoration: InputDecoration(
        labelText: "Description",
        filled: true,
        fillColor: Color(0xfffb7e9f7),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildMinFormField() {
    return TextFormField(
      controller: _controllerMin,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => min_depth = newValue,
      onChanged: (value) {
        // print(value);
        eachTrip.diveSites[index].minDepth = int.parse(value);
      },
      decoration: InputDecoration(
        labelText: "Min depth",
        filled: true,
        fillColor: Color(0xfffb7e9f7),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildMaxFormField() {
    return TextFormField(
      controller: _controllerMax,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => max_depth = newValue,
      onChanged: (value) {
        // print(value);
        eachTrip.diveSites[index].maxDepth = int.parse(value);
      },
      decoration: InputDecoration(
        labelText: "Max depth",
        filled: true,
        fillColor: Color(0xfffb7e9f7),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        // print(value);
        eachTrip.diveSites[index].name = value;
      },
      decoration: InputDecoration(
        labelText: "Name",
        filled: true,
        fillColor: Color(0xfffb7e9f7),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}

class DiveSiteForm extends StatefulWidget {
  int pinkcount;
  List<DiveSite> pinkValue;
  TripWithTemplate eachTrip;
  int indexForm;
  Map<String, dynamic> divesiteMap = {};
  final customFunction;
  DiveSiteForm(int pinkcount, List<DiveSite> pinkValue,
      TripWithTemplate eachTrip, int indexForm, this.customFunction) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.eachTrip = eachTrip;
    this.indexForm = indexForm;
  }
  @override
  _DiveSiteFormState createState() => _DiveSiteFormState(
      this.pinkcount, this.pinkValue, this.eachTrip, this.indexForm);
}

class _DiveSiteFormState extends State<DiveSiteForm> {
  int pinkcount;
  String name;
  String description;
  String min_depth;
  String max_depth;
  TripWithTemplate eachTrip;

  List<DiveSite> pinkValue;
  int indexForm;

  _DiveSiteFormState(int pinkcount, List<DiveSite> pinkValue,
      TripWithTemplate eachTrip, int indexForm) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.eachTrip = eachTrip;
    this.indexForm = indexForm;
  }
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerMax = TextEditingController();
  final TextEditingController _controllerMin = TextEditingController();
  final TextEditingController _controllerName = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          // Text(indexForm.toString()),
          SizedBox(height: 20),
          buildNameFormField(),
          SizedBox(height: 20),
          buildDescriptionFormField(),
          SizedBox(height: 20),
          buildMaxFormField(),
          SizedBox(height: 20),
          buildMinFormField(),
          SizedBox(height: 20),
          // FlatButton(
          //     color: Color(0xfff89cff0),
          //     child: Text(
          //       'Please save before add new divesites',
          //     ),
          //     onPressed: () {
          //       var ds = DiveSite();
          //       ds.name = name;
          //       ds.description = description;
          //       ds.maxDepth = int.parse(max_depth);
          //       ds.minDepth = int.parse(min_depth);
          //       eachTrip.diveSites.add(ds);
          //       print(eachTrip.diveSites);
          //       widget.customFunction(eachTrip.diveSites);
          //     }),
          // SizedBox(height: 20),
        ]),
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      controller: _controllerDescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => description = newValue,
      onChanged: (value) {
        // print(value);
        description = value;
        eachTrip.diveSites[indexForm].description = value;
      },
      decoration: InputDecoration(
        labelText: "Description",
        filled: true,
        fillColor: Color(0xfffb7e9f7),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildMinFormField() {
    return TextFormField(
      controller: _controllerMin,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => min_depth = newValue,
      onChanged: (value) {
        // print(value);
        min_depth = value;
        eachTrip.diveSites[indexForm].minDepth = int.parse(value);
      },
      decoration: InputDecoration(
        labelText: "Min depth",
        filled: true,
        fillColor: Color(0xfffb7e9f7),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildMaxFormField() {
    return TextFormField(
      controller: _controllerMax,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      // onSaved: (newValue) => max_depth = newValue,
      onChanged: (value) {
        // print(value);
        max_depth = value;
        eachTrip.diveSites[indexForm].maxDepth = int.parse(value);
      },
      decoration: InputDecoration(
        labelText: "Max depth",
        filled: true,
        fillColor: Color(0xfffb7e9f7),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFFf5579c6),
      // onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        // print(value);
        name = value;
        eachTrip.diveSites[indexForm].name = value;
      },
      decoration: InputDecoration(
        labelText: "Name",
        filled: true,
        fillColor: Color(0xfffb7e9f7),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
