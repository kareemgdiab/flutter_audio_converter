import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_audio_converter/data/converter.dart';
import 'package:flutter_audio_converter/data/indexer.dart';
import 'package:flutter_audio_converter/providers/audio_player.dart';
import 'package:flutter_audio_converter/store/player/player_actions.dart';
import 'package:flutter_audio_converter/store/player/player_state.dart';
import 'package:flutter_audio_converter/widgets/media_item.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';

class MediaListWidgetState extends State<MediaListWidget> {
  final List<FileSystemEntity> _files = new List();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  final Player _player = new Player();
  bool _isPlaying = false;
  String _longTappedRow;

  String error;

  @override
  void initState() {
    super.initState();
    _getMediaFiles();
    print('init state');
  }

  @override
  void didUpdateWidget(MediaListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('did update');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _buildMusicList(),
      ),
    );
  }

  Widget _buildMusicList() {
    if (error != null)
      return Text(
        error,
        style: TextStyle(color: Colors.red, fontSize: 18.0),
      );

    if (_files.length < 1) {
      return CircularProgressIndicator();
    } else {
      return ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _files.length * 2,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;

          return _buildRow(_files[index]);
        },
      );
    }
  }

  Widget _buildRow(FileSystemEntity file) {
    return new MediaItem(file.path);
  }

  // void _pushSaved() {
  //   Navigator.of(context).push(new MaterialPageRoute<void>(
  //     builder: (BuildContext context) {
  //       return new Scaffold(
  //         appBar: new AppBar(
  //           title: const Text('Saved Suggestions'),
  //         ),
  //         body: new Container(),
  //       );
  //     },
  //   ));
  // }

  void _getMediaFiles() async {
    Indexer indexer = new Indexer();

    List<FileSystemEntity> files = new List();

    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    Map<PermissionGroup, PermissionStatus> permissions;

    if (permission == PermissionStatus.denied) {
      permissions = await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
    }

    if (permissions != null) permission = permissions[PermissionGroup.storage];

    if (permission == PermissionStatus.granted) {
      try {
        files = await indexer.findFiles(["m4a"]);
      } on Exception {
        setState(() {
          error = "Please check storage permissions";
        });
      }

      if (this.mounted) {
        print("setting state");
        setState(() {
          _files.addAll(files);
        });
      } else {
        print('files loaded but widget is not mounted');
      }
    } else {
      setState(() {
        error = "Permission not granted!";
      });
    }
  }
}

class MediaListWidget extends StatefulWidget {
  @override
  MediaListWidgetState createState() => new MediaListWidgetState();
}
