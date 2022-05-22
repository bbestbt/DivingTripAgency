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

class updateEachStaff extends StatefulWidget {
  Staff staffName;
  updateEachStaff(Staff staffName) {
    this.staffName = staffName;
  }

  @override
  State<updateEachStaff> createState() => _updateEachStaffState(this.staffName);
}

class _updateEachStaffState extends State<updateEachStaff> {
  Staff staffName;
  final _formKey = GlobalKey<FormState>();
  _updateEachStaffState(this.staffName);
  GetProfileResponse user_profile = new GetProfileResponse();
  var profile;
  Map<String, int> genderTypeMap = {};

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
                BoxDecoration(color: Color(0xfffe6e6ca).withOpacity(0.3)),
            child: Column(
              children: [
                HeaderCompany(),
                SizedBox(height: 50),
                SectionTitle(
                  title: "Update staff",
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
                              child: StaffForm(this.staffName),
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

class StaffForm extends StatefulWidget {
  Staff staffValue;
  StaffForm(Staff staffValue) {
    this.staffValue = staffValue;
  }
  @override
  _StaffFormState createState() => _StaffFormState(this.staffValue);
}

class _StaffFormState extends State<StaffForm> {
  String name;
  String lastname;
  String position;
  int count;
  Staff staffValue;
  String genderSelected = null;
  Map<String, int> genderTypeMap = {};
  List<DropdownMenuItem<String>> listGender = [];
  List<GenderType> gender = [GenderType.MALE, GenderType.FEMALE];
  List<String> errors = [];
  _StaffFormState(Staff staffValue) {
    this.staffValue = staffValue;
  }

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerPosition = TextEditingController();

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
    gender.forEach((element) {
      // print(element);
    });
    listGender = gender
        .map((val) => DropdownMenuItem<String>(
            child: Text(val.toString()), value: val.value.toString()))
        .toList();

    String value;

    for (var i = 0; i < GenderType.values.length; i++) {
      value = GenderType.valueOf(i).toString();
      genderTypeMap[value] = i;
    }
  }

  void sendUpdateStaff() async {
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

    staffValue.firstName = _controllerName.text;
    staffValue.lastName = _controllerLastname.text;
    staffValue.position = _controllerPosition.text;

    if (genderSelected != null) {
      GenderType.values.forEach((genderType) {
        if (genderTypeMap[genderType.toString()] == int.parse(genderSelected)) {
          staffValue.gender = genderType;
          print(staffValue.gender);
        }
      });
    }

    var staff = Staff();
    staff.id = staffValue.id;
    staff.firstName = staffValue.firstName;
    staff.lastName = staffValue.lastName;
    staff.position = staffValue.position;
    if (genderSelected != null) {
      print('select' + genderSelected);
      staff.gender = staffValue.gender;
    }

    final updateRequest = UpdateStaffRequest()..staff = staff;
    print(updateRequest);
    try {
      var response = await stub.updateStaff(updateRequest);
      print('response: ${response}');
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => MainCompanyScreen()));
    } on GrpcError catch (e) {
      // Handle exception of type GrpcError
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(e.message),
              actions: <Widget>[],
            );
          });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setState(() {
      _controllerName.text = staffValue.firstName;
      _controllerLastname.text = staffValue.lastName;
      _controllerPosition.text = staffValue.position;
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildNameFormField(),
          SizedBox(height: 20),
          buildLastnameFormField(),
          SizedBox(height: 20),
          buildPositionFormField(),
          SizedBox(height: 20),
          Container(
            color: Colors.white,
            //color: Color(0xFFFd0efff),
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: genderSelected,
                items: listGender,
                hint: Text(staffValue.gender.toString()),
                iconSize: 40,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      genderSelected = value;

                      print(value);
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          FlatButton(
            onPressed: () async {
              await sendUpdateStaff();
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

  TextFormField buildPositionFormField() {
    return TextFormField(
      controller: _controllerPosition,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => position = newValue,
      decoration: InputDecoration(
        //   hintText: "Position",
        labelText: "Position",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
