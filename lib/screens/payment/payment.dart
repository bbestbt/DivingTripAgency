import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/diver.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/payment.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/payment.pbgrpc.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/profile/diver/edit_profile_diver.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;

GetProfileResponse user_profile = new GetProfileResponse();
var profile;
io.File slip;
PickedFile slipPayment;

class PaymentUpload extends StatefulWidget {
  int reservation_id;
  PaymentUpload(int reservation_id) {
    this.reservation_id = reservation_id;
  }
  @override
  _PaymentUploadState createState() => _PaymentUploadState(this.reservation_id);
}

class _PaymentUploadState extends State<PaymentUpload> {
  int reservation_id;
  _PaymentUploadState(this.reservation_id);
  makePayment() async {
    print("before try catch");
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

    var payment = Payment();

    var f = File();
    f.filename = 'Image.jpg';
    List<int> b = await slipPayment.readAsBytes();
    f.file = b;
    payment.paymentSlip = f;
    payment.verified = false;
    payment.reservationId = Int64(reservation_id);

    var makePayament = MakePaymentRequest();
    makePayament.payment = payment;

    try {
      var response = await stub.makePayment(makePayament);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }

  _getSlip() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    if (pickedFile != null) {
      setState(() {
        slip = io.File(pickedFile.path);
        slipPayment = pickedFile;
      });
      print(pickedFile.path.split('/').last);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        // height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(color: Color(0xfffd4f0f7).withOpacity(0.3)),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            SectionTitle(
              title: "Payment",
              color: Color(0xFFFF78a2cc),
            ),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Payment slip'),
                        SizedBox(
                          width: 40,
                        ),
                        FlatButton(
                          color: Color(0xfffa2c8ff),
                          child: Text(
                            'Upload',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            _getSlip();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: slip == null
                          ? Text('')
                          : kIsWeb
                              ? Image.network(
                                  slip.path,
                                  fit: BoxFit.cover,
                                  width: screenwidth * 0.2,
                                )
                              : Image.file(
                                  io.File(slip.path),
                                  fit: BoxFit.cover,
                                  width: screenwidth * 0.05,
                                ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FlatButton(
                      onPressed: () async => {
                        await makePayment(),
                        print('payment done'),
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen(),
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
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}