import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:educa/constants.dart';
import 'package:educa/models/video_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:thumbnails/thumbnails.dart';

class VideoRecorderExample extends StatefulWidget {
  @override
  _VideoRecorderExampleState createState() {
    return _VideoRecorderExampleState();
  }
}

class _VideoRecorderExampleState extends State<VideoRecorderExample> {
  CameraController controller;
  String videoPath;
  String thumbnailPath;
  List<CameraDescription> cameras;
  int selectedCameraIdx;
  double videoDuration = 0.0;
  Timer timer;
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  TextEditingController _topicController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  FocusNode _topicFocus = FocusNode();
  FocusNode _titleFocus = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isVideoRecorded = false;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraIdx = 0;
        });
        _onCameraSwitched(cameras[selectedCameraIdx]).then((void v) {});
      }
    }).catchError((err) {
      Fluttertoast.showToast(
        msg: err.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onValidate() {
    if (_formKey.currentState.validate()) {
      Navigator.pop(
        context,
        VideoModel(
          title: _titleController.text,
          topic: _topicController.text,
          videoFile: File(videoPath),
          thumbnailFile: File(thumbnailPath),
        ),
      );
    } else {
      setState(() {
        _autovalidateMode = AutovalidateMode.onUserInteraction;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (videoPath == null) Navigator.pop(context, null);
        Navigator.pop(
          context,
          VideoModel(
            title: _titleController.text,
            topic: _topicController.text,
            videoFile: File(videoPath),
            thumbnailFile: File(thumbnailPath),
          ),
        );
        return;
      },
      child: Scaffold(
        body: isVideoRecorded
            ? videoDetailScreen(context)
            : videoRecordingScreen(context),
      ),
    );
  }

  Widget videoRecordingScreen(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          child: _cameraPreviewWidget(),
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(
              color: controller != null && controller.value.isRecordingVideo
                  ? Colors.redAccent
                  : Colors.transparent,
              width: 3.0,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: LinearProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.kAppColor),
              value: videoDuration,
            ),
          ),
        ),
        Positioned.fill(
          top: MediaQuery.of(context).size.height / 2,
          left: MediaQuery.of(context).size.width / 5,
          child: Align(
            alignment: Alignment.center,
            child: _captureControlRowWidget(),
          ),
        ),
      ],
    );
  }

  Widget videoDetailScreen(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.file(
            File(thumbnailPath),
            fit: BoxFit.fill,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: ListView(
            reverse: true,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 50.0,
                    right: 50.0,
                    bottom: 50.0,
                    top: 20.0,
                  ),
                  child: Container(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    isVideoRecorded = false;
                                  });
                                },
                                child: Text(
                                  ButtonText.kRetake,
                                  style: GoogleFonts.balooDa(
                                    fontSize: 20.0,
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              HintText.kTopicHint,
                              style: GoogleFonts.balooDa(
                                color: AppColors.kAppColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          createTextFormField(
                            controller: _topicController,
                            hintText: HintText.kTopicHint,
                            obscureText: false,
                            keyboardType: TextInputType.name,
                            focusNode: _topicFocus,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (value) {
                              _topicFocus.unfocus();
                              FocusScope.of(context).requestFocus(_titleFocus);
                            },
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              HintText.kTitleHint,
                              style: GoogleFonts.balooDa(
                                color: AppColors.kAppColor,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          createTextFormField(
                            controller: _titleController,
                            hintText: HintText.kTitleHint,
                            obscureText: false,
                            keyboardType: TextInputType.name,
                            focusNode: _titleFocus,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.done,
                            onFieldSubmitted: (value) {
                              _topicFocus.unfocus();
                            },
                          ),
                          SizedBox(
                            height: 100.0,
                          ),
                          createButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget createButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kAppColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: MediaQuery.of(context).size.width / 1.15,
      child: ElevatedButton(
        style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
            elevation: MaterialStateProperty.all<double>(0),
            backgroundColor:
                MaterialStateProperty.all<Color>(AppColors.kAppColor)),
        onPressed: () {
          onValidate();
        },
        child: Text(
          ButtonText.kUpload,
          style: GoogleFonts.balooDa(
            fontSize: 16.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget createTextFormField({
    String hintText,
    TextEditingController controller,
    TextInputType keyboardType,
    bool obscureText,
    FocusNode focusNode,
    Function(String term) onFieldSubmitted,
    TextInputAction textInputAction,
    TextCapitalization textCapitalization,
  }) {
    return Container(
      height: 60.0,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.kAppColor),
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: TextFormField(
            validator: (value) =>
                value.isEmpty ? '$hintText cannot be blank' : null,
            textCapitalization: textCapitalization,
            textInputAction: textInputAction,
            autovalidateMode: _autovalidateMode,
            focusNode: focusNode,
            style: TextStyle(fontSize: 18.0),
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  // Display 'Loading' text when the camera is still loading.
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        HintText.kLoading,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w900,
        ),
      );
    }

    return CameraPreview(controller);
  }

  Widget _captureControlRowWidget() {
    if (cameras == null) {
      return Row();
    }

    return Row(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
            child: Container(
              width: 80.0,
              child: IconButton(
                onPressed: () {
                  _onMicSwitched(!controller.enableAudio);
                },
                icon: Icon(
                  controller.enableAudio ? Icons.mic : Icons.mic_off,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(seconds: 1),
          height: 60.0,
          width: 55.0,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.kAppColor),
            color: AppColors.kAppColor,
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          child: IconButton(
            color: Colors.white,
            icon: Icon(controller.value.isRecordingVideo
                ? Icons.stop
                : Icons.videocam),
            onPressed: controller != null && controller.value.isInitialized
                ? !controller.value.isRecordingVideo
                    ? _onRecordButtonPressed
                    : _onStopButtonPressed
                : null,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(
              width: 80.0,
              child: IconButton(
                onPressed: _onSwitchCamera,
                icon: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  Future<void> _onCameraSwitched(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        Fluttertoast.showToast(
          msg: controller.value.errorDescription,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onMicSwitched(bool mic) async {
    CameraDescription cameraDescription = cameras[selectedCameraIdx];
    if (controller != null) {
      await controller.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.high,
        enableAudio: mic);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) {
        setState(() {});
      }

      if (controller.value.hasError) {
        Fluttertoast.showToast(
          msg: controller.value.errorDescription,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  void _onSwitchCamera() {
    selectedCameraIdx =
        selectedCameraIdx < cameras.length - 1 ? selectedCameraIdx + 1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraIdx];

    _onCameraSwitched(selectedCamera);

    setState(() {
      selectedCameraIdx = selectedCameraIdx;
    });
  }

  void _onRecordButtonPressed() {
    _startVideoRecording().then((String filePath) {
      if (filePath != null) {
        Fluttertoast.showToast(
          msg: Messages.kRecordingStarted,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: AppColors.kAlertColor,
          textColor: Colors.white,
        );
        timer = Timer.periodic(Duration(seconds: 1), (period) {
          setState(() {
            videoDuration += 0.01;
          });
        });
      }
    });
  }

  void _onStopButtonPressed() async {
    setState(() {
      timer.cancel();
      videoDuration = 0.0;
    });
    await _stopVideoRecording().then((_) {
      if (mounted) setState(() {});
      Fluttertoast.showToast(
        msg: Messages.kVideoRecordedTo + videoPath,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.kAlertColor,
        textColor: Colors.white,
      );
    });
    final Directory extDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    final String thumbnailDirPath =
        '${extDir.path}/${AppStrings.kThumbnailFolder}';
    await Directory(thumbnailDirPath).create(recursive: true);
    String thumbnailFilePath = await Thumbnails.getThumbnail(
      thumbnailFolder: thumbnailDirPath,
      videoFile: videoPath,
      imageType: ThumbFormat.PNG,
      quality: 30,
    );
    setState(() {
      thumbnailPath = thumbnailFilePath;
      isVideoRecorded = true;
    });
  }

  Future<String> _startVideoRecording() async {
    if (!controller.value.isInitialized) {
      Fluttertoast.showToast(
        msg: Messages.kPleaseWait,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
      );

      return null;
    }

    if (controller.value.isRecordingVideo) {
      return null;
    }

    final Directory appDirectory = await getApplicationDocumentsDirectory();
    final String videoDirectory =
        '${appDirectory.path}/${AppStrings.kVideosFolder}';
    await Directory(videoDirectory).create(recursive: true);
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '$videoDirectory/$currentTime.mp4';

    try {
      await controller.startVideoRecording();
      videoPath = filePath;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }

    return filePath;
  }

  Future<void> _stopVideoRecording() async {
    try {
      var tempFile = await controller.stopVideoRecording();
      File us = File(tempFile.path);
      int _time = DateTime.now().millisecondsSinceEpoch;
      final Directory extDir = Platform.isAndroid
          ? await getExternalStorageDirectory()
          : await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/${AppStrings.kMoviesFolder}';
      await Directory(dirPath).create(recursive: true);
      final String filePath = '$dirPath/educa_$_time.mp4';

      setState(() {
        videoPath = filePath;
      });
      us.copySync(filePath);
    } catch (e) {
      print(e);
    }
  }

  void _showCameraException(CameraException e) {
    String errorText = 'Error: ${e.code}\nError Message: ${e.description}';
    print(errorText);

    Fluttertoast.showToast(
        msg: 'Error: ${e.code}\n${e.description}',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }
}
