

import 'package:flutter_audio_converter/providers/audio_player.dart';
import 'package:flutter_audio_converter/store/player/player_state.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

Player player = new Player();

class PlayAction {
  final String path;
  PlayAction({@required this.path});
}

class PauseAction {
  PauseAction();
}


ThunkAction<PlayerState> play(String path) {
  print('playing: $path');
  return (Store<PlayerState> store) async {
    bool result = await player.play(path);
    if(result) {
      store.dispatch(new PlayAction(path: path));
    }
  };
}

ThunkAction<PlayerState> pause() {
  print('pausing...');
  return (Store<PlayerState> store) async {
    bool result = await player.pause();
    if(result) {
      store.dispatch(new PauseAction());
    }
  };
}