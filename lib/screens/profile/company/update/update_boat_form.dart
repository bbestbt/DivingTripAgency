import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/aboutus/about_us_page.dart';
import 'package:diving_trip_agency/screens/create_boat/create_boat_form.dart';

import 'package:diving_trip_agency/screens/create_trip/create_trip_form.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'dart:io' as io;

import 'package:image_picker/image_picker.dart';

class updateEachBoat extends StatelessWidget {
  updateEachBoat(Boat eachBoats) {
    this.eachBoats = eachBoats;
  }
  // int index;
  Boat eachBoats;
  GetProfileResponse user_profile = new GetProfileResponse();
  var profile;
  getProfile() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');
    final pf = AccountClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    profile = await pf.getProfile(new Empty());
    // return profile;

    if (profile.hasAgency()) {
      user_profile = profile;
      return user_profile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: CompanyHamburger(),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Color(0xFFFFfd8be).withOpacity(0.3)),
          child: Column(
            children: [
              HeaderCompany(),
              SizedBox(height: 50),
              SectionTitle(
                title: "Update Boat",
                color: Color(0xFFFF78a2cc),
              ),
              SizedBox(
                height: 30,
              ),
              SizedBox(
                width: 1110,
                child: FutureBuilder(
                  future: getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          width: MediaQuery.of(context).size.width / 1.5,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: UpdateBoatForm(this.eachBoats));
                    } else {
                      return Center(child: Text('User is not logged in'));
                    }
                  },
                ),
              ),
              SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class UpdateBoatForm extends StatefulWidget {
  Boat eachBoat;
  UpdateBoatForm(Boat eachBoat) {
    this.eachBoat = eachBoat;
  }
  @override
  _UpdateBoatFormState createState() => _UpdateBoatFormState(this.eachBoat);
}

class _UpdateBoatFormState extends State<UpdateBoatForm> {
  Boat eachBoat;
  _UpdateBoatFormState(Boat eachBoat) {
    this.eachBoat = eachBoat;
  }
  String boatname;

  io.File boatimg;
  io.File boatimg2;
  io.File boatimg3;
  io.File boatimg4;
  io.File boatimg5;

  XFile bboat;
  String boat_capacity;
  String description;
  String diver_capacity;
  String staff_capacity;
  String address1;
  String address2;
  String postalCode;
  String country;
  String region;
  String city;

  final List<String> errors = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerCapacity = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerDivercapacity =
      TextEditingController();
  final TextEditingController _controllerStaffcapacity =
      TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerAddress2 = TextEditingController();
  final TextEditingController _controllerPostalcode = TextEditingController();
  final TextEditingController _controllerCountry = TextEditingController();
  final TextEditingController _controllerRegion = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
    var boat = Boat();
    boat.name = _controllerName.text;
    boat.description = _controllerDescription.text;
    boat.totalCapacity = int.parse(_controllerCapacity.text);
    boat.diverCapacity = int.parse(_controllerDivercapacity.text);
    boat.staffCapacity = int.parse(_controllerStaffcapacity.text);

    var address = Address();
    address.addressLine1 = _controllerAddress.text;
    address.addressLine2 = _controllerAddress2.text;
    address.city = _controllerCity.text;
    address.postcode = _controllerPostalcode.text;
    address.region = _controllerRegion.text;
    address.country = _controllerCountry.text;
    boat.address = address;
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
    boat.images.add(f);

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
  _getPicBoat(int num) async {
    bboat = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );

    if (bboat != null) {
      setState(() {
        if (num == 1) boatimg = io.File(bboat.path);
        if (num == 2) boatimg2 = io.File(bboat.path);
        if (num == 3) boatimg3 = io.File(bboat.path);
        if (num == 4) boatimg4 = io.File(bboat.path);
        if (num == 5) boatimg5 = io.File(bboat.path);
        //boatimg = io.File(bboat.path);
        //card = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(eachBoat.name);
    double screenwidth = MediaQuery.of(context).size.width;
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildBoatNameFormField(),
          SizedBox(height: 20),
          buildDescriptionFormField(),
          SizedBox(height: 20),
          buildBoatCapacityFormField(),
          SizedBox(height: 20),
          buildDiverCapacityFormField(),
          SizedBox(height: 20),
          buildStaffCapacityFormField(),
          SizedBox(height: 20),
          buildAddressFormField(),
          SizedBox(height: 20),
          buildAddress2FormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildCountryFormField()),
              Spacer(),
              // Spacer(flex: 1,),
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildCityFormField()),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildRegionFormField()),
              Spacer(),
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildPostalCodeFormField()),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('Image'),
              SizedBox(width: 30),
              Container(
                  width: MediaQuery.of(context).size.width / 10,
                  height: MediaQuery.of(context).size.width / 10,
                  child: eachBoat.images[0] == null
                      ? new Container(
                          color: Colors.blue,
                        )
                      : Image.network(
                          // 'http://139.59.101.136/static/'+
                          eachBoat.images[0].link.toString())),
              SizedBox(width: 30),
              Center(
                child: boatimg == null
                    ? Text('')
                    : kIsWeb
                        ? Image.network(
                            boatimg.path,
                            fit: BoxFit.cover,
                            width: screenwidth * 0.2,
                          )
                        : Image.file(
                            io.File(boatimg.path),
                            fit: BoxFit.cover,
                            width: screenwidth * 0.05,
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
                  _getPicBoat(1);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('Image'),
              SizedBox(width: 30),
              // Container(
              //     width: MediaQuery.of(context).size.width / 10,
              //     height: MediaQuery.of(context).size.width / 10,
              //     child: eachBoat.images[1] == null
              //         ? new Container(
              //             color: Colors.blue,
              //           )
              //         : Image.network(
              //             // 'http://139.59.101.136/static/'+
              //             eachBoat.images[1].link.toString())),
              SizedBox(width: 30),
              Center(
                child: boatimg2 == null
                    ? Text('')
                    : kIsWeb
                        ? Image.network(
                            boatimg2.path,
                            fit: BoxFit.cover,
                            width: screenwidth * 0.2,
                          )
                        : Image.file(
                            io.File(boatimg2.path),
                            fit: BoxFit.cover,
                            width: screenwidth * 0.05,
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
                  _getPicBoat(2);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('Image'),
              SizedBox(width: 30),
              // Container(
              //     width: MediaQuery.of(context).size.width / 10,
              //     height: MediaQuery.of(context).size.width / 10,
              //     child: eachBoat.images[2] == null
              //         ? new Container(
              //             color: Colors.blue,
              //           )
              //         : Image.network(
              //             // 'http://139.59.101.136/static/'+
              //             eachBoat.images[2].link.toString())),
              SizedBox(width: 30),
              Center(
                child: boatimg3 == null
                    ? Text('')
                    : kIsWeb
                        ? Image.network(
                            boatimg3.path,
                            fit: BoxFit.cover,
                            width: screenwidth * 0.2,
                          )
                        : Image.file(
                            io.File(boatimg3.path),
                            fit: BoxFit.cover,
                            width: screenwidth * 0.05,
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
                  _getPicBoat(3);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('Image'),
              SizedBox(width: 30),
              // Container(
              //     width: MediaQuery.of(context).size.width / 10,
              //     height: MediaQuery.of(context).size.width / 10,
              //     child: eachBoat.images[3] == null
              //         ? new Container(
              //             color: Colors.blue,
              //           )
              //         : Image.network(
              //             // 'http://139.59.101.136/static/'+
              //             eachBoat.images[3].link.toString())),
              SizedBox(width: 30),
              Center(
                child: boatimg4 == null
                    ? Text('')
                    : kIsWeb
                        ? Image.network(
                            boatimg4.path,
                            fit: BoxFit.cover,
                            width: screenwidth * 0.2,
                          )
                        : Image.file(
                            io.File(boatimg4.path),
                            fit: BoxFit.cover,
                            width: screenwidth * 0.05,
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
                  _getPicBoat(4);
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Text('Image'),
              SizedBox(width: 30),
              // Container(
              //     width: MediaQuery.of(context).size.width / 10,
              //     height: MediaQuery.of(context).size.width / 10,
              //     child: eachBoat.images[4] == null
              //         ? new Container(
              //             color: Colors.blue,
              //           )
              //         : Image.network(
              //             // 'http://139.59.101.136/static/'+
              //             eachBoat.images[4].link.toString())),
              SizedBox(width: 30),
              Center(
                child: boatimg5 == null
                    ? Text('')
                    : kIsWeb
                        ? Image.network(
                            boatimg5.path,
                            fit: BoxFit.cover,
                            width: screenwidth * 0.2,
                          )
                        : Image.file(
                            io.File(boatimg5.path),
                            fit: BoxFit.cover,
                            width: screenwidth * 0.05,
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
                  _getPicBoat(5);
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
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please Enter boat name");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please Enter boat name");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "Boat name",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildBoatCapacityFormField() {
    return TextFormField(
      controller: _controllerCapacity,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => boat_capacity = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please Enter total capacty");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please Enter total capacty");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "total capacity",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      controller: _controllerDescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => description = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please Enter description");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please Enter description");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "Description",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildDiverCapacityFormField() {
    return TextFormField(
      controller: _controllerDivercapacity,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => diver_capacity = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please Enter diver capacity");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please Enter diver capacity");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "Diver capacity",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildStaffCapacityFormField() {
    return TextFormField(
      controller: _controllerStaffcapacity,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => staff_capacity = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please Enter staff capacity");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please Enter staff capacity");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        labelText: "Staff capacity",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: _controllerAddress,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address1 = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter address");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter address");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
          //    hintText: "Address1",
          labelText: "Address 1",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildAddress2FormField() {
    return TextFormField(
      controller: _controllerAddress2,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address2 = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter address");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter address");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
          //   hintText: "Address2",
          labelText: "Address 2",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildCountryFormField() {
    return TextFormField(
      controller: _controllerCountry,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => country = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter country");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter country");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        //   hintText: "Country",
        labelText: "Country",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildCityFormField() {
    return TextFormField(
      controller: _controllerCity,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => city = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter city");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter city");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        //   hintText: "City",
        labelText: "City",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildRegionFormField() {
    return TextFormField(
      controller: _controllerRegion,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => region = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter region");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter region");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        //    hintText: "Region",
        labelText: "Region",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPostalCodeFormField() {
    return TextFormField(
      controller: _controllerPostalcode,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => postalCode = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter postal code");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter postal code");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        //   hintText: "Postal code",
        labelText: "Postal code",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
