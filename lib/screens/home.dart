import 'package:educa/constants.dart';
import 'package:educa/models/user_model.dart';
import 'package:educa/screens/chat.dart';
import 'package:educa/screens/profile.dart';
import 'package:educa/screens/video_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  final UserModel userModel;

  HomePage({this.userModel});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _userName = 'name';
  TextEditingController _searchController = TextEditingController();
  String _videoURL =
      'https://miro.medium.com/max/1000/1*ilC2Aqp5sZd1wi0CopD1Hw.png';
  String _title = 'Biology Basics';
  String _description = 'Biology & Scientific Methodologies';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 50.0,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Hello, ${widget.userModel.fullName.split(' ')[0]}!',
                            style: GoogleFonts.balooDa(fontSize: 20.0),
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Text(
                            'What would you like to learn today?',
                            style: GoogleFonts.balooDa(
                                fontSize: 25.0, color: Colors.grey),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        buildSearchBar(),
                        SizedBox(
                          height: 40.0,
                        ),
                        buildList(),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: buildBottomBar(),
                ),
              ],
            ),
          ),
          buildVideoButton(),
        ],
      ),
    );
  }

  Widget buildVideoButton() {
    return Positioned.fill(
      bottom: 30.0,
      right: 20.0,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: kAppColor),
            color: kAppColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: IconButton(
              splashColor: Colors.transparent,
              icon: Icon(
                Icons.videocam_outlined,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoRecorderExample(),
                  ),
                );
              }),
        ),
      ),
    );
  }

  Widget buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 90.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              IconButton(
                icon: Icon(
                  Icons.book_outlined,
                ),
                onPressed: () {},
              ),
              Icon(
                Icons.circle,
                size: 6,
                color: kAppColor,
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.messenger_outline),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatPage(),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.person_outline_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildList() {
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              width: 250.0,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30.0),
                  ),
                ),
                child: Stack(
                  children: [
                    Image.network(
                      _videoURL,
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    _title,
                                    style: GoogleFonts.balooDa(
                                      color: kAppColor,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                                Text(
                                  _description,
                                  style: GoogleFonts.balooDa(
                                    color: Colors.black,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildSearchBar() {
    return Material(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          bottomLeft: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 55.0,
            decoration: BoxDecoration(
              border: Border.all(color: kAppColor),
              color: kAppColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            child: IconButton(
              color: Colors.white,
              icon: Icon(Icons.search),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: Container(
              height: 55.0,
              decoration: BoxDecoration(
                border: Border.all(color: kAppColor),
                borderRadius: BorderRadius.only(),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: 18.0),
                    controller: _searchController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
