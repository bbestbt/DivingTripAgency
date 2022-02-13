import 'dart:ui';
import 'package:diving_trip_agency/screens/main/components/people.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(maxHeight: 600, minHeight: 100),
        width: double.infinity,
        decoration: BoxDecoration(
            //  color: Color(0xfffdcfffb)
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/scuba-diving.jpg'))),
        child: Container(
          width: 500,
          child: Column(
            children: [
              // Text('a'),
              SizedBox(height: 50),
              GlassContent(size: size),
            ],
          ),
        ),
      ),
    );
  }
}

class GlassContent extends StatefulWidget {
  const GlassContent({
    Key key,
    @required this.size,
  }) : super(key: key);

  final Size size;

  @override
  _GlassContentState createState() => _GlassContentState();
}

class _GlassContentState extends State<GlassContent> {
  DateTimeRange dateRange;
  var destination = ["Phuket", "Samui"];
  String getFrom() {
    if (dateRange == null) {
      return 'From';
    } else {
      return DateFormat('MM/dd/yyyy').format(dateRange.start);
    }
  }

  String getTo() {
    if (dateRange == null) {
      return 'To';
    } else {
      return DateFormat('MM/dd/yyyy').format(dateRange.end);
    }
  }

  String searchdest(){
    var dest = "Phuket";
    return dest;
  }

  @override
  String search;
  var destList = [
    ['assets/images/S__77242370.jpg',"Phuket","Full Board",5],
    ['assets/images/S__83271684.jpg',"Ko Samui","Full Board", 5],
    ['assets/images/S__83271687.jpg',"Krabi","Full Board",5] //image, name, type and rating
  ];
  final TextEditingController _controllerSearch = TextEditingController();
  Widget build(BuildContext context) {
    return Column(
      children:[
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0),
              //  color: Colors.pink,
              constraints: BoxConstraints(
                  maxWidth: 400, maxHeight: widget.size.height * 0.25),

              child: Column(
                children: [
                  buildSearchFormField(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      RaisedButton(
                        onPressed: () => pickDateRange(context),
                        child: Text(getFrom()),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.arrow_forward, color: Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      RaisedButton(
                        onPressed: () => pickDateRange(context),
                        child: Text(getTo()),
                      ),
                      SizedBox(
                        width: 10,
                      ),

                      Spacer(),
                      // Text('People'),
                      Icon(Icons.people),
                      SizedBox(
                        width: 10,
                      ),
                      peopleDropdown()
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RaisedButton(child: Text('Confirm'), onPressed: () {}),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(child: Text('See All Trips'), onPressed: () {})
                ],
              ),
            ),
          ),
        ),
        SizedBox(
        height: 20
        ),
        Container(
          width:  MediaQuery.of(context).size.width*0.4,
          child: ListView.builder(
              padding: const EdgeInsets.all(5),
              physics: const NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              // itemCount: imgList.length,
              itemCount: destList.length,
              itemBuilder: (context, index) {
                return Center(
                  child: Card(
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[Flexible(flex:1,child:
                          //Container(child: Image.asset(imgList[index]))),
                          Container(child: Image.asset(destList[index][0]))),
                            Flexible(flex:2,child:
                            Column(mainAxisSize: MainAxisSize.min,children:[
                              Container(child: Text("TestBooking")),
                              Container(child: Column(children:[
                                Text("Location: "+destList[index][1]),
                                Text(destList[index][2]),
                                Text(destList[index][3].toString()+" Star Hotel")
                              ]))
                            ]
                            )



                            ),
                            Flexible(flex:1,child:
                            Container(child: Text("Stars"))),

                          ]
                      )
                     ),
                );
              }
          )
        )

      ]
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(Duration(hours: 24 * 3)));
    final newDateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));
    initialDateRange:
    dateRange ?? initialDateRange;
    if (newDateRange == null) return;
    setState(() => dateRange = newDateRange);
  }

  TextFormField buildSearchFormField() {
    return TextFormField(
      controller: _controllerSearch,
      onSaved: (newValue) => search = newValue,
      decoration: InputDecoration(
        hintText: "  Search",
        filled: true,
        fillColor: Colors.white,
        suffixIcon: Icon(Icons.search),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPeopleFormField() {
    return TextFormField(
      controller: _controllerSearch,
      onSaved: (newValue) => search = newValue,
      decoration: InputDecoration(
        hintText: "  Search",
        filled: true,
        fillColor: Colors.white,
        suffixIcon: Icon(Icons.search),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
