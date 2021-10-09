import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:flutter/material.dart';

class LevelDropdown extends StatefulWidget {
  // LevelDropdown() : super();
  @override
  _LevelDropdownState createState() => _LevelDropdownState();
}

// class Level {
//   int id;
//   String userlevel;

//   Level(this.id,this.userlevel);

//   static List<Level> getLevels() {
//     return <Level>[
//       Level(1,'1'),
//       Level(2,'2'),
//       Level(3,'3'),
//       Level(4,'4'),
//       Level(5,'5'),
//     ];
//   }
// }

class _LevelDropdownState extends State<LevelDropdown> {
  List<DropdownMenuItem<String>> listDrop = [];
  List<LevelType> drop = [LevelType.MASTER,LevelType.OPEN_WATER,LevelType.RESCUE,LevelType.INSTRUCTOR,LevelType.ADVANCED_OPEN_WATER];
  String selected = null;
  
  void loadData() {
    drop.forEach((element) {
      print(element);
    });
    listDrop = [];
    listDrop = drop
        .map((val) => DropdownMenuItem<String>(child: Text(val.toString()), value: val.value.toString()))
        .toList();
  }
  // List<Level> _levels = Level.getLevels();
  // List<DropdownMenuItem<Level>> _dropdownMenuItems;
  // Level _selectedLevel;
  // @override
  // void initState() {
  //   _dropdownMenuItems = buildDropDownMenuItems(_levels);
  //   _selectedLevel = _dropdownMenuItems[0].value;
  // }

  // List<DropdownMenuItem<Level>> buildDropDownMenuItems(List levels) {
  //   List<DropdownMenuItem<Level>> items = List();
  //   for (Level level in levels) {
  //     items.add(DropdownMenuItem(value: level, child: Text(level.userlevel)));
  //   }
  //   return items;
  // }

  // onChangeDropdownItem(Level selectedLevel) {
  //   setState(() {
  //     _selectedLevel = selectedLevel;
  //   });

  Widget build(BuildContext context) {
    loadData();
    return Container(
      color: Color(0xFFFd0efff),
      child: Center(
        child: DropdownButton(
          isExpanded: true,
          value: selected,
          items: listDrop,
          hint: Text('  Select level'),
          iconSize: 40,
          onChanged: (value) {
        selected = value;
        // print(value);
        setState(() {});
          },
        ),
      ),
    );
    // Container(
    //   child: Center(
    //       child: Column(
    //     children: [
    //       Row(
    //         children: [
    //           // Text('Level'),
    //           Expanded(
    //             child: Container(
    //              // width: MediaQuery.of(context).size.width,
    //               decoration: BoxDecoration(
    //                 color: Color(0xFFFd0efff),
    //               ),
    //               child: DropdownButton(
    //                 isExpanded: true,
    //                 hint: Text('Level',textAlign: TextAlign.center) ,
    //                 value: _selectedLevel,
    //                 items: _dropdownMenuItems,
    //                 onChanged: onChangeDropdownItem,
    //               ),
    //             ),
    //           )
    //         ],
    //       ),
    //     ],
    //   )),
    // );
  }
}
