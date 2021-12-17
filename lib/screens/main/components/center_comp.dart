import 'package:flutter/material.dart';

class CenterCompanySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome agency',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black)),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 20),
            //   child: Text(
            //     'Plan with us',
            //     style: TextStyle(fontSize: 16),
            //   ),
            // ),
            SizedBox(height:20),
            MaterialButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              onPressed: () {},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  'All Detail',
                  style: TextStyle(color: Colors.green, fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
      constraints: BoxConstraints(maxHeight: 300, minHeight: 100),
      width: double.infinity,
      decoration: BoxDecoration(
          //color: Color(0xfffdcfffb)
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
             Color(0xfffcfecd0),
            Color(0xfffffc5ca),
          ])),
    ));
  }
}
