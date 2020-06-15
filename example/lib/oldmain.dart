import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shareintent/shareintent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'ShareIntent Demo',
        theme: ThemeData(
            primarySwatch: Colors.orange,
            brightness: Brightness.dark
        ),
        home: MyAppHomePage(title: 'ShareIntent Demo HomePage')
    );
  }
}

class MyAppHomePage extends StatefulWidget {
  MyAppHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyAppHomePage> {
  String _sharedText = 'Unknown';
  final _shareIntent = ShareIntent();
  StreamSubscription<String> _shareIntentSubscription;

  @override
  void initState() {
    super.initState();

    _shareIntentSubscription = _shareIntent.onShareIntent.listen(
            (String value) {
              setState(() {
                _sharedText = value;
                // TODO: this seems to work on initial share when the app is not in memory but not when it is, find out why
              });
            });

    initShareIntent();
  }

  @override
  void dispose() {
    _shareIntentSubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initShareIntent() async {
    String sharedText;
    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      sharedText = await _shareIntent.getSharedContent();
//    } on PlatformException {
//      sharedText = 'Failed to get platform version.';
//    }

    await _shareIntent.getSharedContent().then((String value) {
      setState(() {
        _sharedText = value;
      });
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('ShareIntent Demo'),
        ),
        body: Center(
          child: Text('Link: $_sharedText\n'),
        ),
      ),
    );
  }
}
