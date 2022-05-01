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

class DiveSiteFormUpdate extends StatefulWidget {
  int pinkcount;
  List<DiveSite> pinkValue;

  DiveSiteFormUpdate(
    int pinkcount,
    List<DiveSite> pinkValue,
  ) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
  }
  @override
  _DiveSiteFormUpdateState createState() =>
      _DiveSiteFormUpdateState(this.pinkcount, this.pinkValue);
}

class _DiveSiteFormUpdateState extends State<DiveSiteFormUpdate> {
  int pinkcount;
  String name;
  String description;
  String min_depth;
  String max_depth;

  List<DiveSite> pinkValue;

  _DiveSiteFormUpdateState(int pinkcount, List<DiveSite> pinkValue) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Align(alignment: Alignment.topLeft, child: Text('  Divesite')),
        Wrap(
            spacing: 20,
            runSpacing: 40,
            children: List.generate(
              1,
              (index) => InfoCard(index, pinkcount, pinkValue),
            )),
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

  List<DiveSite> pinkValue;

  InfoCard(int index, int pinkcount, List<DiveSite> pinkValue) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.index = index;
  }
  @override
  State<InfoCard> createState() =>
      _InfoCardState(this.pinkcount, this.pinkValue, this.index);
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

  List<DiveSite> pinkValue;
  _InfoCardState(this.pinkcount, this.pinkValue, this.index);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerDescription.text = '1';
    _controllerMax.text = '3';
    _controllerMin.text = '3';
    _controllerName.text = '2';
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
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
        pinkValue[pinkcount - 1].description = value;
      },
      decoration: InputDecoration(
        labelText: "Description",
        filled: true,
        fillColor: Color(0xffffee1e8),
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
        pinkValue[pinkcount - 1].minDepth = int.parse(value);
      },
      decoration: InputDecoration(
        labelText: "Min depth",
        filled: true,
        fillColor: Color(0xffffee1e8),
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
        // print('room max start');
        // print(pinkcount);
        // print('room max end');
        pinkValue[pinkcount - 1].maxDepth = int.parse(value);
        // print(value);
        // print("===");
      },
      decoration: InputDecoration(
        labelText: "Max depth",
        filled: true,
        fillColor: Color(0xffffee1e8),
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
        pinkValue[pinkcount - 1].name = value;
      },
      decoration: InputDecoration(
        labelText: "Name",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
