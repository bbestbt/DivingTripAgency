import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
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
  String amenity;
  String max_capa;
  String hotel_description;
  String price;
  String selected = null;
  String phone;
  String room_description;
  List<DropdownMenuItem<String>> listStar = [];
  List<String> star = ['1', '2', '3', '4', '5'];
  String starSelected = null;

  final List<String> errors = [];
  final TextEditingController _controllerHotelname = TextEditingController();
  final TextEditingController _controllerHoteldescription =
      TextEditingController();
  final TextEditingController _controllerHighlight = TextEditingController();
  final TextEditingController _controllerAmenity = TextEditingController();
  final TextEditingController _controllerMax = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerRoomdescription =
      TextEditingController();

  List<DropdownMenuItem<String>> listRoom = [];
  List<Room_RoomType> roomtype = [
    Room_RoomType.SINGLE,
    Room_RoomType.DOUBLE,
    Room_RoomType.TRIPLE,
    Room_RoomType.QUAD,
    Room_RoomType.QUEEN,
    Room_RoomType.KING,
    Room_RoomType.TWIN,
    Room_RoomType.HOLLYWOOD_TWIN_ROOM,
    Room_RoomType.DOUBLE_DOUBLE,
    Room_RoomType.STUDIO,
    Room_RoomType.EXECUTEIVE_SUITE,
    Room_RoomType.MINI_SUITE,
    Room_RoomType.PRESIDENTAL_SUITE,
    Room_RoomType.APARTMENT,
    Room_RoomType.CONNECTING_ROOMS,
    Room_RoomType.MURPHY_ROOM,
    Room_RoomType.DISABLED_ROOM,
    Room_RoomType.CABANA,
    Room_RoomType.ADJOINING_ROOMS,
    Room_RoomType.ADJACENT_ROOMS,
    Room_RoomType.VILLA,
    Room_RoomType.FLOORED_ROOM,
    Room_RoomType.SMOKING_NON_SMOKING,
  ];

  void loadData() {
    // roomtype.forEach((element) {
    //   print(element);
    // });
    listRoom = [];
    listRoom = roomtype
        .map((val) => DropdownMenuItem<String>(
            child: Text(val.toString()), value: val.value.toString()))
        .toList();

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
    hotel.star=int.parse(starSelected);
    //img -> wait ns
    //highlight??
    var room = Room();
    //img ns
    //amen(list)
    room.price = double.parse(_controllerPrice.text);
    room.maxCapacity = int.parse(_controllerMax.text);
    room.description = _controllerRoomdescription.text;

    var RoomTypeSelected;
    Room_RoomType.values.forEach((roomType) {
      if (roomType.toString() == selected) {
        RoomTypeSelected = roomType;
      }
    });
    room.roomType = RoomTypeSelected;
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
          // LevelDropdown(),
          // Text('dropdown star'),
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
            color: Colors.white,
            //color: Color(0xFFFd0efff),
            child: Center(
              child: DropdownButton(
                isExpanded: true,
                value: selected,
                items: listRoom,
                hint: Text('  Select room type'),
                iconSize: 40,
                onChanged: (value) {
                  setState(() {
                    selected = value;
                    print(value);
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          // Text('room dorpdown'),
          // SizedBox(height: 20),
          buildRoomDescriptionFormField(),
          SizedBox(height: 20),
          buildAmenityFormField(),
          SizedBox(height: 20),
          buildMaxCapacityFormField(),
          SizedBox(height: 20),
          Text('Room Image'),
          SizedBox(height: 20),
          buildPriceFormField(),
          SizedBox(height: 20),
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

  TextFormField buildRoomDescriptionFormField() {
    return TextFormField(
      controller: _controllerRoomdescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => room_description = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter room description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter room description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Room description",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPriceFormField() {
    return TextFormField(
      controller: _controllerPrice,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => price = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter price");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter price");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Price",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAmenityFormField() {
    return TextFormField(
      controller: _controllerAmenity,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => amenity = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter amenity");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter amenity");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Amenity",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildMaxCapacityFormField() {
    return TextFormField(
      controller: _controllerMax,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => max_capa = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter max capacity");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter max capacity");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Max capacity",
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
