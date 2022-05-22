import 'dart:io' as io;
import 'package:country_picker/country_picker.dart';
import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:diving_trip_agency/screens/signup/company/signup_divemaster.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../../../nautilus/proto/dart/model.pb.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:csc_picker/csc_picker.dart';

//check pass
class SignupCompanyForm extends StatefulWidget {
  @override
  _SignupCompanyFormState createState() => _SignupCompanyFormState();
}

class _SignupCompanyFormState extends State<SignupCompanyForm> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  String name;
  String username;
  String companyEmail;
  // String email;
  String phoneNumber;
  String address1;
  String password;
  String confirmPassword;
  String address2;
  String postalCode;
  String country = '';
  String region;
  String city = '';
  String stateValue = '';
  String _controllerCity = "";
  io.File _image;
  final List<String> errors = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerCompanyemail = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerConfirm = TextEditingController();
  final TextEditingController _controllerAddress2 = TextEditingController();
  final TextEditingController _controllerPostalcode = TextEditingController();
  final TextEditingController _controllerCountry = TextEditingController();
  final TextEditingController _controllerRegion = TextEditingController();
  //final TextEditingController _controllerCity = TextEditingController();

  io.File imageFile;
  io.File docFile;
  var bytes;
  //List<io.File> imagelist = <io.File>[];
  List<Asset> imagelist = <Asset>[];
  List<io.File> docList = <io.File>[];

  PickedFile Img;
  PickedFile doc;

  List<String> countryName = [
    'Thailand',
    'Korea',
    'Japan',
    'England',
    'Hongkong'
  ];
  String countrySelected;
  List<DropdownMenuItem<String>> listCountry = [];

  List<String> regionName = [
    'Asia',
    'Americas',
    'Africa',
    'Western Europe',
    'Central and Eastern Europe',
    'Mediterranean and Middle East'
  ];
  String regionSelected;
  List<DropdownMenuItem<String>> listRegion = [];

  //final ImagePicker _picker = ImagePicker();
  // Pick an image
  //PickedFile image = await _picker.getImage(source: ImageSource.gallery);
  // XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  /// Get from gallery
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = io.File(pickedFile.path);

        Img = pickedFile;

        //bytes = imageFile.readAsBytes();
      });
    }
  }

  _getdoc() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        docFile = io.File(pickedFile.path);
        doc = pickedFile;
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

  void sendCompany() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);

    final stub = AccountClient(channel);
    var account = Account();
    account.username = _controllerUsername.text;
    account.email = _controllerCompanyemail.text;
    account.password = _controllerPassword.text;
    var address = Address();
    address.addressLine1 = _controllerAddress.text;
    address.addressLine2 = _controllerAddress2.text;
    address.city = _controllerCity;
    address.postcode = _controllerPostalcode.text;
    address.region = regionSelected;
    address.country = countrySelected;
    var agency = Agency();
    agency.name = _controllerName.text;
    agency.phone = _controllerPhone.text;
    agency.address = address;
    agency.account = account;
    //agency.documents.add(imageFile);

    //final pngByteData = await imageFile.toByteData(format: ImageByteFormat.png);

    //ns file

    var f = File();
    f.filename = 'Image.jpg';
    //var t = await imageFile.readAsBytes();
    //f.file = new List<int>.from(t);
    List<int> b = await doc.readAsBytes();
    f.file = b;
    agency.documents.add(f);

    var f2 = File();
    f2.filename = 'Image.jpg';
    List<int> a = await Img.readAsBytes();
    f2.file = a;
    agency.documents.add(f2);

    var accountRequest = AccountRequest();
    accountRequest.agency = agency;

    var loginRequest = LoginRequest();
    loginRequest.email = account.email;
    loginRequest.password = account.password;

    var box;
    try {
      var response = await stub.create(accountRequest);
      print('response: ${response}');
      print('login');
      await Hive.openBox('userInfo');
      box = Hive.box('userInfo');
      var response2 = await stub.login(loginRequest);
      box.put('token', response2.token);
      box.put('login', true);
      String token = box.get('token');
      print("login ja");
    } on GrpcError catch (e) {
      print('codeName: ${e.codeName}');
      print('details: ${e.details}');
      print('message: ${e.message}');
      print('rawResponse: ${e.rawResponse}');
      print('trailers: ${e.trailers}');
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
      box.put('login', false);
    }
  }

  void listDetail() {
    listCountry = [];
    listCountry = countryName
        .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
        .toList();

    listRegion = [];
    listRegion = regionName
        .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    listDetail();
    double screenwidth = MediaQuery.of(context).size.width;
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
          buildCompanyEmailFormField(),
          SizedBox(height: 20),
          // buildEmailFormField(),
          // SizedBox(height: 20),
          buildPhoneNumberFormField(),
          SizedBox(height: 20),
          buildAddressFormField(),
          SizedBox(height: 20),
          buildAddress2FormField(),
          SizedBox(height: 20),

              Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),

                  child: Column(
                    children: [
                      ///Adding CSC Picker Widget in app
                      CSCPicker(
                        ///Enable disable state dropdown [OPTIONAL PARAMETER]
                        showStates: true,

                        /// Enable disable city drop down [OPTIONAL PARAMETER]
                        showCities: false,

                        ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                        flagState: CountryFlag.DISABLE,

                        ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                        dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                            border:
                            Border.all(color: Colors.grey.shade300, width: 1)),

                        ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                        disabledDropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey.shade300,
                            border:
                            Border.all(color: Colors.grey.shade300, width: 1)),

                        ///placeholders for dropdown search field
                        countrySearchPlaceholder: "Country",
                        stateSearchPlaceholder: "State",
                        citySearchPlaceholder: "City",

                        ///labels for dropdown
                        countryDropdownLabel: "*Country",
                        stateDropdownLabel: "*State",
                        cityDropdownLabel: "*City",

                        ///Default Country
                        //defaultCountry: DefaultCountry.India,

                        ///Disable country dropdown (Note: use it with default country)
                        //disableCountry: true,

                        ///selected item style [OPTIONAL PARAMETER]
                        selectedItemStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),

                        ///DropdownDialog Heading style [OPTIONAL PARAMETER]
                        dropdownHeadingStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontWeight: FontWeight.bold),

                        ///DropdownDialog Item style [OPTIONAL PARAMETER]
                        dropdownItemStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),

                        ///Dialog box radius [OPTIONAL PARAMETER]
                        dropdownDialogRadius: 10.0,

                        ///Search bar radius [OPTIONAL PARAMETER]
                        searchBarRadius: 10.0,

                        ///triggers once country selected in dropdown
                        onCountryChanged: (value) {
                          setState(() {
                            ///store value in country variable
                            countrySelected = value;
                            //print(country);
                          });
                        },

                        ///triggers once state selected in dropdown
                        onStateChanged: (value) {
                          setState(() {
                            ///store value in state variable
                            _controllerCity = value;
                          });
                        },

                        ///triggers once city selected in dropdown
                        onCityChanged: (value) {
                          setState(() {
                            ///store value in city variable
                            stateValue = value;
                          });
                        },
                      ),

                      ///print newly selected country state and city in Text Widget
                      // TextButton(
                      //     onPressed: () {
                      //       setState(() {
                      //         address = "$cityValue, $stateValue, $countryValue";
                      //       });
                      //     },
                      //     child: Text("Print Data")),
                      //Text(address)
                    ],
                  )),
              // Container(
              //     width: MediaQuery.of(context).size.width / 3.6,
              //     child: buildCountryFormField()),
              //Spacer(),
              // Spacer(flex: 1,),
              // Container(
              //     width: MediaQuery.of(context).size.width / 3.6,
              //     child: buildCityFormField()),

          SizedBox(height: 20),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3.6,
                color: Colors.white,
                child: Center(
                  child: DropdownButtonFormField(
                    isExpanded: true,
                    value: regionSelected,
                    items: listRegion,
                    hint: Text('  Select region'),
                    iconSize: 40,
                    validator: (value) {
                      if (value == null) {
                        addError(error: "Please select region");
                        return "";
                      }
                      return null;
                    },
                    onChanged: (value) {
                      if (value != null) {
                        removeError(error: "Please select region");
                        setState(() {
                          regionSelected = value;
                          print(value);
                        });
                      }
                    },
                  ),
                ),
              ),
              Spacer(),
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildPostalCodeFormField()),
            ],
          ),

          SizedBox(height: 20),
          buildPasswordFormField(),
          SizedBox(height: 20),
          buildConfirmPasswordFormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Verified Document'),
                  Text('(อาจเป็นเอกสารยืนยันบริษัท)'),
                ],
              ),
              Center(
                  child: docFile == null
                      ? Column(
                          children: [Text('')],
                        )
                      : kIsWeb
                          ? Image.network(
                              docFile.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(docFile.path),
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
                  _getdoc();
                },
              ),
            ],
          ),
          SizedBox(height: 20),

          //Center(child:imageFile == null ? Text('No image selected'):Text("You have an image")),
          //Center(child:imageFile == null ? Text('No image selected'):Image.file(imageFile,fit:BoxFit.cover,)),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Company Image'),
                  // Text('Image'),
                ],
              ),
              Center(
                  child: imageFile == null
                      ? Text('')
                      : kIsWeb
                          ? Image.network(
                              imageFile.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(imageFile.path),
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
                  _getFromGallery();
                },
              ),
            ],
          ),
          //Center(child:imageFile == null ? Text('No image selected'):Text(imageFile.path.split('/').last)),

          SizedBox(height: 20),
          SizedBox(height: 20),
          FormError(errors: errors),
          SizedBox(height: 20),
          FlatButton(
            onPressed: () => {
              if (_formKey.currentState.validate())
                {
                  if (docFile == null || imageFile == null)
                    {
                      addError(error: "Please upload image"),
                    }
                  else
                    {
                      sendCompany(),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainCompanyScreen())),
                    }
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
      cursorColor: Color(0xFFf5579c6),
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
          //   hintText: "Name",
          labelText: "Company Name",
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
      keyboardType: TextInputType.name,
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
          //       hintText: "Username",
          labelText: "Username",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: _controllerAddress,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address1 = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter address");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter address");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          //    hintText: "Address1",
          labelText: "Address 1",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      controller: _controllerConfirm,
      obscureText: _isObscure,
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
          fillColor: Colors.white,
          //  hintText: "Confirm password",
          labelText: "Confirm Password",
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
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter password");
        } else if (value.length >= 6) {
          removeError(error: "Password is too short");
        } else if (RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(value)) {
          removeError(error: "Please enter valid password");
        }
        password = value;
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter password");
          return "";
        } else if (value.length < 6) {
          addError(error: "Password is too short");
          return "";
        } else if (!(RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))
            .hasMatch(value)) {
          addError(error: "Please enter valid password");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          //   hintText: "Password",
          labelText: "Password",
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

  // TextFormField buildEmailFormField() {
  //   return TextFormField(
  //     controller: _controllerEmail,
  //     keyboardType: TextInputType.emailAddress,
  //     onSaved: (newValue) => email = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: "Please Enter your email");
  //       } else if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
  //           .hasMatch(value)) {
  //         removeError(error: "Please Enter Valid Email");
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: "Please Enter your email");
  //         return "";
  //       } else if (!(RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
  //           .hasMatch(value)) {
  //         addError(error: "Please Enter Valid Email");
  //         return "";
  //       }

  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       filled: true,
  //       fillColor: Colors.white,
  //       hintText: "Email",
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //       suffixIcon: Icon(Icons.mail),
  //     ),
  //   );
  // }

  TextFormField buildCompanyEmailFormField() {
    return TextFormField(
      controller: _controllerCompanyemail,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => companyEmail = newValue,
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
        fillColor: Colors.white,
        //   hintText: "Company email",
        labelText: "Company email",
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
        fillColor: Colors.white,
        //  hintText: "Phone number",
        labelText: "Phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
    );
  }

  TextFormField buildAddress2FormField() {
    return TextFormField(
      controller: _controllerAddress2,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address2 = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter address");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter address");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          //   hintText: "Address2",
          labelText: "Address 2",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildCountryFormField() {
    return TextFormField(
      controller: _controllerCountry,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => country = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter country");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter country");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "Country",
        labelText: "Country",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  // TextFormField buildCityFormField() {
  //   return TextFormField(
  //     controller: _controllerCity,
  //     cursorColor: Color(0xFFf5579c6),
  //     onSaved: (newValue) => city = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: "Please enter city");
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: "Please enter city");
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       //   hintText: "City",
  //       labelText: "City",
  //       filled: true,
  //       fillColor: Colors.white,
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //     ),
  //   );
  // }

  TextFormField buildRegionFormField() {
    return TextFormField(
      controller: _controllerRegion,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => region = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter region");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter region");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //    hintText: "Region",
        labelText: "Region",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPostalCodeFormField() {
    return TextFormField(
      controller: _controllerPostalcode,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => postalCode = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter postal code");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter postal code");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "Postal code",
        labelText: "Postal code",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
