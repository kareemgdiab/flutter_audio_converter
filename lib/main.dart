import 'package:flutter/material.dart';
import 'package:flutter_audio_converter/store/player/player_state.dart';
import 'package:flutter_audio_converter/store/store.dart';
import 'package:flutter_audio_converter/widgets/media_list_widget.dart';
import 'package:flutter_redux/flutter_redux.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new StoreProvider<PlayerState>(
      store: store,
      child: new MaterialApp(
        // title: 'Audio Converter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(title: 'Audio Converter'),
      )
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Audio Converter'),
        // actions: <Widget>[
        //   new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved),
        // ],
      ),
      body: MediaListWidget(),
    );
  }
}
