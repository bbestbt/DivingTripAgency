import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:flutter/material.dart';

class amenityForm extends StatefulWidget {
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;

  amenityForm(int blue,int pinkcount, List<List<Amenity>> blueValue){
    this.bluecount=blue;
    this.pinkcount=pinkcount;
    this.blueValue=blueValue;
  }
  @override
  _amenityFormState createState() => _amenityFormState(this.bluecount,this.pinkcount,this.blueValue);
}

class _amenityFormState extends State<amenityForm> {
  String amenity_name;
  String amenity_descption;
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;
  _amenityFormState(int bluecount, int pinkcount, List<List<Amenity>> blueValue){
    this.bluecount=bluecount;
    this.pinkcount=pinkcount;
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
        print(bluecount);
        print(pinkcount);
        print(' amnity name end');
        blueValue[pinkcount-1][bluecount-1].name=value;
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
        print(bluecount);
        print(pinkcount);
        print(' amnity desc end');
        blueValue[pinkcount-1][bluecount-1].description=value;
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
    List<List<Amenity>> blueValue;
   int pinkcount;
     AddMoreAmenity( int pinkcount, List<List<Amenity>> blueValue) {
       this.pinkcount=pinkcount;
    this.blueValue = blueValue;
  }
  @override
  _AddMoreAmenityState createState() => _AddMoreAmenityState(this.pinkcount,this.blueValue);
}

class _AddMoreAmenityState extends State<AddMoreAmenity> {
  int bluecount = 1;
  int pinkcount;
    List<List<Amenity>> blueValue;
    _AddMoreAmenityState(int pinkcount, List<List<Amenity>> blueValue) {
      this.pinkcount=pinkcount;
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
            itemCount: bluecount,
            itemBuilder: (BuildContext context, int index) {
              return amenityForm(bluecount,pinkcount,this.blueValue);
            }),
        MaterialButton(
          onPressed: () {
            setState(() {
              bluecount += 1;
               blueValue[pinkcount-1].add(new Amenity());
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
