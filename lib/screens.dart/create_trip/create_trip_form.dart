import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

//trip type layout mobile not work
//pic of trip,boat
//schedule
class CreateTripForm extends StatefulWidget {
  @override
  _CreateTripFormState createState() => _CreateTripFormState();
}

class _CreateTripFormState extends State<CreateTripForm> {
  String tripname;
  String description;
  String place;
  String from;
  String to;
  String divemastername;
  String price;
  String totalpeople;

  String triptype = '';
  final List<String> errors = [];
  final TextEditingController _controllerTripname = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerPlace = TextEditingController();
  final TextEditingController _controllerFrom = TextEditingController();
  final TextEditingController _controllerTo = TextEditingController();
  final TextEditingController _controllerDivemastername =
      TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  final TextEditingController _controllerTotalpeople = TextEditingController();
  String boatname;
  final TextEditingController _controllerBoatname =
      TextEditingController();

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
          buildTripNameFormField(),
          SizedBox(height: 20),
          buildDescriptionFormField(),
          SizedBox(height: 20),
          buildPlaceFormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildFromFormField()),
              // SizedBox(width: 20),
              Spacer(),
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildToFormField()),
            ],
          ),
          SizedBox(height: 20),
          buildDiveMasterNameFormField(),
          SizedBox(height: 20),
          buildBoatNameFormField(),
          SizedBox(height: 20),
          buildPriceFormField(),
          SizedBox(height: 20),
          buildTotalPeopleFormField(),
          SizedBox(height: 20),
          //radio
          Row(
            children: [
              Text('Trip Type '),
              Spacer(),
              Radio(
                  value: 'On shore (Hotel)',
                  groupValue: triptype,
                  onChanged: (val) {
                    triptype = val;
                    setState(() {});
                  }),
              Text('On shore (Hotel)'),
              SizedBox(width: 10,),
              Radio(
                  value: 'Off shore (Live on boat)',
                  groupValue: triptype,
                  onChanged: (val) {
                    triptype = val;
                    setState(() {});
                  }),
              Text('Off shore (Live on boat)'),
            ],
          ),

          // Row(
          //   children: [
          //     Text('Trip Type '),
          //     Row(
          //       children: [
          //         Radio(
          //             value: 'On shore (Hotel)',
          //             groupValue: triptype,
          //             onChanged: (val) {
          //               triptype = val;
          //               setState(() {});
          //             }),
          //         Text('On shore (Hotel)'),
          //       ],
          //     ),
          //   ],
          // ),

          // Row(
          //   children: [
          //     Radio(
          //         value: 'Off shore (Live on boat)',
          //         groupValue: triptype,
          //         onChanged: (val) {
          //           triptype = val;
          //           setState(() {});
          //         }),
          //     Text('Off shore (Live on boat)'),
          //   ],
          // ),

          //   FormError(errors: errors),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  TextFormField buildTripNameFormField() {
    return TextFormField(
      controller: _controllerTripname,
      cursorColor: Color(0xFF6F35A5),
      onSaved: (newValue) => tripname = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter trip name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter trip name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Trip name",
        filled: true,
        fillColor: Color(0xFFFd0efff),
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
          removeError(error: "Please Enter Description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter Description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Description",
        filled: true,
        fillColor: Color(0xFFFd0efff),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPlaceFormField() {
    return TextFormField(
      controller: _controllerPlace,
      cursorColor: Color(0xFF6F35A5),
      onSaved: (newValue) => place = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter place");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter place");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Place",
        filled: true,
        fillColor: Color(0xFFFd0efff),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildFromFormField() {
    return TextFormField(
      controller: _controllerFrom,
      cursorColor: Color(0xFF6F35A5),
      onSaved: (newValue) => from = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "From");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "From");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "From",
        filled: true,
        fillColor: Color(0xFFFd0efff),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildToFormField() {
    return TextFormField(
      controller: _controllerTo,
      cursorColor: Color(0xFF6F35A5),
      onSaved: (newValue) => to = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "To");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "To");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "To",
        filled: true,
        fillColor: Color(0xFFFd0efff),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildDiveMasterNameFormField() {
    return TextFormField(
      controller: _controllerDivemastername,
      cursorColor: Color(0xFF6F35A5),
      onSaved: (newValue) => divemastername = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter dive master name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter dive master name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Dive master name",
        filled: true,
        fillColor: Color(0xFFFd0efff),
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
          removeError(error: "Please Enter price");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter price");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Price",
        filled: true,
        fillColor: Color(0xFFFd0efff),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildTotalPeopleFormField() {
    return TextFormField(
      controller: _controllerTotalpeople,
      cursorColor: Color(0xFF6F35A5),
      onSaved: (newValue) => totalpeople = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter total people");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter total people");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Total people",
        filled: true,
        fillColor: Color(0xFFFd0efff),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildBoatNameFormField() {
    return TextFormField(
      controller: _controllerBoatname,
      cursorColor: Color(0xFF6F35A5),
      onSaved: (newValue) => boatname = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please Enter boat name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter boatr name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Boat name",
        filled: true,
        fillColor: Color(0xFFFd0efff),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

}
