import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:flutter/material.dart';

class amenityForm extends StatefulWidget {
  String count;
  List<Amenity> blueValue;
  amenityForm(String count, List<Amenity> blueValue){
    this.count=count;
    this.blueValue=blueValue;
  }
  @override
  _amenityFormState createState() => _amenityFormState(this.count,this.blueValue);
}

class _amenityFormState extends State<amenityForm> {
  String amenity_name;
  String amenity_descption;
  String count;
  List<Amenity> blueValue;
  _amenityFormState(String count, List<Amenity> blueValue){
    this.count=count;
    this.blueValue=blueValue;
  }

  final List<String> errors = [];
  final TextEditingController _controllerAmenityName = TextEditingController();
  final TextEditingController _controllerAmenityDescription = TextEditingController();

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
        child: Column(
          children: [
          SizedBox(height: 20),
          buildAmenityNameFormField(),
          SizedBox(height: 20),
          buildAmenityDescriptionFormField(),
          SizedBox(height: 20),

        ]),
      ),
    );
  }
  TextFormField buildAmenityNameFormField() {
    return TextFormField(
      controller: _controllerAmenityName,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => amenity_name = newValue,
      onChanged: (value) {
        print(' amenity name start');
        print(count);
        print(' amnity name end');
        blueValue[int.parse(count)-1].name=value;
        print(value);
        print("===");
        if (value.isNotEmpty) {
          removeError(error: "Please enter amenity name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter amenity name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Amenity name",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAmenityDescriptionFormField() {
    return TextFormField(
      controller: _controllerAmenityDescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => amenity_descption = newValue,
      onChanged: (value) {
         print(' amenity desc start');
        print(count);
        print(' amnity desc end');
        blueValue[int.parse(count)-1].description=value;
        print(value);
        print("===");
        if (value.isNotEmpty) {
          removeError(error: "Please enter amenity description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter amenity description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Amenity description",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

}


class AddMoreAmenity extends StatefulWidget {
   List<Amenity> blueValue = [];
     AddMoreAmenity( List<Amenity> blueValue) {
    this.blueValue = blueValue;
  }
  @override
  _AddMoreAmenityState createState() => _AddMoreAmenityState(this.blueValue);
}

class _AddMoreAmenityState extends State<AddMoreAmenity> {
  int count = 1;
   List<Amenity> blueValue = [];
    _AddMoreAmenityState(List<Amenity> blueValue) {

    this.blueValue=blueValue;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            shrinkWrap: true,
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return amenityForm(count.toString(),this.blueValue);
            }),
        MaterialButton(
          onPressed: () {
            setState(() {
              count += 1;
               blueValue.add(new Amenity());
            });
          },
          color: Color(0xfff8fcaca),
          textColor: Colors.white,
          child: Icon(
            Icons.add,
            size: 20,
          ),
        ),
         SizedBox(height: 30),
      ])),
    );
  }
}
