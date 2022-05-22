import 'dart:io' as io;
import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:diving_trip_agency/screens/signup/company/signup_divemaster.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../nautilus/proto/dart/model.pb.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

GetProfileResponse user_profile = new GetProfileResponse();
var profile;
final TextEditingController _controllerName =
    TextEditingController(text: user_profile.diver.firstName);
final TextEditingController _controllerLastname =
    TextEditingController(text: user_profile.diver.lastName);
final TextEditingController _controllerUsername =
    TextEditingController(text: user_profile.diver.account.username);
final TextEditingController _controllerPassword = TextEditingController();
final TextEditingController _controllerOldPassword = TextEditingController();
final TextEditingController _controllerEmail =
    TextEditingController(text: user_profile.diver.account.email);
final TextEditingController _controllerPhone =
    TextEditingController(text: user_profile.diver.phone);

class EditDiverForm extends StatefulWidget {
  @override
  _EditDiverFormState createState() => _EditDiverFormState();
}

class _EditDiverFormState extends State<EditDiverForm> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  String username;
  String name;
  String lastname;
  // String level;
  String phoneNumber;
  String email;
  String password;
  String oldpassword;
  final List<String> errors = [];

  io.File DiverImage;
  io.File DiveBack;
  DateTime _dateTime;
  String selected = null;
  String DivFimagename = null;
  Map<String, int> levelTypeMap = {};

  XFile divfront;
  XFile card;

  List<DropdownMenuItem<String>> listDrop = [];
  List<LevelType> drop = [
    LevelType.MASTER,
    LevelType.OPEN_WATER,
    LevelType.RESCUE,
    LevelType.INSTRUCTOR,
    LevelType.ADVANCED_OPEN_WATER
  ];

  getData() async {
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
    // print(profile);
    user_profile = profile;
    print(user_profile.diver.level.toString());
    return user_profile;
  }

  void loadData() async {
    drop.forEach((element) {
      // print(element);
    });
    //listDrop = [];
    listDrop = drop
        .map((val) => DropdownMenuItem<String>(
            child: Text(val.toString()), value: val.value.toString()))
        .toList();

    String value;

    for (var i = 0; i < LevelType.values.length; i++) {
      value = LevelType.valueOf(i).toString();
      levelTypeMap[value] = i;
    }

    // print("LevelType-----------------");
    // print(levelTypeMap);
  }

  /// Get from gallery
  _getPicDiver() async {
    divfront = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    if (divfront != null) {
      setState(() {
        DiverImage = io.File(divfront.path);
        //divfront = pickedFile;
      });
      //print(pickedFile.path.split('/').last);
    }
  }

  /// Get from gallery
  _getPicCard() async {
    card = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (card != null) {
      setState(() {
        DiveBack = io.File(card.path);
        //card = pickedFile;
      });
    }
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

  void sendDiverEdit() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');
    final stub = AccountClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));

    user_profile.diver.account.username = _controllerUsername.text;
    user_profile.diver.account.email = _controllerEmail.text;
    user_profile.diver.account.password = _controllerPassword.text;
    // var diver = Diver();
    user_profile.diver.firstName = _controllerName.text;
    user_profile.diver.lastName = _controllerLastname.text;
    user_profile.diver.phone = _controllerPhone.text;
    // diver.account = account;
    if (_dateTime != null) {
      user_profile.diver.birthDate = Timestamp.fromDateTime(_dateTime);
    }

    //var t = await imageFile.readAsBytes();
    //f.file = new List<int>.from(t);
    if (divfront != null) {
      var f = File();
      f.filename = divfront.name;
      List<int> a = await divfront.readAsBytes();
      f.file = a;
      if (user_profile.diver.documents.length > 1) {
        user_profile.diver.documents.removeAt(0);
      }
      user_profile.diver.documents.insert(0, f);
    } else if (divfront == null) {
      var f = File();
      f.filename = user_profile.diver.documents[0].filename;
      print("--firstpic--");
      print(user_profile.diver.documents[0].filename);
    }

    if (card != null) {
      var f2 = File();
      f2.filename = card.name;
      List<int> b = await card.readAsBytes();
      f2.file = b;
      if (user_profile.diver.documents.length > 1) {
        user_profile.diver.documents.removeAt(1);
      }
      user_profile.diver.documents.insert(1, f2);
    } else if (card == null) {
      var f2 = File();
      f2.filename = user_profile.diver.documents[1].filename;
      print("--secondpic--");
      print(user_profile.diver.documents[1].filename);
    }

    if (selected != null) {
      LevelType.values.forEach((levelType) {
        if (levelTypeMap[levelType.toString()] == int.parse(selected)) {
          user_profile.diver.level = levelType;
        }
      });
    }
    var account = Account();
    account.username = user_profile.diver.account.username;
    account.password = _controllerPassword.text;
    account.oldPassword = _controllerOldPassword.text;
    account.email = user_profile.diver.account.email;

    var accountUpdateRequest = UpdateAccountRequest()..account = account;

    var diver = Diver();
    diver.birthDate = user_profile.diver.birthDate;
    diver.level = user_profile.diver.level;
    diver.phone = user_profile.diver.phone;
    diver.firstName = user_profile.diver.firstName;
    diver.lastName = user_profile.diver.lastName;
    print("--userprofile.diver.doc.length---");
    print(user_profile.diver.documents.length);
    // print("-userprofilt.diver.doc--");
    //print(user_profile.diver.documents);

    for (int i = 0; i < user_profile.diver.documents.length; i++) {
      diver.documents.add(user_profile.diver.documents[i]);
    }
    print("--diver.doc.length---");
    print(user_profile.diver.documents.length);
    print("-diver.doc--");
    print(user_profile.diver.documents);
    final updateRequest = UpdateRequest()..diver = diver;

    try {
      var response = await stub.update(updateRequest);
      var response2 = await stub.updateAccount(accountUpdateRequest);
      print('response: ${response}');
      // print('ddd');
      print('response: ${response2}');
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainScreen()));
    } on GrpcError catch (e) {
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

  @override
  Widget build(BuildContext context) {
    loadData();
    double screenwidth = MediaQuery.of(context).size.width;
    return SizedBox(
      child: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  SizedBox(height: 20),
                  buildUsernameFormField(),
                  SizedBox(height: 20),
                  buildNameFormField(),
                  SizedBox(height: 20),
                  buildLastnameFormField(),
                  SizedBox(height: 20),
                  // LevelDropdown(),
                  Container(
                    color: Colors.white,
                    //color: Color(0xFFFd0efff),
                    child: Center(
                      child: DropdownButton(
                        isExpanded: true,
                        value: selected,
                        items: listDrop,
                        hint: Text(user_profile.diver.level.toString()),
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
                  buildEmailFormField(),
                  SizedBox(height: 20),
                  buildPhoneNumberFormField(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Birthday'),
                      Spacer(),
                      Text(_dateTime == null
                          ? DateFormat("dd/MM/yyyy")
                              .format(user_profile.diver.birthDate.toDateTime())
                          : DateFormat("dd/MM/yyyy").format(_dateTime)),
                      Spacer(),
                      RaisedButton(
                          color: Color(0xfff8dd9cc),
                          child: Text('Pick a date'),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now())
                                .then((date) => {
                                      setState(() {
                                        var timeStamp =
                                            print(Timestamp.fromDateTime(date));
                                        _dateTime = date;
                                      })
                                    });
                          }),
                    ],
                  ),
                  SizedBox(height: 20),
                  buildoldpasswordFormField(),
                  SizedBox(height: 20),
                  buildPasswordFormField(),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Text('Front Image'),
                      SizedBox(width: 30),
                      Container(
                          width: MediaQuery.of(context).size.width / 10,
                          height: MediaQuery.of(context).size.width / 10,
                          child: user_profile.diver.documents.length < 1
                              ? new Container(
                                  child: Center(child: Text('No image')),
                                )
                              : Image.network(
                                  // 'http://139.59.101.136/static/'+
                                  user_profile.diver.documents[0].link
                                      .toString())),
                      Center(
                          child: DiverImage == null
                              ? Column(
                                  children: [Text('')],
                                )
                              : kIsWeb
                                  ? Image.network(
                                      DiverImage.path,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                    )
                                  : Image.file(
                                      io.File(DiverImage.path),
                                      fit: BoxFit.cover,
                                      width: screenwidth * 0.05,
                                    )),
                      /* Spacer(),
              DiverImage == null
                  ? Text('')
                  :
                  print(DiverImage.path)
              ,*/
                      Spacer(),
                      FlatButton(
                        color: Color(0xfffa2c8ff),
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          _getPicDiver();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  Row(
                    children: [
                      Text('Back image'),
                      SizedBox(width: 30),
                      Container(
                          width: MediaQuery.of(context).size.width / 10,
                          height: MediaQuery.of(context).size.width / 10,
                          child: user_profile.diver.documents.length < 2
                              ? new Container(
                                  child: Center(child: Text('No image')),
                                )
                              : Image.network(
                                  // 'http://139.59.101.136/static/'+
                                  // 'http:/139.59.101.136/static/1bb37ca5171345af86ff2e052bdf7dee.jpg'
                                  user_profile.diver.documents[1].link
                                      .toString())),
                      Center(
                          child: DiveBack == null
                              ? Column(
                                  children: [Text('')],
                                )
                              : kIsWeb
                                  ? Image.network(
                                      DiveBack.path,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                    )
                                  : Image.file(
                                      io.File(DiveBack.path),
                                      fit: BoxFit.cover,
                                      width: screenwidth * 0.05,
                                    )),
                      Spacer(),
                      FlatButton(
                        color: Color(0xfffa2c8ff),
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          _getPicCard();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  FormError(errors: errors),
                  SizedBox(height: 20),
                  FlatButton(
                    onPressed: () async => {
                      // if (_dateTime == null)
                      //   {
                      //     setState(() {
                      //       _dateTime =
                      //           user_profile.diver.birthDate.toDateTime();
                      //     })
                      //   }
                      // else if (selected == null)
                      //   {
                      //     setState(() {
                      //       selected = (levelTypeMap[
                      //               user_profile.diver.level.toString()])
                      //           .toString();
                      //     })
                      //   },
                      await sendDiverEdit(),
                    },
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
          } else {
            return Text('User is not logged in.');
          }
        },
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFFf5579c6),
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter name");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter name");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
          hintText: user_profile.diver.firstName,
          labelText: "First Name",
          filled: true,
          // fillColor: Color(0xFFFd0efff),,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildLastnameFormField() {
    return TextFormField(
      controller: _controllerLastname,
      cursorColor: Color(0xFFf5579c6),
      keyboardType: TextInputType.name,
      onSaved: (newValue) => lastname = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter lastname");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter lastname");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
          hintText: user_profile.diver.lastName,
          labelText: "Last Name",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildUsernameFormField() {
    return TextFormField(
      controller: _controllerUsername,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => username = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter username");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter username");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
          hintText: user_profile.diver.account.username,
          labelText: "Username",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildoldpasswordFormField() {
    return TextFormField(
      controller: _controllerOldPassword,
      obscureText: _isObscure,
      onSaved: (newValue) => oldpassword = newValue,
      // onChanged: (value) {
      // if (password == oldpassword) {
      //   // removeError(error: "Password doesn't match");
      // }
      // return null;
      // },
      // validator: (value) {
      // if (value.isEmpty) {
      //   return "";
      // } else if (password != value) {
      //   // addError(error: "Password doesn't match");
      //   // return "";
      // }
      // return null;
      // },
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Old password",
          //   hintText: "Confirm password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              })),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _controllerPassword,
      obscureText: _isObscure,
      onSaved: (newValue) => password = newValue,
      // onChanged: (value) {
      // if (value.isNotEmpty) {
      //   removeError(error: "Please enter password");
      // } else if (value.length >= 8) {
      //   removeError(error: "Password is too short");
      // } else if (RegExp(
      //         r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
      //     .hasMatch(value)) {
      //   removeError(error: "Please enter valid Password");
      // }
      // password = value;
      // return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter password");
      //     return "";
      //   } else if (value.length < 8) {
      //     addError(error: "Password is too short");
      //     return "";
      //   } else if (!(RegExp(
      //           r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))
      //       .hasMatch(value)) {
      //     addError(error: "Please enter valid Password");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
          labelText: "New password",
          //  hintText: "Password",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              })),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter email");
      //   } else if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      //       .hasMatch(value)) {
      //     removeError(error: "Please enter valid Email");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter email");
      //     return "";
      //   } else if (!(RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
      //       .hasMatch(value)) {
      //     addError(error: "Please enter valid Email");
      //     return "";
      //   }

      //   return null;
      // },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Email",
        hintText: user_profile.diver.account.email,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.mail),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      controller: _controllerPhone,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onSaved: (newValue) => phoneNumber = newValue,
      // onChanged: (value) {
      //   if (value.isNotEmpty) {
      //     removeError(error: "Please enter phone");
      //   }
      //   return null;
      // },
      // validator: (value) {
      //   if (value.isEmpty) {
      //     addError(error: "Please enter phone");
      //     return "";
      //   }
      //   return null;
      // },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Phone number",
        hintText: user_profile.diver.phone,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
    );
  }
}
