import 'package:audioplayers/audioplayers.dart';

class Player {
  final AudioPlayer _audioPlayer = new AudioPlayer();
  String currentlyPlaying;
  bool isPlaying = false;

  play(String path) async {
    // resume if we already selecting the same file 
    if(currentlyPlaying == path) {
      return await resume();
    }

    _audioPlayer.stop();
    
    int result = await _audioPlayer.play(path);
    if(result == 1) {
      currentlyPlaying = path;
      isPlaying = true;
    }
    print("play result: $result");
    return result == 1? true : false;
  }

  pause() async {
    int result = await _audioPlayer.pause();
    if(result == 1) {
      isPlaying = false;
    }
    print("pause result: $result");
    return result == 1? true : false;
  }

  stop() async {
    int result = await _audioPlayer.stop();
    print("stop result: $result");
    if(result == 1) {
      isPlaying = false;
      currentlyPlaying = null;
    }
  }

  resume() async {
    int result = await _audioPlayer.resume();
    print("resume result: $result");
    if(result == 1) {
      isPlaying = true;
    }
    return result == 1? true : false;
  }
}