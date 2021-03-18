import 'dart:io';

class VideoModel {
  String topic;
  String title;
  File videoFile;
  File thumbnailFile;
  VideoModel({this.title, this.topic, this.videoFile, this.thumbnailFile});
}
