import 'package:flutter/material.dart';
import 'package:wikiapp/modules/graph/graph.dart';
import 'package:wikiapp/modules/history/history.dart';
import 'package:wikiapp/modules/notebook/notebook.dart';
import 'package:wikiapp/modules/read/read.dart';

Map<int,String> routes =  {0: '/graph', 1: '/notebook', 2: '/history', 3: '/read'};

Route onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/notebook':
      return  MaterialPageRoute(
        builder: (context) =>  NotebookPage(),
        settings: settings,
      );
      break;
    case '/read':
      return  MaterialPageRoute(
        builder: (context) =>  ReadPage(settings.arguments),
        settings: settings,
      );
      break;
    case '/graph':
      return  MaterialPageRoute(
        builder: (context) =>  GraphPage(settings.arguments),
        settings: settings,
      );
      break;
    case '/history':
      return  MaterialPageRoute(
        builder: (context) =>  HistoryPage(),
        settings: settings,
      );
      break;
    default:
      return  MaterialPageRoute(
        builder: (context) =>  Container(),
        settings: settings,
      );
      break;
  }
}
