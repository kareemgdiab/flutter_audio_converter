// external packs
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:flutter_audio_converter/store/player/player_actions.dart';
import 'package:flutter_audio_converter/store/player/player_state.dart';
import 'package:flutter_audio_converter/widgets/convert_to_menu.dart';
import 'package:flutter_audio_converter/data/utils.dart';

class MediaItem extends StatefulWidget {
  final String path;

  MediaItem(this.path);

  @override
  _MediaItemState createState() => _MediaItemState();
}

class _MediaItemState extends State<MediaItem> {
  String _longTappedRow;
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);
  _MediaItemState();

  @override
  Widget build(BuildContext context) {
    bool isLongTapped = this.widget.path == _longTappedRow;

    return new ListTile(
      title: Text(
        getLastAfter(symbol: "/", str: this.widget.path),
        style: _biggerFont,
        overflow: isLongTapped ? TextOverflow.clip : TextOverflow.ellipsis,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new StoreConnector<PlayerState, Store<PlayerState>>(
            converter: (store) {
              return store;
            },
            builder: (context, Store<PlayerState> store) {
              PlayerState state = store.state;

              bool isPlaying =
                  state.isPlaying && state.selectedFile == this.widget.path;

              return new IconButton(
                icon: new Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                onPressed: () async {
                  // tapped this is the same this currently playing
                  if (isPlaying) {
                    return store.dispatch(pause());
                  }

                  return store.dispatch(play(this.widget.path));
                },
              );
            },
          ),
          new ConvertPopupButton(this.widget.path)
        ],
      ),
      onLongPress: () {
        setState(() {
          _longTappedRow = this.widget.path;
        });
      },
      onTap: () async {},
    );
  }
}