import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/screens/create_trip/trip_template.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'dart:io' as io;

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

  io.File boatimg;
  XFile bboat;

  final List<String> errors = [];
 // List<File> boatImg = new List<File>();
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

  void AddBoat() async {
    print("before try catch");
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
        final box = Hive.box('userInfo');
        String token = box.get('token');

    final stub = AgencyServiceClient(channel,   options: CallOptions(metadata:{'Authorization':  '$token'}));
    var boat = DivingBoat();
    boat.boatModel=_controllerName.text;
    //boat.boatImages.add();

    var boatRequest = AddDivingBoatRequest();
    boatRequest.divingBoat = boat;
  //  boatRequest.agencyId= boatRequest.agencyId+4;

    var f = File();
    f.filename = bboat.name;
    //var t = await imageFile.readAsBytes();
    //f.file = new List<int>.from(t);
    List<int> b = await bboat.readAsBytes();
    f.file = b;
    boat.boatImages.add(f);

   // try {
    //  var response = stub.addDivingBoat(boatRequest);
    //  print('response: ${response}');
   // } catch (e) {
    //  print(e);
    //}
 // }

  try {
  var response = await stub.addDivingBoat(boatRequest);
  print(token);
  print(response);

  } on GrpcError catch (e) {
  // Handle exception of type GrpcError
  print('codeName: ${e.codeName}');
  print('details: ${e.details}');
  print('message: ${e.message}');
  print('rawResponse: ${e.rawResponse}');
  print('trailers: ${e.trailers}');
  } catch (e) {
  // Handle all other exceptions
  print('Exception: $e');
  }
}

  /// Get from gallery
  _getPicBoat() async {
      bboat = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    if (bboat != null) {
      setState(() {
        boatimg = io.File(bboat.path);
        //card = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildBoatNameFormField(),
          SizedBox(height: 20),
          //   FormError(errors: errors),
            Row(
            children: [
              Text('Image'),
              Center(
                child: boatimg == null
                    ? Text('')
                    : kIsWeb
                    ? Image.network(
                  boatimg.path,
                  fit: BoxFit.cover,
                  width: screenwidth*0.2,
                )
                    : Image.file(
                  io.File(boatimg.path),
                  fit: BoxFit.cover,
                  width: screenwidth*0.05,
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
           SizedBox(height: 20),
          FlatButton(
            //onPressed: () => {Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()))},
            onPressed: () => {
              AddBoat(),
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
