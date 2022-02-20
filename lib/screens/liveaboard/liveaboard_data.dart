class LiveAboardData {
  final String image,name, description, price;
  final int id;

  LiveAboardData({this.id,this.name,this.image, this.description, this.price});

  String getname(){
    return name;
  }
}

// Demo List of my works
List<LiveAboardData> LiveAboardDatas = [
  LiveAboardData(
    id: 1,
    name: 'p0',
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    image: "assets/images/S__77242370.jpg",
    price: "100"
  ),
  LiveAboardData(
    id: 2,
    name: 'p2',
    description: "jajjsja",
    image: "assets/images/S__77250562.jpg",
    price: "2000"
  ),
  LiveAboardData(
    id: 3,
    name: 'p3',
    description: "jajsjjs",
    image: "assets/images/S__77250562.jpg",
    price: "3500"
  ),
  LiveAboardData(
    id: 4,
    name: 'p4',
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
    image: "assets/images/S__83271689.jpg",
    price: "400"
  ),
  LiveAboardData(
      id: 5,
      name: 'p416',
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      image: "assets/images/S__83271689.jpg",
      price: "400"
  ),
  LiveAboardData(
      id: 6,
      name: 'p6',
      description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
      image: "assets/images/S__83271689.jpg",
      price: "400"
  ),
];