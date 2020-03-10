import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:wikiapp/components/PlatformScaffoldWidget.dart';
import 'package:wikiapp/components/PlatformTabBar.dart';
import 'package:wikiapp/helpers/randomUrl.dart';
import 'package:wikiapp/redux/store.dart';
import '../read/models/ReadState.dart';
import 'package:wikiapp/redux/IStore.dart';
import 'package:wikiapp/routers/routers.dart';
import 'package:duration/duration.dart';

class _ViewModel {
  final readState;

  _ViewModel(
      {@required this.readState});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          readState == other.readState;

  @override
  int get hashCode => readState.hashCode;
}

class HistoryPage extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<HistoryPage> {
  List<Widget> listItems;

  List<Widget> generatelistItems(List<ReadSession> sessions) {
    List<Widget> res = [];
    for (var session in sessions) {
      var totalTime = 0;
      session.readSessions.forEach((k, v) => totalTime += v);
      var totalUrls = session.readSessions.length;
      var totalTimeString =
          printDuration(Duration(seconds: totalTime), abbreviated: true);
      var item = Column(
          children: <Widget>[ListTile(
            leading: Icon(
              CupertinoIcons.time_solid,
              color: Colors.blue,
              size: 40,
            ),
            title: Text(
              DateFormat.jm()
                  .add_yMMMd()
                  .format(session.endAt.toLocal())
                  .toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(totalTimeString.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  totalUrls.toString(),
                  style: TextStyle(fontSize: 18, color: Colors.blue, fontWeight: FontWeight.bold),
                ),
                Icon(
                  CupertinoIcons.news_solid,
                  color: Colors.blue,
                ),
              ],
            ),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/graph',
                  arguments: session);
            },
          ),
          Divider(color: Colors.cyanAccent,)
          ]
          );
      res.add(item);
    }
    return res;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      listItems = generatelistItems(store.state.readState.sessions);
    });
  }

  Widget buildNullHistory(context, viewModel) {
    return PlatformScaffoldWidget(
      appBartitle: "History",
      bottomNavigationBar: PlatformTabBar(
        onTap: (index) {
          if (index == 3) {
            Navigator.pushReplacementNamed(context, routes[index],
                arguments: randomUrl());
            return;
          }
          if (index != 2) {
            Navigator.pushReplacementNamed(context, routes[index]);
          }
        },
        currentIndex: 2,
      ),
      child: Center(
        child: Text('You do not have any sessions'),
      ),
    );
  }

  Widget buildNormalHistory(context, viewModel) {
    return PlatformScaffoldWidget(
        appBartitle: "History",
        bottomNavigationBar: PlatformTabBar(
          onTap: (index) {
            if (index == 3) {
              Navigator.pushReplacementNamed(context, routes[index],
                  arguments: randomUrl());
              return;
            }
            if (index != 2) {
              Navigator.pushReplacementNamed(context, routes[index]);
            }
          },
          currentIndex: 2,
        ),
        child: SafeArea(
            child: Column(children: <Widget>[
          Container(
            child: Material(
              child: ListView(
                children: listItems,
                shrinkWrap: true,
              ),
            ),
          )
        ])));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {},
      distinct: true,
      converter: (store) {
        return _ViewModel(
            readState: store.state.readState);
      },
      builder: (context, viewModel) {
        return listItems.length == 0
            ? buildNullHistory(context, viewModel)
            : buildNormalHistory(context, viewModel);
      },
    );
  }
}
