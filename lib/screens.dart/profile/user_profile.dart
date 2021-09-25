import 'package:diving_trip_agency/screens.dart/main/components/header.dart';
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
          SizedBox(height: 50,),
          Icon(Icons.image,size: 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Username : bbbb'),
                  Text('Name : abc'),
                  Text('Lastname : efg'),
                  Text('Level : 1')
                ],
              ),
               Column(
            children: [
              Text('E-mail : abc@gmail.com'),
              Text('Phone number : 03848484848832'),
              Text('Birthday : 10/12/1999'),
              Text('Trip history'),
            ],
          )
            ],
          ),
         
        ],
      ),
    );
  }
}
