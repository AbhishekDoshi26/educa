import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String videoURL;

  FullScreenVideoPlayer({this.videoURL});
  @override
  _FullScreenVideoPlayerState createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  VideoPlayerController _videoPlayerController;
  bool isButtonClicked = true;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(widget.videoURL)
      ..initialize().then((value) {
        setState(() {
          _videoPlayerController.play();
        });
      });

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
        Navigator.pop(context);
        return;
      },
      child: Scaffold(
        body: !_videoPlayerController.value.initialized ||
                _videoPlayerController.value.isBuffering
            ? Center(
                child: CircularProgressIndicator(),
              )
            : OrientationBuilder(
                builder: (BuildContext context, Orientation orientation) {
                  return Stack(
                    children: [
                      VideoPlayer(_videoPlayerController),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 50.0,
                            ),
                            onPressed: () {
                              orientation == Orientation.portrait
                                  ? SystemChrome.setPreferredOrientations([
                                      DeviceOrientation.landscapeLeft,
                                    ])
                                  : SystemChrome.setPreferredOrientations([
                                      DeviceOrientation.portraitUp,
                                    ]);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
