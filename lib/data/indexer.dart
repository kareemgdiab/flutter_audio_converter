import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

class Indexer {
  Directory internalDir;
  Directory externalDir;

  RegExp _extRegex;

  Future<List<FileSystemEntity>> findFiles([List<String> extensions]) async {
    // assign internal directory to the emulated android path
    internalDir = await getExternalStorageDirectory();

    // create the regular expression to filter files with extensions
    if(extensions != null)
      _extRegex = RegExp(_regexFromExtension(extensions));

    // get external sdcard path
    String sdPath = _getSDCardPath();

    // assign external directory to the android sdcard path
    if (sdPath != null) externalDir = Directory.fromRawPath(Uint8List.fromList(sdPath.codeUnits));

    // query internal files and filter with expression
    List<FileSystemEntity> _files =
        await internalDir.list(recursive: true, followLinks: false).where((file) => _filesMatch(file)).toList();

    List<FileSystemEntity> _extFiles;

    // query files and filter from external storage if the path existed
    if(externalDir != null)
      _extFiles =
        await externalDir.list(recursive: true, followLinks: false).where((file) => _filesMatch(file)).toList();

    if(_extFiles != null)
      _files.addAll(_extFiles);

    return _files;
  }

  /// THIS WILL WORK ON ANDROID ONLY
  /// unfortunately android doesn't provide a direct way to access sdcards so it has to be grabbed manually
  /// and afaik only android got sdcards named with this convension
  /// C6YA-ABDA
  String _getSDCardPath() {
    String rootPath = "/storage/";
    Directory baseDir =
        Directory.fromRawPath(Uint8List.fromList(rootPath.codeUnits));
    RegExp regex = RegExp("[a-zA-Z0-9]+[-][a-zA-Z0-9]+");

    for (var fs in baseDir.listSync()) {
      if (regex.hasMatch(fs.path).toString() == "true") return fs.path;
    }

    return null;
  }

  bool _filesMatch(FileSystemEntity file) {
    if(_extRegex != null)
      return _extRegex.hasMatch(file.path).toString() == "true" ? true : false;
    
    return true;
  }

  /// given extensions list ["mp3", "3gp"]
  /// this produces regex /\.(mp3|3gp)/
  /// this will return true on any file that has .mp3 or .3gp extension
  String _regexFromExtension(List<String> ext) {
    return "\.(" + ext.join("|") + ")";
  }
}
