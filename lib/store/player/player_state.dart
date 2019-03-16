import 'dart:io';

import 'package:flutter_audio_converter/store/player/player_actions.dart';


class PlayerState {
  bool isPlaying;
  String selectedFile;
  List<FileSystemEntity> files;

  PlayerState({this.selectedFile, this.files, this.isPlaying});

  PlayerState.initialState()
      : files = new List(),
        isPlaying = false;
}

// Reducer
PlayerState playerReducer(PlayerState state, dynamic action) {
  print('reducer action $action');
  if(action is PlayAction) {
    return new PlayerState(
      isPlaying: true,
      selectedFile: action.path
    );
  }

  if(action is PauseAction) {
    return new PlayerState(
      isPlaying: false,
      selectedFile: state.selectedFile,
      files: state.files
    );
  }

  return state;
}
