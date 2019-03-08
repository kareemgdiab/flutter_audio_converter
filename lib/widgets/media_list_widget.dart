import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_audio_converter/data/indexer.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaListWidgetState extends State<MediaListWidget> {
  final List<FileSystemEntity> _files = new List();
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
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
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Audio Converter'),
        // actions: <Widget>[
        //   new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        // ],
      ),
      body: Center(
        child: Center(
          child: _buildMusicList(),
        ),
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
        padding: const EdgeInsets.all(16.0),
        itemCount: _files.length,
        itemBuilder: (context, i) {
          if (i.isOdd) return Divider();

          final index = i ~/ 2;

          return _buildRow(_files[index]);
        },
      );
    }
  }

  Widget _buildMusicListFB() {
    return new FutureBuilder(
      future: _getMediaFilesFuture(),
      builder: (BuildContext context, AsyncSnapshot snap) {
        if (snap.hasData && snap.data != null) {
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: _files.length,
            itemBuilder: (context, i) {
              if (i.isOdd) return Divider();

              final index = i ~/ 2;

              return _buildRow(_files[index]);
            },
          );
        } else {
          return new CircularProgressIndicator();
        }
      },
    );
  }

  Widget _buildRow(FileSystemEntity file) {
    return ListTile(
      title: Text(
        _getPostfix(file.path),
        style: _biggerFont,
      ),
      trailing: new Icon(Icons.play_arrow),
      onTap: () {
        setState(() {});
      },
    );
  }

  String _getPostfix(String path) {
    return path.split("/").last;
  }

  void _pushSaved() {
    Navigator.of(context).push(new MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return new Scaffold(
          appBar: new AppBar(
            title: const Text('Saved Suggestions'),
          ),
          body: new Container(),
        );
      },
    ));
  }

  Future<List<FileSystemEntity>> _getMediaFilesFuture() async {
    Indexer indexer = new Indexer();
    return await indexer.findFiles(["m4a"]);
  }

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

    permission = permissions[PermissionGroup.storage];

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
