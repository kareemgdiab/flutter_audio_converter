import 'package:flutter/material.dart';
import 'package:flutter_audio_converter/data/converter.dart';

class ConvertPopupButton extends StatelessWidget {
  final String path;
  ConvertPopupButton(this.path);
  @override
  Widget build(BuildContext context) {
    return new PopupMenuButton(
      icon: Icon(Icons.swap_horiz),
      itemBuilder: (BuildContext context) {
        return Converter.supportedFormats.map((Format format) {
          return new PopupMenuItem(
            child: new ListTile(
              leading: format.icon,
              title: Text(format.name),
              onTap: () {
                Converter converter = new Converter();
                converter.onProgressChanged((double progress) {
                  print("progress: $progress");
                });

                converter.enableOverwrite();

                converter
                    .aac(this.path)
                    .to()
                    .mp3("/storage/emulated/0/Music/this.mp3");
                print("convert button pressed");
              },
            ),
          );
        }).toList();
      },
    );
  }
}
