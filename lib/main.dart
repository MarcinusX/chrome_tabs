import 'dart:math' as math;

import 'package:flutter/material.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> items = new List.generate(20, (i) => i);

  double offset = 0.0;
  double fixedHeight = 80.0;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new GestureDetector(
        onVerticalDragStart: (DragStartDetails details) {
          print("Start: ${details.globalPosition.dy}");
        },
        onVerticalDragUpdate: (DragUpdateDetails details) {
//          print(details.delta.dy);
          setState(() {
            offset += details.delta.dy;
            offset = math.min(
                fixedHeight * (items.length - 1), math.max(0.0, offset));
            print(offset);
          });
        },
        onVerticalDragEnd: (_) => print("end"),
        onVerticalDragCancel: () => print("cancel"),
        onVerticalDragDown: (_) => print("down"),
        child: new Center(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          height: 1000.0,
//        mainAxisSize: MainAxisSize.max,
          child: new Stack(
            fit: StackFit.loose,
            children: items
                .map((item) {
              int index = items.indexOf(item);
              double subtract = index * fixedHeight;
              double padding = offset - subtract;
              padding = math.max(padding, 0.0);
              return new Transform.translate(
                offset: new Offset(0.0, padding),
//                    padding: new EdgeInsets.only(top: padding),
                child: new Container(
                  constraints: new BoxConstraints(
                      minHeight: 400.0, maxHeight: 400.0),
                  height: 400.0,
                  width: 300.0,
                  child: new Column(
                    children: <Widget>[
                      new Text("$index"),
                      new FlutterLogo(
                        size: 30.0,
                      ),
                    ],
                  ),
                  decoration: new BoxDecoration(
                    color: Colors.blue,
                    border: new Border.all(color: Colors.red, width: 6.0),
                  ),
                ),
              );
            })
                .toList()
                .reversed
                .toList(),
          ),
        ),
      ),
    );
  }
}
