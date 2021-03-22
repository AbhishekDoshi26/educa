import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educa/constants.dart';
import 'package:educa/models/video_model.dart';
import 'package:educa/providers/auth_provider.dart';
import 'package:educa/providers/video_provider.dart';
import 'package:educa/screens/chat.dart';
import 'package:educa/screens/profile.dart';
import 'package:educa/screens/video_player.dart';
import 'package:educa/screens/video_recorder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final String email;
  final String name;

  HomePage({this.email, this.name});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _searchController = TextEditingController();
  VideoProvider _videoProvider;
  VideoModel _videoModel;
  bool isVideoUploading = false;
  FocusNode _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _videoProvider = Provider.of<VideoProvider>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: buildBottomBar(),
      body: Stack(
        children: [
          buildBody(),
          buildToast(),
        ],
      ),
    );
  }

  Widget buildBody() {
    return SafeArea(
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
                      'Hello, ${widget.name}!',
                      style: GoogleFonts.balooDa(fontSize: 20.0),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: Text(
                      AppPageTitles.kHomePageTitleContent,
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
                  SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildToast() {
    return SafeArea(
      child: Visibility(
        visible: isVideoUploading,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            height: 100.0,
            width: double.infinity,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40.0,
                    color: Colors.white,
                  ),
                  SizedBox(
                    width: 20.0,
                  ),
                  Text(
                    Messages.kVideoUploading,
                    style: GoogleFonts.balooDa(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.kAppColor),
              color: AppColors.kAlertColor,
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
            ),
          ),
        ),
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
            border: Border.all(color: AppColors.kAppColor),
            color: AppColors.kAppColor,
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
              onPressed: () async {
                _videoModel = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoRecorderExample(),
                  ),
                );
                if (_videoModel != null) {
                  setState(() {
                    isVideoUploading = true;
                  });
                  await _videoProvider.uploadData(_videoModel).then((value) {
                    if (_videoProvider.isSuccess) {
                      setState(() {
                        isVideoUploading = false;
                        showDialog(
                          context: context,
                          builder: (context) => buildAlertDialog(),
                        );
                      });
                    }
                  });
                }
                setState(() {
                  isVideoUploading = false;
                });
              }),
        ),
      ),
    );
  }

  Widget buildAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      title: Text(
        Messages.kSuccess,
        textAlign: TextAlign.center,
        style: GoogleFonts.balooDa(
          color: Colors.white,
        ),
      ),
      backgroundColor: AppColors.kAlertColor,
      content: Text(
        Messages.kVideoUploaded,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget buildBottomBar() {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 90.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.end,
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
                        color: AppColors.kAppColor,
                      ),
                    ],
                  ),
                  IconButton(
                      icon: Icon(Icons.messenger_outline),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(),
                          ),
                        );
                      }),
                  IconButton(
                    icon: Icon(Icons.person_outline_outlined),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (BuildContext context) => AuthProvider(),
                          child: ProfilePage(email: widget.email),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        buildVideoButton(),
      ],
    );
  }

  Widget buildList() {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection("videos").snapshots.call(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null)
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (snapshot.data.docs.length == 0)
            return Center(
              child: new Text(
                Messages.kNoVideos,
                style: GoogleFonts.balooDa(
                  fontSize: 20.0,
                  color: Colors.grey,
                ),
              ),
            );
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.docs.length,
            itemBuilder: (context, index) {
              return Visibility(
                visible: _searchController.text == ''
                    ? true
                    : snapshot.data.docs[index]
                            .data()['title']
                            .toString()
                            .toLowerCase()
                            .contains(_searchController.text) ||
                        snapshot.data.docs[index]
                            .data()['topic']
                            .toString()
                            .toLowerCase()
                            .contains(_searchController.text),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenVideoPlayer(
                        videoURL: snapshot.data.docs[index].data()['video_url'],
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: 250.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30.0),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                            snapshot.data.docs[index].data()['thumbnail_url'],
                          ),
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          height: 100.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30.0),
                              bottomRight: Radius.circular(30.0),
                            ),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, left: 20.0, bottom: 20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      snapshot.data.docs[index].data()['topic'],
                                      style: GoogleFonts.balooDa(
                                        color: AppColors.kAppColor,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    snapshot.data.docs[index].data()['title'],
                                    style: GoogleFonts.balooDa(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
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
              border: Border.all(color: AppColors.kAppColor),
              color: AppColors.kAppColor,
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
                border: Border.all(color: AppColors.kAppColor),
                borderRadius: BorderRadius.only(),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    style: TextStyle(fontSize: 18.0),
                    controller: _searchController,
                    focusNode: _searchFocus,
                    autofocus: false,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      hintText: HintText.kSearchHint,
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
