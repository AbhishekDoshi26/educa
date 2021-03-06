import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:educa/constants.dart';

import 'package:educa/models/video_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:video_compress/video_compress.dart';

class VideoProvider extends ChangeNotifier {
  bool isSuccess = false;
  String message = '';

  //Function to upload video
  Future<void> uploadData(VideoModel videoModel) async {
    String videoDownloadURL = '';
    String thumbnailDownloadURL = '';
    CollectionReference videos =
        FirebaseFirestore.instance.collection('videos');
    try {
      if (videoModel.videoFile != null) {
        //Compresses the video file and stores it at a new folder where the video is present.
        MediaInfo mediaInfo = await VideoCompress.compressVideo(
          videoModel.videoFile.path,
          includeAudio: true,
          quality: VideoQuality.HighestQuality,
        );

        //After the video is compressed, store the compressed video in firestore
        //with the ORIGINAL VIDEO NAME and not the compressed video name.
        await firebase_storage.FirebaseStorage.instance
            .ref('videos/${videoModel.videoFile.path.split('/').last}')
            .putFile(mediaInfo.file)
            .then((value) async {
          //Once video is uploaded, also upload the thumbnail.
          //This thumbnail is shown on home page
          await firebase_storage.FirebaseStorage.instance
              .ref(
                  'thumbnails/${videoModel.thumbnailFile.path.split('/').last}')
              .putFile(videoModel.thumbnailFile);
          //Get video download url
          videoDownloadURL = await firebase_storage.FirebaseStorage.instance
              .ref('videos/${videoModel.videoFile.path.split('/').last}')
              .getDownloadURL();

          //Get thumbnail download url
          thumbnailDownloadURL = await firebase_storage.FirebaseStorage.instance
              .ref(
                  'thumbnails/${videoModel.thumbnailFile.path.split('/').last}')
              .getDownloadURL();

          //Store video details and URL in firestore.
          await videos.doc().set({
            'topic': videoModel.topic,
            'title': videoModel.title,
            'video_url': videoDownloadURL,
            'thumbnail_url': thumbnailDownloadURL
          }).then((value) {
            isSuccess = true;
            message = Messages.kVideoUploaded;
            notifyListeners();
          }).catchError((error) {
            isSuccess = false;
            message = Messages.kServerError;
            notifyListeners();
          });
        });
      } else {
        throw FirebaseException(
          plugin: 'no-file',
          message: Messages.kNoVideoUploaded,
        );
      }
    } on FirebaseException catch (e) {
      print(e);
      isSuccess = false;
      if (e.code == 'no-file') {
        message = Messages.kNoVideoUploaded;
      } else {
        message = Messages.kServerError;
      }
      notifyListeners();
    }
  }
}
