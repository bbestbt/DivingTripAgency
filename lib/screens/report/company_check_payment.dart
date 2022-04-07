import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pbgrpc.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/payment/payment_screen.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:diving_trip_agency/screens/ShopCart/ShopcartWidget.dart';
import 'package:intl/intl.dart';

class CompanyCheckpayment extends StatefulWidget {
  List<Diver> diver = [];
  int index;
  CompanyCheckpayment(List<Diver> diver, int index) {
    this.diver = diver;
    this.index = index;
  }
  @override
  State<CompanyCheckpayment> createState() =>
      _CompanyCheckpaymentState(this.diver, this.index);
}

class _CompanyCheckpaymentState extends State<CompanyCheckpayment> {
  List<Diver> diver = [];
  int index;
  bool isChecked = false;
  _CompanyCheckpaymentState(List<Diver> diver, int index) {
    this.diver = diver;
    this.index = index;
  }
  final MenuController _controller = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Scaffold(
        key: _controller.scaffoldkey,
        drawer: SideMenu(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                HeaderCompany(),
                SizedBox(height: 30),
                SectionTitle(
                  title: "Review",
                  color: Color(0xFFFF78a2cc),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'List of divers',
                          style: TextStyle(fontSize: 20),
                        ),
                        diver.length == 0
                            ? new Text("No diver")
                            : new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Firstname : " +
                                      diver[widget.index].firstName),
                                  Text("Lastname : " +
                                      diver[widget.index].lastName),
                                  Text("Phone number :" +
                                      diver[widget.index].phone),
                                  Text("Level :" +
                                      diver[widget.index].level.toString()),
                                ],
                              )
                      ],
                    ),
                    SizedBox(
                      width: 50,
                    ),
                    Column(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Payment',
                          style: TextStyle(fontSize: 20),
                        ),
                        Checkbox(
                          checkColor: Colors.white,
                          fillColor:
                              MaterialStateProperty.resolveWith(getColor),
                          value: isChecked,
                          onChanged: (bool value) {
                            setState(() {
                              isChecked = value;
                            });
                          },
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
