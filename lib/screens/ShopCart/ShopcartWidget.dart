import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pbgrpc.dart';
import 'package:diving_trip_agency/screens/detail/trip_detail(bak).dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/profile/diver/edit_profile_diver.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../nautilus/proto/dart/model.pb.dart';

var cartwid = null;
List Cartlist = [];

List<RoomType> roomtypes;
String roomtypestr;
List<TripWithTemplate> details;
String detailJSON;
int clength;
int indexRoom;
int indexDetail;
int quantity;
int diver;
int totalprice;
String usertoken;
GetProfileResponse user_profile = new GetProfileResponse();
var profile;
final CartBox = Hive.box('CartBox');
int Checked = 0;

class CartWidget extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartWidget> {
  @override
  void initState() {
    totalprice = 0;
    // print("Cartbox at init");
    //print("-------");
    //print(CartBox.toMap());
    clength = Cartlist.length;
    for (int i = 0; i < Cartlist.length; i++) {
      totalprice += Cartlist[i][4];
      String roomimage = Cartlist[i][0];
      String tripname = Cartlist[i][1];
      roomtypestr = Cartlist[i][6];

      detailJSON = Cartlist[i][5];
      //detailJSON = jsonEncode((Cartlist[i][5]
      //as List<TripWithTemplate>).map((e) => e.toProto3Json()).toList());
      indexRoom = Cartlist[i][7];
      indexDetail = Cartlist[i][12];
      quantity = Cartlist[i][9];
      diver = Cartlist[i][10];
      // print("Cartlist Everything");
      // print("--------");
      //print(Cartlist);
      /*print("Room Types");
      print("----------");
      print(Cartlist[i][3]);
      print("hotel name");
      print("------------");
      print(Cartlist[i][2]);
      print("RoomtypeStr");
      print("--------------");
      print(roomtypestr);*/
      //print("Details Trip");
      //print("----------");
      //print(details);
      print("RoomtypeID");
      print("---------------------");
      print(Cartlist[i][11]);
      print("TripID");
      print("---------");
      print(Cartlist[i][12]);
      print("Username");
      print("------");
      print(Cartlist[i][13]);

      persCarthive(i);
    }
    if (Cartlist.length == 0) {
      populateCartlist();
    }

    super.initState();
  }

  void populateCartlist() {
    int i;
    bool checked = false;
    final box = Hive.box('userInfo');
    if (CartBox.get('clength') != null) {
      for (i = 0; i < CartBox.get('clength'); i++) {
        //if(checked==false && CartBox.get("usertoken"+i.toString())==token) {
        if (checked == false &&
            CartBox.get("username" + i.toString()) == box.get("username")) {
          Cartlist.add([
            CartBox.get('image' + i.toString()), //0
            CartBox.get('tripname' + i.toString()), //1
            //"Tripname",
            CartBox.get('hotelname' + i.toString()), //2
            CartBox.get('roomtype' + i.toString()), //3
            CartBox.get('price' + i.toString()) *
                CartBox.get("quantity" + i.toString()), //4
            //tripname[0]['tripdetail'],
            "TripName", //5
            "roomname", //6
            0, //7
            CartBox.get("indexDetail"), //8
            CartBox.get("quantity" + i.toString()), //9
            CartBox.get("diver" + i.toString()), //10
            CartBox.get("roomid" + i.toString()), //11
            CartBox.get("tripid" + i.toString()), //12
            CartBox.get("username" + i.toString()) //13
            //CartBox.get('roomtype'),
          ]);
          totalprice += CartBox.get('price' + i.toString()) *
              CartBox.get("quantity" + i.toString());
        }
      }
    }
    checked = true;
  }

  deleteItem(int id) {
    int clengthtemp = 0;
    var templist = [];
    if (id < clengthtemp - 1) {
      var pricetemp = CartBox.get('price' + (id + 1).toString()) *
          CartBox.get("quantity" + (id + 1).toString());
      templist.add([
        CartBox.get('image' + (id + 1).toString()),
        CartBox.get('tripname' + (id + 1).toString()),
        CartBox.get('hotelname' + (id + 1).toString()), //2
        CartBox.get('roomtype' + (id + 1).toString()), //3
        pricetemp, //4
        //tripname[0]['tripdetail'],
        "TripName", //5
        "roomname", //6
        0, //7
        CartBox.get("indexDetail"), //8
        CartBox.get("quantity" + (id + 1).toString()), //9
        CartBox.get("diver" + (id + 1).toString()), //10
        CartBox.get("roomid" + (id + 1).toString()), //11
        CartBox.get("tripid" + (id + 1).toString()), //12
        CartBox.get("username" + (id + 1).toString()), //13
      ]);
      CartBox.delete('Roomlist' + (id + 1).toString());
      CartBox.delete('diver' + (id + 1).toString());
      CartBox.delete('image' + (id + 1).toString());
      CartBox.delete('indexDetail' + (id + 1).toString());
      CartBox.delete('indexroom' + (id + 1).toString());
      CartBox.delete('price' + (id + 1).toString());
      CartBox.delete('quantity' + (id + 1).toString());
      CartBox.delete('roomid' + (id + 1).toString());
      CartBox.delete('roomtype' + (id + 1).toString());
      CartBox.delete('tripdetail' + (id + 1).toString());
      CartBox.delete('tripid' + (id + 1).toString());
      sortCart(id, templist);
    }
    CartBox.delete('Roomlist' + id.toString());
    CartBox.delete('diver' + id.toString());
    CartBox.delete('image' + id.toString());
    CartBox.delete('indexDetail' + id.toString());
    CartBox.delete('indexroom' + id.toString());
    CartBox.delete('price' + id.toString());
    CartBox.delete('quantity' + id.toString());
    CartBox.delete('roomid' + id.toString());
    CartBox.delete('roomtype' + id.toString());
    CartBox.delete('tripdetail' + id.toString());
    CartBox.delete('tripid' + id.toString());
    CartBox.delete('tripname' + id.toString());

    clengthtemp = CartBox.get("clength");
    print("---clengthtemp---");
    print(clengthtemp);

    clengthtemp = clengthtemp - 1;
    CartBox.delete('clength');
    CartBox.put('clength', clengthtemp);
  }

  void sortCart(int cartind, List templist) async {
    //Test Hive
    print("--templist--");
    print(templist[cartind][1]);
    CartBox.put('image' + cartind.toString(), templist[cartind][0]);
    CartBox.put('tripname' + cartind.toString(), templist[cartind][1]);
    CartBox.put('clength', clength);
    CartBox.put('hotelname' + cartind.toString(), templist[cartind][2]);
    CartBox.put('roomtype' + cartind.toString(), templist[cartind][3]);
    CartBox.put('price' + cartind.toString(), templist[cartind][4]);
    CartBox.put('tripdetail' + cartind.toString(), templist[cartind][5]);
    CartBox.put('Roomlist' + cartind.toString(), templist[cartind][6]);

    CartBox.put('indexroom' + cartind.toString(), templist[cartind][7]);
    CartBox.put('indexDetail' + cartind.toString(), templist[cartind][12]);
    CartBox.put('quantity' + cartind.toString(), templist[cartind][9]);
    CartBox.put('diver' + cartind.toString(), templist[cartind][10]);

    CartBox.put('roomid' + cartind.toString(), templist[cartind][11]);
    CartBox.put('tripid' + cartind.toString(), templist[cartind][12]);
    CartBox.put('username' + cartind.toString(), templist[cartind][13]);
  }

  void persCarthive(int cartind) async {
    //Test Hive

    CartBox.put('image' + cartind.toString(), Cartlist[cartind][0]);
    CartBox.put('tripname' + cartind.toString(), Cartlist[cartind][1]);
    CartBox.put('clength', clength);
    CartBox.put('hotelname' + cartind.toString(), Cartlist[cartind][2]);
    CartBox.put('roomtype' + cartind.toString(), Cartlist[cartind][3]);
    CartBox.put('price' + cartind.toString(), Cartlist[cartind][4]);
    CartBox.put('tripdetail' + cartind.toString(), Cartlist[cartind][5]);
    CartBox.put('Roomlist' + cartind.toString(), Cartlist[cartind][6]);

    CartBox.put('indexroom' + cartind.toString(), Cartlist[cartind][7]);
    CartBox.put('indexDetail' + cartind.toString(), Cartlist[cartind][12]);
    CartBox.put('quantity' + cartind.toString(), Cartlist[cartind][9]);
    CartBox.put('diver' + cartind.toString(), Cartlist[cartind][10]);

    CartBox.put('roomid' + cartind.toString(), Cartlist[cartind][11]);
    CartBox.put('tripid' + cartind.toString(), Cartlist[cartind][12]);
    CartBox.put('username' + cartind.toString(), Cartlist[cartind][13]);

    //var jsondetails = jsonEncode((Cartlist[cartind][5]
    //as List<TripWithTemplate>).map((e) => e.toProto3Json()).toList());
    //print("-------------------");
    //print(CartBox.get('tripdetail'));
    //print("Current Cartbox");
    //print("-------------------");
    // print(CartBox.toMap());
  }

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

    user_profile = profile;
    return user_profile;
  }

  void bookTrips() async {
    await getProfile();
    print('length' + Cartlist.length.toString());
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = ReservationServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var reservation;

    var room = Reservation_Room();
    for (int i = 0; i < CartBox.get('clength'); i++) {
      // print(CartBox.get('quantity' + i.toString()));
      room.quantity = CartBox.get('quantity' + i.toString());
      room.roomTypeId = Int64(CartBox.get('roomid' + i.toString()));
      room.noDivers = CartBox.get('diver' + i.toString());

      reservation = Reservation()..rooms.add(room);
      //reservation.tripId = details[indexDetail].id;
      //  print("CartBox get diverID");
      // print(CartBox.get('diver'+i.toString()));
      // print(CartBox.get('tripid'+i.toString()));
      // print(totalprice);
      reservation.tripId = Int64(CartBox.get('tripid' + i.toString()));

      reservation.diverId = user_profile.diver.id;

      /*reservation.price =
        (roomtypes[indexRoom].price * quantity) + details[indexDetail].price;*/
      //reservation.price = 1000;//CartBox.get('price'+CartBox.get('indexroom').toString()).toInt()*CartBox.get('quantity'+CartBox.get('indexDetail').toString()).toInt();
      reservation.price = totalprice;
      reservation.totalDivers = Int64(0);

      // print(reservation);
      var bookRequest = CreateReservationRequest()..reservation = reservation;
     try {
        var response = await stub.createReservation(bookRequest);
        print('ok');
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Booking"),
                content: Text("done"),
                actions: <Widget>[
                  // FlatButton(
                  //   child: Text("OK"),
                  // ),
                ],
              );
            });
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainScreen()));
        print('response: ${response}');
      } on GrpcError catch (e) {
        print('codeName: ${e.codeName}');
        print('details: ${e.details}');
        print('message: ${e.message}');
        print('rawResponse: ${e.rawResponse}');
        print('trailers: ${e.trailers}');
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        //width: 800,
        width: MediaQuery.of(context).size.width * 0.7,
        margin: EdgeInsets.all(20),
        child: Column(children: [
          SectionTitle(
            title: "Trips in cart",
            color: Color(0xFFFF78a2cc),
          ),
          // Text("Total Cost: "),
          //Text(totalprice.toString()),
          /*TextButton(
            child: Text(
              "Check JSON",
              // style: TextStyle(fontSize: 25),
            ),
            onPressed: () {
              setState(() {
                print("Checked");
                populateCartlist();
                //persCarthive(position);
                //persCart(position);
              });
            },
            style: TextButton.styleFrom(
                primary: Colors.red,
                elevation: 2,
                backgroundColor: Colors.amber),
          ),
          SizedBox(height: 40),
          TextButton(
            child: Text(
              "Get User Profile",
              // style: TextStyle(fontSize: 25),
            ),
            onPressed: () {
              setState(() {
        //        print("Profile here!");
                //var testprof = getProfile();
                //print(testprof);
                final box = Hive.box('userInfo');
                print(box.get('username'));
                //persCarthive(position);
                //persCart(position);
              });
            },
            style: TextButton.styleFrom(
                primary: Colors.red,
                elevation: 2,
                backgroundColor: Colors.amber),
          ),*/
          SizedBox(height: 40),
          ListView.builder(
            itemCount: Cartlist.length,
            shrinkWrap: true,
            itemBuilder: (context, position) {
              return Card(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Wrap(direction: Axis.horizontal,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width / 15,
                                  height:
                                      MediaQuery.of(context).size.width / 15,
                                  child: Image.network(Cartlist[position][0])),

                              // Flexible(
                              //     child: Container(
                              //   child: Image(
                              //       image: NetworkImage(
                              //          Cartlist[position][0])),
                              // )),
                              SizedBox(width: 30),
                              Wrap(direction: Axis.vertical,
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Trip Name: " +
                                          Cartlist[position][1].toString(),
                                      // style: TextStyle(fontSize: 22.0),
                                    ),
                                    Text(
                                      "Residence Name: " +
                                          Cartlist[position][2].toString(),
                                      // style: TextStyle(fontSize: 22.0),
                                    ),
                                    Text(
                                      "Room Name: " +
                                          Cartlist[position][3].toString(),
                                      // style: TextStyle(fontSize: 22.0),
                                    ),
                                    Text(
                                      "Total price: " +
                                          Cartlist[position][4].toString(),
                                      // style: TextStyle(fontSize: 22.0),
                                    ),
                                  ]),
                              SizedBox(width: 30),
                              /*TextButton(
                            child: Text(
                              "Edit",
                              style: TextStyle(fontSize: 25),
                            ),
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                primary: Colors.red,
                                elevation: 2,
                                backgroundColor: Colors.amber),
                          ),*/

                              SizedBox(width: 30),
                              TextButton(
                                child: Text(
                                  "Remove",
                                  // style: TextStyle(fontSize: 25),
                                ),
                                onPressed: () {
                                  setState(() {
                                    print("deleted");
                                    deleteItem(position);
                                    Cartlist.removeAt(position);
                                    print("----cartlist------");
                                    print(Cartlist);
                                    totalprice;
                                  });
                                },
                                style: TextButton.styleFrom(
                                    primary: Colors.red,
                                    elevation: 2,
                                    backgroundColor: Colors.amber),
                              ),
                            ]),
                      )));
            },
          ),
          SizedBox(height: 30),
          Cartlist.length != 0
              ? TextButton(
                  child: Text(
                    "Clear cart",
                    // style: TextStyle(fontSize: 25),
                  ),
                  onPressed: () {
                    setState(() {
                      CartBox.clear();
                      Cartlist = [];
                      print("cleared");
                    });
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      elevation: 2,
                      backgroundColor: Colors.indigo),
                )
              : SizedBox(height: 30),
          SizedBox(height: 30),
          Cartlist.length != 0
              ? TextButton(
                  child: Text(
                    "Book",
                    // style: TextStyle(fontSize: 25),
                  ),
                  onPressed: () async {
                    await bookTrips();
                    // showDialog(
                    //     context: context,
                    //     builder: (BuildContext context) {
                    //       return AlertDialog(
                    //         title: Text("Booking"),
                    //         content: Text("done"),
                    //         actions: <Widget>[
                    //           // FlatButton(
                    //           //   child: Text("OK"),
                    //           // ),
                    //         ],
                    //       );
                    //     });
                    //print(Cartlist);
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      elevation: 2,
                      backgroundColor: Colors.indigo),
                )
              : Text('No Trip in cart'),
          SizedBox(height: 30),
        ]));

    /*Container(
      color: const Color(0xFFFFE306),
      child: Column(
        children:[
          Text("Shopping Cart"),
        ]
      )
    );*/
  }
}
