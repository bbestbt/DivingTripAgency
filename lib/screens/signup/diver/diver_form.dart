import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/signup/diver/levelDropdown.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class SignupDiverForm extends StatefulWidget {
  @override
  _SignupDiverFormState createState() => _SignupDiverFormState();
}

class _SignupDiverFormState extends State<SignupDiverForm> {
  final _formKey = GlobalKey<FormState>();
  String username;
  String name;
  String lastname;
  // String level;
  String phoneNumber;
  String email;
  String password;
  String confirmPassword;
  final List<String> errors = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerConfirm = TextEditingController();
  io.File DiverImage;
  io.File DiveBack;
  DateTime _dateTime;

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

  void sendRequest() {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);

    final stub = AccountClient(channel);
    // var accountRequest = AccountRequest();
    // var diver =Diver();
    // var account =Account();
    // diver.account=account;
    var account = Account();
    account.username = _controllerUsername.text;
    account.email = _controllerEmail.text;
    account.password = _controllerPassword.text;
    var diver = Diver();
    diver.firstName = _controllerName.text;
    diver.lastName = _controllerLastname.text;
    diver.phone = _controllerPhone.text;
    diver.account = account;
    //  diver.birthDate=

   // diver.level=LevelType.MASTER;

    var accountRequest = AccountRequest();
    accountRequest.diver = diver;

    try {
      var response = stub.create(accountRequest);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }

  /// Get from gallery
  _getPicDiver() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        DiverImage = io.File(pickedFile.path);
      });
    }
  }

  /// Get from gallery
  _getPicCard() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        DiveBack = io.File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          buildUsernameFormField(),
          SizedBox(height: 20),
          buildNameFormField(),
          SizedBox(height: 20),
          buildLastnameFormField(),
          SizedBox(height: 20),
          LevelDropdown(),
          SizedBox(height: 20),
          buildEmailFormField(),
          SizedBox(height: 20),
          buildPhoneNumberFormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Text('Birthday'),
              Spacer(),
              Text(_dateTime == null ? '' : _dateTime.toString()),
              Spacer(),
              RaisedButton(
                  color: Color(0xfff75BDFF),
                  child: Text('Pick a date'),
                  onPressed: () {
                    showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now())
                        .then((date) => {
                              setState(() {
                                _dateTime = date;
                              })
                            });
                  }),
            ],
          ),
          SizedBox(height: 20),
          buildPasswordFormField(),
          SizedBox(height: 20),
          buildConfirmPasswordFormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Center(
                child: DiverImage == null
                    ? Text('Front image')
                    : kIsWeb
                        ? Image.network(
                            DiverImage.path,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            io.File(DiverImage.path),
                            fit: BoxFit.cover,
                          ),
              ),
              Spacer(),
              FlatButton(
                color: Color(0xfff75BDFF),
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
              Center(
                  child: DiveBack == null
                      ? Text('Back image')
                      : kIsWeb
                          ? Image.network(
                              DiveBack.path,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              io.File(DiveBack.path),
                              fit: BoxFit.cover,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfff75BDFF),
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
            onPressed: () => {
              if (_formKey.currentState.validate())
                {
                  //_formKey.currentState.save()
                  //  print(_controllerUsername.text),
                  //   print( _dateTime.toString()),
                  //   sendRequest()
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainScreen()))
                }
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
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFF6F35A5),
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: "Name",
          filled: true,
          fillColor: Color(0xFFFd0efff),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildLastnameFormField() {
    return TextFormField(
      controller: _controllerLastname,
      cursorColor: Color(0xFF6F35A5),
      keyboardType: TextInputType.name,
      onSaved: (newValue) => lastname = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter lastname");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter lastname");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: "Lastname",
          filled: true,
          fillColor: Color(0xFFFd0efff),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildUsernameFormField() {
    return TextFormField(
      controller: _controllerUsername,
      cursorColor: Color(0xFF6F35A5),
      onSaved: (newValue) => username = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter username");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter username");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: "Username",
          filled: true,
          fillColor: Color(0xFFFd0efff),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      controller: _controllerConfirm,
      obscureText: true,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (password == confirmPassword) {
          removeError(error: "Password doesn't match");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "";
        } else if (password != value) {
          addError(error: "Password doesn't match");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFFd0efff),
        hintText: "Confirm password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.lock),
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _controllerPassword,
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter password");
        } else if (value.length >= 8) {
          removeError(error: "Password is too short");
        } else if (RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(value)) {
          removeError(error: "Please enter valid Password");
        }
        password = value;
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter password");
          return "";
        } else if (value.length < 8) {
          addError(error: "Password is too short");
          return "";
        } else if (!(RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))
            .hasMatch(value)) {
          addError(error: "Please enter valid Password");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Password",
        filled: true,
        fillColor: Color(0xFFFd0efff),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.lock),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter email");
        } else if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          removeError(error: "Please enter valid Email");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter email");
          return "";
        } else if (!(RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
            .hasMatch(value)) {
          addError(error: "Please enter valid Email");
          return "";
        }

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFFd0efff),
        hintText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.mail),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      controller: _controllerPhone,
      keyboardType: TextInputType.phone,
      onSaved: (newValue) => phoneNumber = newValue,
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
        filled: true,
        fillColor: Color(0xFFFd0efff),
        hintText: "Phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
    );
  }
}
