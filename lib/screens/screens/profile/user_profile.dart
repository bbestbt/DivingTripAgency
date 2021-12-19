import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:flutter/material.dart';

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Header(),
          SizedBox(
            height: 50,
          ),
          Icon(
            Icons.image,
            size: 100,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Username : bbbb',style: TextStyle(fontSize: 18),),
                  Text('Name : abc',style: TextStyle(fontSize: 18),),
                  Text('Lastname : efg',style: TextStyle(fontSize: 18),),
                  Text('Level : 1',style: TextStyle(fontSize: 18),)
                ],
              ),
              Column(
                children: [
                  Text('E-mail : abc@gmail.com',style: TextStyle(fontSize: 18),),
                  Text('Phone number : 03848484848832',style: TextStyle(fontSize: 18),),
                  Text('Birthday : 10/12/1999',style: TextStyle(fontSize: 18),),
                  Text('Trip history',style: TextStyle(fontSize: 18),),
                ],
              )
            ],
          ),
          SizedBox(height: 30,),
           RaisedButton(child:Text('Edit',textAlign: TextAlign.right,),onPressed: (){})
        ],
      ),
    );
  }
}
