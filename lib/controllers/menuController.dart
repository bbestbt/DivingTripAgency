
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuController extends GetxController{
  RxInt _seleectedIndex=0.obs;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int get selectedIndex => _seleectedIndex.value;
  List<String> get menuItems =>["Home","Liveaboards","Dive resorts","Trip Details","Weather Forecast","About Us","Book a trip now"];

  GlobalKey<ScaffoldState> get scaffoldkey => _scaffoldKey;

  void openOrCloseDrawer(){
    if (_scaffoldKey.currentState.isDrawerOpen){
      _scaffoldKey.currentState.openEndDrawer();
    }else{
      _scaffoldKey.currentState.openDrawer();
    }
  }
  void setMenuIndex(int index){
    _seleectedIndex.value=index;


  }
}