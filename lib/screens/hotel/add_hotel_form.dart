import 'package:flutter/material.dart';

class addHotel extends StatefulWidget {
  @override
  _addHotelState createState() => _addHotelState();
}

class _addHotelState extends State<addHotel> {
  String hotel_name;
  String star;
  String amenity;
  String max_capa;
  String description;
  String price;
  String selected = null;

  final List<String> errors = [];
  final TextEditingController _controllerHotelname = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerStar = TextEditingController();
  final TextEditingController _controllerAmenity = TextEditingController();
  final TextEditingController _controllerMax = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();

//hotel img, room img

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

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildHotelNameFormField(),
          SizedBox(height: 20),
          buildDescriptionFormField(),
          SizedBox(height: 20),
          Text('Hotel Image'),
          SizedBox(height: 20),
          Text('dorpdown'),
          SizedBox(height: 20),
          buildStarFormField(),
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
      cursorColor: Color(0xFF6F35A5),
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

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      controller: _controllerDescription,
      cursorColor: Color(0xFF6F35A5),
      onSaved: (newValue) => description = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter Description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter Description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Description",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPriceFormField() {
    return TextFormField(
      controller: _controllerPrice,
      cursorColor: Color(0xFF6F35A5),
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
      cursorColor: Color(0xFF6F35A5),
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
      cursorColor: Color(0xFF6F35A5),
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

  TextFormField buildStarFormField() {
    return TextFormField(
      controller: _controllerStar,
      cursorColor: Color(0xFF6F35A5),
      onSaved: (newValue) => star = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter star");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter star");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Star",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}