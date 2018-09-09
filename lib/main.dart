import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

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
  ScrollController scrollController = new ScrollController();
  Timer timer;
  VelocityTracker velocityTracker = new VelocityTracker();

  double offset = 0.0;
  double fixedHeight = 80.0;
  //pixels per second
  DateTime dragEndTime = new DateTime.now();
  double velocity = 0.0;


  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (velocity != 0) {
        setState(() {
          offset += velocity / 100;
          offset = math.min(
              fixedHeight * (items.length - 1), math.max(0.0, offset));
          int diffTime = DateTime.now().difference(dragEndTime).inMilliseconds;
          print(diffTime);
          velocity = velocity*(10000-diffTime)/10000;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new GestureDetector(

        behavior: HitTestBehavior.translucent,
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
        onVerticalDragEnd: (DragEndDetails dragEndDetails) {
//          print(dragEndDetails.velocity.pixelsPerSecond);
          setState(() {
            dragEndTime = DateTime.now();
            this.velocity = dragEndDetails.velocity.pixelsPerSecond.dy;
          });
        },
        onVerticalDragCancel: () => print("cancel"),
        onVerticalDragDown: (_) => print("down"),
        child: new Center(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          height: 1000.0,
//        mainAxisSize: MainAxisSize.max,
          child: new Stack(
            fit: StackFit.passthrough,
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

//  @override
//  void initState() {
//    super.initState();
////    scrollController.addListener(() {
//////      print(scrollController.offset);
//////      setState(() => offset = scrollController.offset);
////    });
//  }
//
//  bool _onNotification(notification) {
//    if (notification is OverscrollNotification) {
//      print(notification.overscroll);
//      setState(() {
//        offset -= notification.overscroll;
//      });
//    } else if (notification is ScrollUpdateNotification){
//      print(notification.metrics.pixels);
//      setState(() {
//        offset += notification.scrollDelta;
//      });
//      print( notification);
//    }
//    return true;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text("Chrome tabs"),
//      ),
//      body: NotificationListener(
//        onNotification: _onNotification,
//        child: CustomScrollView(
////          controller: scrollController,
//          slivers: <Widget>[
//            new SliverList(
//              delegate: new SliverChildBuilderDelegate(
//                (BuildContext context, int index) {
//                  bool isLast = index == items.length-1;
//                  double itemHeight;
//
//                  if (isLast) {
//                    itemHeight = 400.0;
//                  } else {
//                    double maxOffset = 150.0;
//                    int itemFromEnd = items.length - index;
//                    itemHeight = math.min(maxOffset, offset - itemFromEnd * maxOffset);
////                    if (offset > itemFromEnd * maxOffset) {
////                      itemHeight = maxOffset;
////                    } else {
////                      itemHeight = 0.0;
////                    }
////                    itemHeight = -offset;
//                  }
//                  return new Container(
//                    constraints:
//                        new BoxConstraints(maxHeight: 400.0),
//                    height: itemHeight,
//                    width: 300.0,
//                    child: new Column(
//                      children: <Widget>[
//                        new Text("$index"),
////                      new FlutterLogo(
////                        size: 30.0,
////                      ),
//                      ],
//                    ),
//                    decoration: new BoxDecoration(
//                      color: Colors.blue,
//                      border: new Border.all(color: Colors.red, width: 6.0),
//                    ),
//                  );
//                },
//                childCount: items.length,
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }


}
