import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_trip/create_trip_screen.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/signup/company/addStaff.dart';
import 'package:diving_trip_agency/screens/signup/company/staff_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class updateEachDiveMaster extends StatefulWidget {
  DiveMaster DiveMasterName;
  updateEachDiveMaster(DiveMaster DiveMasterName) {
    this.DiveMasterName = DiveMasterName;
  }

  @override
  State<updateEachDiveMaster> createState() =>
      _updateEachDiveMasterState(this.DiveMasterName);
}

class _updateEachDiveMasterState extends State<updateEachDiveMaster> {
  DiveMaster DiveMasterName;
  final _formKey = GlobalKey<FormState>();
  _updateEachDiveMasterState(this.DiveMasterName);
  GetProfileResponse user_profile = new GetProfileResponse();
  var profile;
  Map<String, int> levelTypeMap = {};

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
        child: Form(
          child: Container(
            width: double.infinity,
            decoration:
                BoxDecoration(color: Color(0xFFFFfd8be).withOpacity(0.3)),
            child: Column(
              children: [
                HeaderCompany(),
                SizedBox(height: 50),
                SectionTitle(
                  title: "Update Dive Master",
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
                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: DiveMasterForm(this.DiveMasterName),
                            ),
                          ],
                        );
                      } else {
                        return Center(child: Text('User is not logged in'));
                      }
                    },
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DiveMasterForm extends StatefulWidget {
  DiveMaster divemasterValue;
  DiveMasterForm(DiveMaster divemasterValue) {
    this.divemasterValue = divemasterValue;
  }
  @override
  _StaffFormState createState() => _StaffFormState(this.divemasterValue);
}

class _StaffFormState extends State<DiveMasterForm> {
  String name;
  String lastname;
  DiveMaster divemasterValue;
  String levelSelected = null;
  Map<String, int> levelTypeMap = {};
  List<DropdownMenuItem<String>> listLevel = [];
  List<LevelType> level = [
    LevelType.MASTER,
    LevelType.OPEN_WATER,
    LevelType.RESCUE,
    LevelType.INSTRUCTOR,
    LevelType.ADVANCED_OPEN_WATER
  ];

  List<String> errors = [];
  _StaffFormState(DiveMaster divemasterValue) {
    this.divemasterValue = divemasterValue;
  }

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();

  io.File CardFile;
  XFile cb;
  io.File CardFileBack;
  XFile ca;

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

  void loadData() async {
    level.forEach((element) {
      // print(element);
    });
    listLevel = level
        .map((val) => DropdownMenuItem<String>(
            child: Text(val.toString()), value: val.value.toString()))
        .toList();

    String value;

    for (var i = 0; i < LevelType.values.length; i++) {
      value = LevelType.valueOf(i).toString();
      levelTypeMap[value] = i;
    }
  }

  void sendUpdateDivemaster() async {
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

    divemasterValue.firstName = _controllerName.text;
    divemasterValue.lastName = _controllerLastname.text;

    var f = File();
    f.filename = 'Image.jpg';
    //var t = await imageFile.readAsBytes();
    //f.file = new List<int>.from(t);
    if (CardFile != null) {
      List<int> b = await CardFile.readAsBytes();
      f.file = b;
      divemasterValue.documents.add(f);
    }

    var f2 = File();
    f2.filename = 'Image.jpg';
    if (CardFileBack != null) {
      List<int> a = await CardFileBack.readAsBytes();
      f2.file = a;
      divemasterValue.documents.add(f2);
    }

    if (levelSelected != null) {
      LevelType.values.forEach((levelType) {
        if (levelTypeMap[levelType.toString()] == int.parse(levelSelected)) {
          divemasterValue.level = levelType;
        }
      });
    }

    var divemaster = DiveMaster();
    divemaster.firstName = divemasterValue.firstName;
    divemaster.lastName = divemasterValue.lastName;
    if (levelSelected != null) {
      divemaster.level = divemasterValue.level;
    }
    for (int i = 0; i < divemaster.documents.length; i++) {
      divemasterValue.documents.add(divemaster.documents[i]);
    }

    final updateRequest = UpdateDiveMasterRequest()..diveMaster = divemaster;
    print(updateRequest);
    try {
      var response = stub.updateDiveMaster(updateRequest);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      _controllerName.text = divemasterValue.firstName;
      _controllerLastname.text = divemasterValue.lastName;
    });
  }

  _getCard() async {
    ca = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    var f2 = File();
    f2.filename = ca.name;
    //f2.filename = 'image.jpg';
    List<int> b = await ca.readAsBytes();
    f2.file = b;
    //this.imagelist.add(f);
    this.divemasterValue.documents.add(f2);

    if (ca != null) {
      setState(() {
        CardFile = io.File(ca.path);
      });
    }
  }

  _getCardBack() async {
    cb = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    var f = File();
    f.filename = cb.name;
    //f2.filename = 'image.jpg';
    List<int> a = await cb.readAsBytes();
    f.file = a;
    //this.imagelist.add(f);
    this.divemasterValue.documents.add(f);

    if (cb != null) {
      setState(() {
        CardFileBack = io.File(cb.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildNameFormField(),
          SizedBox(height: 20),
          buildLastnameFormField(),
          SizedBox(height: 20),
          Container(
            color: Colors.white,
            //color: Color(0xFFFd0efff),
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: levelSelected,
                items: listLevel,
                hint: Text(divemasterValue.level.toString()),
                iconSize: 40,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      levelSelected = value;

                      print(value);
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [Text("Divemaster"), Text('Card'), Text('(Front)')],
              ),
              Center(
                  child: CardFile == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              CardFile.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(CardFile.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 20.0, minHeight: 10.0),
                  child: Text(
                    'Upload',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                onPressed: () {
                  _getCard();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [Text("Divemaster"), Text('Card'), Text("(Back)")],
              ),
              Center(
                  child: CardFileBack == null
                      ? Column(
                          children: [
                            //Text('Divemaster Card '),
                            // Text('(Back)')
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              CardFileBack.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(CardFileBack.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 20.0, minHeight: 10.0),
                  child: Text(
                    'Upload',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                onPressed: () {
                  _getCardBack();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          FlatButton(
            onPressed: () async {
              await sendUpdateDivemaster();
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MainCompanyScreen()));
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

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFFf5579c6),
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      decoration: InputDecoration(
          //      hintText: "Name",
          labelText: "First Name",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildLastnameFormField() {
    return TextFormField(
        controller: _controllerLastname,
        cursorColor: Color(0xFFf5579c6),
        keyboardType: TextInputType.name,
        onSaved: (newValue) => lastname = newValue,
        decoration: InputDecoration(
            //    hintText: "Lastname",
            labelText: "Last Name",
            filled: true,
            fillColor: Colors.white,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: Icon(Icons.person)));
  }
}
