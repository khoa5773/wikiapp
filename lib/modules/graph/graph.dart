import 'dart:math';
import 'dart:ui';

import 'package:arrow_path/arrow_path.dart';
import 'package:duration/duration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wikiapp/components/PlatformScaffoldWidget.dart';
import 'package:wikiapp/components/PlatformTabBar.dart';
import 'package:wikiapp/helpers/findMax.dart';
import 'package:wikiapp/helpers/randomUrl.dart';
import 'package:wikiapp/modules/read/models/ReadState.dart';
import 'package:wikiapp/redux/IStore.dart';
import 'package:wikiapp/redux/store.dart';
import 'package:wikiapp/routers/routers.dart';

class _ViewModel {
  final readState;

  _ViewModel({@required this.readState});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          readState == other.readState;

  @override
  int get hashCode => readState.hashCode;
}

class GraphPage extends StatefulWidget {
  @required
  final session;

  GraphPage(this.session);

  @override
  _GraphState createState() => _GraphState(session);
}

class _GraphState extends State<GraphPage> {
  ReadSession session;
  List<Widget> listItems;

  void getLatestSession() {
    var lastSession;
    try {
      lastSession = store.state.readState.sessions.last;
    } catch (e) {
      lastSession = null;
    }
    setState(() {
      session = lastSession;
    });
  }

  _GraphState(this.session);

  @override
  void initState() {
    super.initState();
    if (session == null) {
      getLatestSession();
    }
  }

  List<Widget> generatelistItems() {
    List<Widget> res = [];
    int start = 1;
    session.readSessions.forEach((key, value) {
      var item = Column(
        children: [ListTile(
        title: Text('($start):$key', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo), overflow: TextOverflow.fade,),
        subtitle: Text(
            'Total time: ${printDuration(Duration(seconds: value), abbreviated: true)}', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
        onTap: () {
          Navigator.pushReplacementNamed(context, '/read', arguments: key);
        },
      ),
      Divider(color: Colors.cyan,)
        ]);
      res.add(item);
      start++;
    });
    return res;
  }

  Widget buildNullGraph(context, viewModel) {
    return PlatformScaffoldWidget(
      appBartitle: "Graph",
      bottomNavigationBar: PlatformTabBar(
        onTap: (index) {
          if (index == 3) {
            Navigator.pushReplacementNamed(context, routes[index],
                arguments: randomUrl());
            return;
          }
          if (index != 0) {
            Navigator.pushReplacementNamed(context, routes[index]);
          }
        },
        currentIndex: 0,
      ),
      child: Center(
        child: Text('You do not have any sessions'),
      ),
    );
  }

  Widget buildGraph(context, viewModel) {
    return PlatformScaffoldWidget(
        appBartitle: "Graph",
        bottomNavigationBar: PlatformTabBar(
          onTap: (index) {
            if (index == 3) {
              Navigator.pushReplacementNamed(context, routes[index], arguments: randomUrl());
              return ;
            }
            
            if (index != 0) {
              Navigator.pushReplacementNamed(context, routes[index]);
            }
          },
          currentIndex: 0,
        ),
        child: SafeArea(child: Column(
          children: <Widget>[
            Expanded(
                flex: 3,
                child: CustomPaint(
                  painter: DrawGraph(session),
                  size: Size(325, 600),
                )),
            Divider(color: Colors.redAccent, thickness: 5,),
            Expanded(
                child: Material(
              child: ListView(
                shrinkWrap: true,
                children: generatelistItems(),
              ),
            ))
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {},
      distinct: true,
      converter: (store) {
        return  _ViewModel(readState: store.state.readState);
      },
      builder: (context, viewModel) {
        return session == null
            ? buildNullGraph(context, viewModel)
            : buildGraph(context, viewModel);
      });
  }
}

class DrawGraph extends CustomPainter {
  double x;
  double y;
  double xLength;
  double yLength;
  final Paint _paint = Paint()
    ..color = Colors.indigo
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..strokeWidth = 3.0;
  ReadSession data;
  Map<String, String> nodeLabels = {};
  Map<String, Map> points;
  final TextPainter textPainter = TextPainter(
    textDirection: TextDirection.ltr,
  );
  final TextStyle textStyle = TextStyle(
      color: Colors.white.withAlpha(240),
      fontSize: 18,
      fontWeight: FontWeight.w900);

  DrawGraph(data) {
    this.data = data;
    this.x = 30;
    this.y = 30;
  }

  void generateNodeLabels() {
    int start = 1;
    data.readSessions.forEach((key, value) {
      nodeLabels[key] = start.toString();
      start++;
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    xLength = size.height - 100 - x - 10;
    yLength = size.height - y - 80;
    drawAxises(canvas, size);
    points = drawNodes(canvas, size);
    drawPaths(canvas, size);
  }

  Map<String, Map> drawNodes(Canvas canvas, Size size) {
    Map<String, Map> res = {};
    generateNodeLabels();
    int max = findMax(data.readSessions);
    int index = 0;
    int xSpace = 30;
    for (var key in data.readSessions.keys) {
      var value = data.readSessions[key];
      double xNode = x + index * xSpace;
      double yNode = size.height - y - (value / max * yLength);
      var labelX = TextSpan(
          text: nodeLabels[key], style: TextStyle(color: Colors.indigo));
      var labelPainterX = TextPainter(
        text: labelX,
        textDirection: TextDirection.ltr,
      );
      labelPainterX.layout(maxWidth: 20);
      labelPainterX.paint(canvas, Offset(xNode - 5, size.height - 20));

      var labelY = TextSpan(
          text: value.toString(), style: TextStyle(color: Colors.indigo));
      var labelPainterY = TextPainter(
        text: labelY,
        textDirection: TextDirection.ltr,
      );
      labelPainterY.layout(maxWidth: 20);
      labelPainterY.paint(canvas, Offset(x - 20, yNode - 8));
      index++;
      canvas.drawCircle(Offset(xNode, yNode), 2, _paint..color = Colors.red);
      res[key] = {'x': xNode, 'y': yNode};
    }
    return res;
  }

  void drawAxises(Canvas canvas, Size size) {
    var xPath = Path();
    var yPath = Path();

    yPath.moveTo(x, size.height - y);
    yPath.relativeLineTo(0, -size.height + 80);

    xPath.moveTo(x, size.height - y);
    xPath.relativeLineTo(size.width - 50, 0);

    xPath = ArrowPath.make(path: xPath);
    yPath = ArrowPath.make(path: yPath);

    var textSpanX = TextSpan(
      text: 'URL',
      style: TextStyle(color: Colors.indigo),
    );

    var textSpanY = TextSpan(
      text: 'Time(s)',
      style: TextStyle(color: Colors.indigo),
    );

    canvas.drawPath(xPath, _paint..color = Colors.indigo);
    canvas.drawPath(yPath, _paint..color = Colors.indigo);

    var textPainterX = TextPainter(
      text: textSpanX,
      textDirection: TextDirection.ltr,
    );
    var textPainterY = TextPainter(
      text: textSpanY,
      textDirection: TextDirection.ltr,
    );

    textPainterX.layout(maxWidth: 50);
    textPainterX.paint(canvas, Offset(size.width - 15, size.height - 37));
    textPainterY.layout(maxWidth: 60);
    textPainterY.paint(canvas, Offset(10, 30));
  }

  void drawPaths(Canvas canvas, Size size) {
    var urls = data.urls;
    Paint _pathPaint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = 2;
    for (var i = 0; i < urls.length - 1; i++) {
      if (urls[i] == urls[i + 1]) {
        continue;
      }
      var path = Path();
      path.moveTo(points[urls[i]]['x'], points[urls[i]]['y']);
      var dx = points[urls[i + 1]]['x'] - points[urls[i]]['x'];
      var dy = points[urls[i + 1]]['y'] - points[urls[i]]['y'];
      path.relativeLineTo(dx, dy);
      path = ArrowPath.make(path: path, tipLength: 8, tipAngle: pi * 0.15);
      _pathPaint..color = Colors.teal;
      canvas.drawPath(path, _pathPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
