import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens.dart/main/mainScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
class SideMenu extends StatelessWidget {
 final MenuController _controller = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xfff82CAFA),
        child: Obx(()=>ListView(
          children: [
            DrawerHeader(
                child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text("DivingTrip"),
            )),
            //  DrawerItem()
            ...List.generate(
                _controller.menuItems.length,
                (index) => DrawerItem(
                      isActive: index == _controller.selectedIndex ,
                      title: _controller.menuItems[index],
                      press: (){
                        _controller.setMenuIndex(index);


                      },
                    ))
          ],
        ),)
      ),
    );
  }
}