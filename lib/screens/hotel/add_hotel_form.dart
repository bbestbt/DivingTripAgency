import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/screens/hotel/addRoom.dart';
import 'package:diving_trip_agency/screens/signup/diver/levelDropdown.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

class addHotel extends StatefulWidget {
  @override
  _addHotelState createState() => _addHotelState();
}

class _addHotelState extends State<addHotel> {
  String hotel_name;
  String highlight;
  String hotel_description;
  String phone;

  List<DropdownMenuItem<String>> listStar = [];
  List<String> star = ['1', '2', '3', '4', '5'];
  String starSelected = null;

  final List<String> errors = [];
  final TextEditingController _controllerHotelname = TextEditingController();
  final TextEditingController _controllerHoteldescription =
      TextEditingController();
  final TextEditingController _controllerHighlight = TextEditingController();

  final TextEditingController _controllerPhone = TextEditingController();

  

  void loadData() {
    listStar = [];
    listStar = star
        .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
        .toList();
  }

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

  void sendHotel() {
    print("before try catch");
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);

    final stub = AgencyServiceClient(channel);
    var hotel = Hotel();
    hotel.hotelName = _controllerHotelname.text;
    hotel.hotelDescription = _controllerHoteldescription.text;
    hotel.phone = _controllerPhone.text;
    hotel.star = int.parse(starSelected);
    //img -> wait ns
    //highlight??
    
    //  var room = Room();
    // //img ns
    // //amen(list)

    // room.price = double.parse(_controllerPrice.text);
    // room.maxCapacity = int.parse(_controllerMax.text);
    // room.description = _controllerRoomdescription.text;

    // var RoomTypeSelected;
    // Room_RoomType.values.forEach((roomType) {
    //   if (roomType.toString() == selected) {
    //     RoomTypeSelected = roomType;
    //   }
    // });
    // room.roomType = RoomTypeSelected;

    var hotelRequest = AddHotelRequest();
    hotelRequest.hotel = hotel;

    try {
      var response = stub.addHotel(hotelRequest);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildHotelNameFormField(),
          SizedBox(height: 20),
          buildHotelDescriptionFormField(),
          SizedBox(height: 20),
          buildPhoneFormField(),
          SizedBox(height: 20),
          Text('Hotel Image'),
          SizedBox(height: 20),
          Container(
            color: Colors.white,
            child: Center(
              child: DropdownButton(
                isExpanded: true,
                value: starSelected,
                items: listStar,
                hint: Text('  Select star'),
                iconSize: 40,
                onChanged: (value) {
                  starSelected = value;
                  setState(() {
                    starSelected = value;
                    print(value);
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          buildHighlightFormField(),
          SizedBox(height: 20),
          Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                     decoration: BoxDecoration(
                          color: Color(0xfffffc6bf),
                          borderRadius: BorderRadius.circular(10)),
                    child: AddMoreRoom(),
                   
                  ), SizedBox(height: 30),
          FlatButton(
            onPressed: () => {},
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

  TextFormField buildHotelNameFormField() {
    return TextFormField(
      controller: _controllerHotelname,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => hotel_name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter hotel name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter hotel name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Hotel name",
        filled: true,
        //fillColor: Color(0xFFFd0efff),
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildHotelDescriptionFormField() {
    return TextFormField(
      controller: _controllerHoteldescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => hotel_description = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter hotel description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter hotel description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Hotel description",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildHighlightFormField() {
    return TextFormField(
      controller: _controllerHighlight,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => highlight = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter highlight");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter highlight");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Highlight",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPhoneFormField() {
    return TextFormField(
      controller: _controllerPhone,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => phone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter phone");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter phone");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Phone",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
