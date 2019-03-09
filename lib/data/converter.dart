import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';

class Format {
  String name;
  Icon icon;

  Format({@required this.name, this.icon});
}

class Converter {
  static List<Format> supportedFormats = [
    new Format(name: "AAC", icon: const Icon(Icons.audiotrack))
  ];

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  String _command = "-i ";
  int finalSize = 0;
  bool _isTo = false;

  Converter aac(String path) {
    _command += "$path ";
    _isTo = true;
    return this;
  }

  Converter to() {
    _isTo = true;
    return this;
  }

  Converter mp3(String path) {
    if(_isTo) {
      _command += "-f mp2 $path";
      _flutterFFmpeg.execute(_command)
        .then((rc) => print("FFmpeg process exited with rc $rc"));
    }

    _command += "$path ";
    return this;
  }

  void enableOverwrite() {
    _command = "-y " + _command;
  }

  void onProgressChanged(Function progress) {
    _enableStatistics((int time, int size, double bitrate, double speed, int videoFrameNumber, double videoQuality, double videoFps) {
      if(finalSize != 0) {
        double percentage = (size / finalSize) * 100;
        progress(percentage);
        if(percentage == 100) finalSize = 0;
        return;
      }
      progress(0.0);
      finalSize = size;
    });
  }

  void _enableStatistics(Function statsCallback) {
    _flutterFFmpeg.enableStatisticsCallback(statsCallback);
  }
  
  void listExternals() {
    _flutterFFmpeg.getExternalLibraries().then((packageList) {
     packageList.forEach((value) => print("External library: $value"));
    });
  }
}