import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/payment.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pbgrpc.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/payment/payment_screen.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:diving_trip_agency/screens/ShopCart/ShopcartWidget.dart';
import 'package:intl/intl.dart';

GetPaymentByReservationResponse paymentDetial =
    new GetPaymentByReservationResponse();
var payment;

class CompanyCheckpayment extends StatefulWidget {
  List<Diver> diver = [];
  List<Reservation> reservation = [];
  int index;
  CompanyCheckpayment(
      List<Diver> diver, int index, List<Reservation> reservation) {
    this.diver = diver;
    this.index = index;
    this.reservation = reservation;
  }
  @override
  State<CompanyCheckpayment> createState() =>
      _CompanyCheckpaymentState(this.diver, this.index, this.reservation);
}

class _CompanyCheckpaymentState extends State<CompanyCheckpayment> {
  List<Diver> diver = [];
  int index;
  bool isChecked = false;
  List<Reservation> reservation = [];
  _CompanyCheckpaymentState(
      List<Diver> diver, int index, List<Reservation> reservation) {
    this.diver = diver;
    this.index = index;
    this.reservation = reservation;
  }
  final MenuController _controller = Get.put(MenuController());
  getPaymentDetail() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = PaymentServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var paymentrequest = GetPaymentByReservationRequest();
    paymentrequest.reservationId = reservation[index].id;
    payment = await stub.getPaymentByReservation(paymentrequest);
    // print(payment);
    paymentDetial = payment;
    // print(paymentDetial.payment.paymentSlip.link.toString());
    return paymentDetial;
  }

  updatePayment() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = PaymentServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));

    var diverInfo = Diver();
    diverInfo.id = diver[index].id;
    var paymentStatus = Payment()..diver = diverInfo;
    paymentStatus.id=paymentDetial.payment.id;
    paymentStatus.verified = isChecked;
    paymentStatus.paymentSlip=paymentDetial.payment.paymentSlip;
    paymentStatus.reservationId = reservation[index].id;

    var statusrequest = UpdatePaymentStatusRequest()..payment = paymentStatus;
    try {
      var response = stub.updatePaymentStatus(statusrequest);

      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }

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
                SingleChildScrollView(
                   scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'List of divers',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          // Text(
                          //   'Payment',
                          //   style: TextStyle(fontSize: 20),
                          // ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              SizedBox(
                                child: FutureBuilder(
                                  future: getPaymentDetail(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Center(
                                          child:
                                              paymentDetial.payment.paymentSlip ==
                                                      null
                                                  ? new Container(
                                                      color: Colors.pink,
                                                    )
                                                  : Container(
                                                      width: 300,
                                                      height: 300,
                                                      child: Image.network(
                                                          paymentDetial.payment
                                                              .paymentSlip.link
                                                              .toString()),
                                                    ));
                                    } else {
                                      return Align(
                                          alignment: Alignment.center,
                                          child: Text('No slip'));
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Checkbox(
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith(getColor),
                                value: isChecked,
                                onChanged: (bool value) {
                                  setState(() {
                                    // print('bf');
                                    isChecked = value;
                                    // print(isChecked);
                                    // print('af');
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  onPressed: () async => {
                    await updatePayment(),
                    print('checking done'),
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
              ],
            ),
          ),
        ));
  }
}
