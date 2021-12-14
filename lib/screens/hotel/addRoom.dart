import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/screens/hotel/room_form.dart';
import 'package:flutter/material.dart';

class AddMoreRoom extends StatefulWidget {
  List<RoomType> pinkValue=[];
  AddMoreRoom(List<RoomType> pinkValue) {
    this.pinkValue = pinkValue;
  }
  @override
  _AddMoreRoomState createState() => _AddMoreRoomState(this.pinkValue);
}

class _AddMoreRoomState extends State<AddMoreRoom> {
  int count = 1;
  List<RoomType> pinkValue=[]; 
    _AddMoreRoomState(List<RoomType> pinkValue) {

    this.pinkValue=pinkValue;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(thickness: 5, indent: 20,
            endIndent: 20,),
            shrinkWrap: true,
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return RoomForm(count.toString(),this.pinkValue);
            }),
        MaterialButton(
          onPressed: () {
            setState(() {
              count += 1;
              pinkValue.add(new RoomType());
            });
          },
          color: Color(0xfffff968a),
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
