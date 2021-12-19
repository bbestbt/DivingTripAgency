import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:flutter/material.dart';

class ListViewTripDetail extends StatefulWidget {
  @override
  _ListViewTripDetailState createState() => _ListViewTripDetailState();
}

class _ListViewTripDetailState extends State<ListViewTripDetail> {
  var nameList = ['Phuket12', 'Samui22', 'Krabi33'];
  var descList = ["Phuket province is located in southern Thailand. It is the biggest Island of Thailand and sits on the Andaman sea. The nearest province to the north is Phang-nga and the nearest provinces to the east are Phang-nga and Krabi.\nPhuket has a large Chinese influence, so you will see many Chinese shrines and Chinese Restaurants around the city. A Chinese Vegetarian Festival is held there every year. While the Chinese community is quite big, there are many other ethnicities bringing all their traditions and festivals from all over the world to Phuket.\nBeing a big island, Phuket is surrounded by many magnificent Beaches such as Rawai, Patong, Karon, Kamala, Kata Yai, Kata Noi, and Mai Khao. Laem Phromthep viewpoint is said to feature the most beautiful sunsets in Thailand.\nIt isn’t all just beaches though, there is also fantastic classical architecture such as the Goom Restaurant. That and the very welcome atmosphere and the famous Phuket NIGHTLIFE, you can see why the island is a hotspot for tourists in Thailand.\nVisiting Phuket is easy as there are many travel options."
    , "Ko Samui (or Koh Samui, also often locally shortened to Samui; Thai: เกาะสมุย, pronounced [kɔ̀ʔ sā.mǔj]) is an island off the east coast of Thailand. Geographically in the Chumphon Archipelago, it is part of Surat Thani Province, though as of 2012, Ko Samui was granted municipal status and thus is now locally self-governing. Ko Samui, with an area of 228.7 square kilometres (88.3 sq mi), is Thailand's second largest island after Phuket.[2] In 2018, it was visited by 2.7 million tourists.[3]",
    'Krabi is famous for its scenic view and breathtaking Beaches and Islands. Its coral reef vistas are also one of the world’s most beautiful, which makes the city a great spot for coral diving.\nWith attractions including hot springs, a wildlife sanctuary, sea caves, flourishing coral reefs and exotic marine life, limestone cliffs that draw rock climbing enthusiasts from around the world, and national parks that include the island paradises of Koh Phi Phi and Koh Lanta, one could easily spend weeks in Krabi and leave yearning for more.\nIf that wasn’t enough, Krabi features some of the most photogenic sunsets in Thailand, often accompanied by spectacular displays of cloud to cloud lightning, that are best enjoyed from a beachside bar or Restaurant.\n“Town” to most visitors is Ao Nang, a seaside strip of guesthouses, hotels, bars, restaurants, and Souvenir shops that continues to grow as tourist arrivals increase, now spreading north into Noppharat Thara, whose quiet, shady beach is part of the National Park that includes the Phi Phi Islands. Ao Nang is the major launching point for Boat trips to nearby islands and the isolated beaches of Phra Nang Cape, where the famous former hippie enclave of Railey Beach is located.\nKrabi also provides you with great Shopping venues such as Maharaj Walking Street (Friday-Sunday market from 5.00 – 10.00 pm) and Chao Fah Pier night market (daily market from 5.00 pm – 12.30 am). \nKey Tips\n Visitors are advised to make early reservations (up to a year in advance) for Accommodation during the peak season from late December to early January because of the popularity of the Krabi and its attractions.\n When travelling by ferry to islands around Krabi, it may be preferable to purchase only a one-way ticket so that your trip can be more easily altered and you can more easily arrange your departure.'];
  var imgList = [
    'assets/images/S__77242370.jpg',
    'assets/images/S__83271684.jpg',
    'assets/images/S__83271687.jpg'
  ];
  //var revList =["Charlotte","Peter","Ollie"];
  //var revstarlist = [5,4,5];
  //var revcomment =["Nice!", "Awesome!"]
  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width * 0.9;
    return ListView.builder(
          padding: const EdgeInsets.all(5),
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: imgList.length,
          itemBuilder: (context, index) {
            return Card(
                child: Column(
                    mainAxisSize:MainAxisSize.min,
                    children:<Widget>[
                      Container(child:Image.asset(imgList[index])),
                      Container(child:Text(nameList[index])),
                      Container(child:
                      Container(
                          padding: EdgeInsets.all(10),
                          child:Text(
                            descList[index],
                            style: TextStyle(fontSize: 15),
                            textAlign: TextAlign.justify,))),
                      Container(child:
                          Container(
                            padding: EdgeInsets.all(10),
                            child:Text(
                              "Review",
                              style: TextStyle(fontSize: 15),
                              textAlign: TextAlign.justify,)
                                  )
                              ),

                      Container(child:
                                  Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:[
                                Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(color:Colors.blueAccent)
                                    ),
                                    padding: EdgeInsets.all(10),
                                    child:Column(children:[
                                      Text(
                                          "Katie says:",
                                          style: TextStyle(fontSize: 15),
                                          textAlign: TextAlign.left),
                                      Text(
                                          "Awesome!",
                                          style: TextStyle(fontSize: 10),
                                          textAlign: TextAlign.left),
                                          ] //children
                                        ) //column
                                      )//Review respondent Container
                                    ]//children
                              ) //column
                          ), //container
                      Container(child:
                      Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:[
                        TextFormField(
                        decoration: const InputDecoration(
                        icon: Icon(Icons.person),
                          hintText: 'Enter review here.',
                          labelText: 'Review',
                        ),

                          // This optional block of code can be used to run
                          // code when the user saves the form.
                        ),
                        TextButton(
                          style: ButtonStyle(
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          ),
                          onPressed: () { },
                          child: Text('Submit'),
                        )



                      ]))

                    ]));

          });

  }
}