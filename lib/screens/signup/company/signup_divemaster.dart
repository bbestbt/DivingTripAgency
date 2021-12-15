import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pbenum.dart';
import 'package:diving_trip_agency/screens/signup/company/addDiverMaster.dart';
import 'package:diving_trip_agency/screens/signup/company/divermaster_form.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_staff.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

class SignupDiveMaster extends StatefulWidget {
  @override
  State<SignupDiveMaster> createState() => _SignupDiveMasterState();
}

class _SignupDiveMasterState extends State<SignupDiveMaster> {
  List<DiveMaster> divemasterValue=[new DiveMaster()];
   void addDivemaster() {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);

    final stub = AgencyServiceClient(channel);
    var divemaster = DiveMaster();
    for(int i=0;i<divemasterValue.length;i++){
      divemaster.firstName=divemasterValue[i].firstName;
      divemaster.lastName=divemasterValue[i].lastName;
      divemaster.level=divemasterValue[i].level;
      //level,img
    }
    var divemasterRequest = AddDiveMasterRequest();
    divemasterRequest.diveMaster=divemaster;

    try {
      var response = stub.addDiveMaster(divemasterRequest);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color(0xffff598a8),
                  Color(0xffff6edb2),
                  Color(0xfffc5f7eb),
                ])),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    "Dive Master ",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 50),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: AddmoreDiverMaster(this.divemasterValue)),
                  SizedBox(height: 20),
                  FlatButton(
                    onPressed: () => {
                      addDivemaster(),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupStaff()))
                    },
                    color: Color(0xfff75BDFF),
                    child: Text(
                      'Confirm',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
