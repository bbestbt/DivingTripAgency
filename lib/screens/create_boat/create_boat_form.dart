import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/screens/create_trip/trip_template.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class CreateBoatForm extends StatefulWidget {
  @override
  _CreateBoatFormState createState() => _CreateBoatFormState();
}

class _CreateBoatFormState extends State<CreateBoatForm> {
  String boatname;
  //img
  File boat;
  final List<String> errors = [];

  final TextEditingController _controllerName = TextEditingController();

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  void AddBoat() {
    print("before try catch");
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);

    final stub = AgencyServiceClient(channel);
    var boat = DivingBoat();
    boat.boatModel=_controllerName.text;

    var boatRequest = AddDivingBoatRequest();
    boatRequest.divingBoat = boat;

    try {
      var response = stub.addDivingBoat(boatRequest);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }

  /// Get from gallery
  _getPicBoat() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        boat = File(pickedFile.path);
        //card = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildBoatNameFormField(),
          SizedBox(height: 20),
          //   FormError(errors: errors),
          FlatButton(
            //onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()))},
            onPressed: () => {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => MainCompanyScreen(),
                ),
                (route) => false,
              )
            },
            color: Color(0xfff75BDFF),
            child: Text(
              'Confirm',
              style: TextStyle(fontSize: 15),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(height: 20),
          Row(
            children: [
              Text('Boat Image'),
              Center(
                child: boat == null
                    ? Text('')
                    : kIsWeb
                    ? Image.network(
                  boat.path,
                  fit: BoxFit.cover,
                  width: 300,
                )
                    : Image.file(
                  File(boat.path),
                  fit: BoxFit.cover,
                  width: 300,
                ),
              ),
              /* Spacer(),
              DiverImage == null
                  ? Text('')
                  :
                  print(DiverImage.path)
              ,*/
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getPicBoat();
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }

  TextFormField buildBoatNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => boatname = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter boat model");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter boat model");
          return "";
        }
        return null;
      },

      decoration: InputDecoration(
        labelText: "Boat model",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
