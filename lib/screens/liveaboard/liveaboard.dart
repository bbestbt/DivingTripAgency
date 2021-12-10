import 'package:diving_trip_agency/screens/liveaboard/liveaboard_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class liveaboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        child: Container(
          //   margin: EdgeInsetsDirectional.only(top:120),
          width: double.infinity,
          // height: 600,
          decoration: BoxDecoration(color: Color(0xfffd4f0f7).withOpacity(0.3)),
          child: Column(
            children: [
              SectionTitle(
                title: "Liveaboard",
                color: Color(0xFFFF78a2cc),
              ),
              SizedBox(height: 40),
              SizedBox(
                  width: 1110,
                  child: Wrap(
                      spacing: 20,
                      runSpacing: 40,
                      children: List.generate(
                        LiveAboardDatas.length,
                        (index) => InfoCard(
                          index: index,
                        ),
                      ))),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatefulWidget {
  const InfoCard({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 320,
        width: 1000,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
                width: 300,
                height: 300,
                child: Image.asset(LiveAboardDatas[widget.index].image)),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text('Trip name : '),
                            Text(LiveAboardDatas[widget.index].name),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(LiveAboardDatas[widget.index].description),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text('Price :'),
                            Text(LiveAboardDatas[widget.index].price),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          onPressed: () {},
                          color: Colors.amber,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text("Book"),
                        )
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

// class liveaboardT extends StatelessWidget {
//   const liveaboardT({
//     Key key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(40),
//       constraints: BoxConstraints(maxWidth: 1110),
//       decoration: BoxDecoration(
//           color: Colors.white, borderRadius: BorderRadius.circular(20)),
//       child: Row(
//         children: [
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 20),
//             child: SizedBox(
//               height: 80,
//               child: VerticalDivider(),
//             ),
//           ),
//           Expanded(
//               child: Column(
//             children: [
//               Text(
//                 "LIVEABORD",
//                 style: TextStyle(
//                     fontSize: 42,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black),
//               ),
//             ],
//           ))
//         ],
//       ),
//     );
//   }
// }

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    Key key,
    this.title,
    this.color,
  }) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      constraints: BoxConstraints(maxWidth: 1110),
      height: 100,
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.only(right: 20),
            padding: EdgeInsets.only(bottom: 72),
            width: 8,
            height: 100,
            color: Color(0xfff7ec4cf),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: color,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headline2
                    .copyWith(fontWeight: FontWeight.bold, color: Colors.black),
              )
            ],
          )
        ],
      ),
    );
  }
}
