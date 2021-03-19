import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:educa/models/video_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:video_compress/video_compress.dart';

class VideoProvider extends ChangeNotifier {
  bool isSuccess = false;
  String message = '';

  Future<void> uploadData(VideoModel videoModel) async {
    String videoDownloadURL = '';
    String thumbnailDownloadURL = '';
    CollectionReference videos =
        FirebaseFirestore.instance.collection('videos');
    try {
      if (videoModel.videoFile != null) {
        MediaInfo mediaInfo = await VideoCompress.compressVideo(
          videoModel.videoFile.path,
          includeAudio: true,
          quality: VideoQuality.HighestQuality,
        );
        await firebase_storage.FirebaseStorage.instance
            .ref('videos/${videoModel.videoFile.path.split('/').last}')
            .putFile(mediaInfo.file)
            .then((value) async {
          await firebase_storage.FirebaseStorage.instance
              .ref(
                  'thumbnails/${videoModel.thumbnailFile.path.split('/').last}')
              .putFile(videoModel.thumbnailFile);

          videoDownloadURL = await firebase_storage.FirebaseStorage.instance
              .ref('videos/${videoModel.videoFile.path.split('/').last}')
              .getDownloadURL();
          thumbnailDownloadURL = await firebase_storage.FirebaseStorage.instance
              .ref(
                  'thumbnails/${videoModel.thumbnailFile.path.split('/').last}')
              .getDownloadURL();
          await videos.doc().set({
            'topic': videoModel.topic,
            'title': videoModel.title,
            'video_url': videoDownloadURL,
            'thumbnail_url': thumbnailDownloadURL
          }).then((value) {
            isSuccess = true;
            message = 'Your video uploaded Successfully';
            notifyListeners();
          }).catchError((error) => print("Failed to upload video: $error"));
        });
      } else {
        throw FirebaseException(plugin: 'no-file');
      }
    } on FirebaseException catch (e) {
      print(e);
      isSuccess = false;
      if (e.code == 'no-file') {
        message = 'No Video File uploaded!!';
      } else {
        message = 'Server Error, Please try again later.';
      }
      notifyListeners();
    }
  }
}
