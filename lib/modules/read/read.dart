import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:wikiapp/components/PlatformDialog.dart';
import 'package:wikiapp/components/PlatformTextField.dart';
import 'package:wikiapp/modules/notebook/redux/action.dart';
import 'package:wikiapp/modules/read/models/ReadState.dart';
import 'package:wikiapp/modules/read/redux/action.dart';
import 'package:wikiapp/redux/IStore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wikiapp/redux/store.dart';
import 'package:webview_flutter/webview_flutter.dart';

class _ViewModel {
  final readState;
  final notebookState;

  _ViewModel(
      {@required this.readState,
      @required this.notebookState});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          readState == other.readState &&
          notebookState == other.notebookState;

  @override
  int get hashCode => readState.hashCode ^ notebookState.hashCode;
}

class ReadPage extends StatefulWidget {
  @required
  final String url;

  ReadPage(this.url);

  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  String initialUrl;
  String currentUrl;
  Map tracktimeUrls;
  Timer sessionTimer;
  Timer urlTimer;
  int sessionTime = 0;
  List<String> urls;
  bool isSession = true;
  TextEditingController textController = TextEditingController();
  Completer<WebViewController> _controller = Completer<WebViewController>();
  void onBack() {}

  @override
  void initState() {
    super.initState();
    ReadSession lastSession = getLastSession();
    if (lastSession != null &&
        lastSession.endAt
            .isAfter(DateTime.now().subtract(Duration(hours: 1)))) {
      isSession = false;
    }
    initialUrl = widget.url;
    urls = [initialUrl];
    currentUrl = initialUrl;
    tracktimeUrls = {
      initialUrl: 0,
    };
  }

  @override
  void dispose() {
    sessionTimer.cancel();
    urlTimer.cancel();
    saveSession();
    super.dispose();
  }

  void trackReadSessionTime(Timer timer) {
    setState(() {
      sessionTime += 1;
    });
  }

  getLastSession() {
    ReadSession lastSession;
    try {
      lastSession = store.state.readState.sessions.last;
    } catch (e) {
      lastSession = null;
    }
    return lastSession;
  }

  tracktimeUrl(Timer timer) {
    setState(() {
      if (tracktimeUrls[currentUrl] == null) {
        tracktimeUrls[currentUrl] = 0;
      }
      tracktimeUrls[currentUrl] += 1;
    });
  }

  saveSession() {
    store.dispatch(SaveReadSession(
        readSessions: tracktimeUrls,
        urls: urls,
        isSession: isSession));
  }

  saveNotebook(url, note) {
    store.dispatch(SaveNotebook(url: url, note: note));
  }

  Future _showDialog(context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return PlatformDialog(
            textField: Card(
              child: PlatformTextField(
                controller: textController,
              ),
            ),
            onNoPressed: () {
              Navigator.of(context).pop();
            },
            onYesPressed: () {
              var note = textController.text;
              saveNotebook(currentUrl, note);
              setState(() {
                textController = TextEditingController(text: '');
              });
              Navigator.of(context).pop();
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {},
      converter: (store) {
        return  _ViewModel(
          readState: store.state.readState,
          notebookState: store.state.notebookState,
        );
      },
      builder: (context, viewModel) {
        return 
          Scaffold(
            appBar: AppBar(
              title: const Text('Wikipedia Explorer'),
              actions: <Widget>[
                NavigationControls(_controller.future),
              ],
            ),
            body: Builder(
              builder: (context) => WebView(
                initialUrl: initialUrl,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controller.complete(webViewController);
                  sessionTimer =  Timer.periodic(
                      const Duration(seconds: 1), trackReadSessionTime);
                  urlTimer =  Timer.periodic(
                      const Duration(seconds: 1), tracktimeUrl);
                },
                navigationDelegate: (NavigationRequest request) {
                  if (!request.url
                      .startsWith('https://en.m.wikipedia.org/wiki')) {
                    print('blocking navigation to $request}');
                    if (urlTimer.isActive) {
                      urlTimer.cancel();
                    }
                    launch(request.url);
                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageFinished: (String url) {
                  setState(() {
                    currentUrl = url;
                    if (urls.length > 0 && urls.last != url) {
                      urls.add(url);
                    }
                  });
                  if (!urlTimer.isActive) {
                    urlTimer =  Timer.periodic(
                        const Duration(seconds: 1), tracktimeUrl);
                  }
                },
              ),
            ),
            floatingActionButton: _bookmarkButton(),
          );
      },
    );
  }

  _bookmarkButton() {
    return FutureBuilder<WebViewController>(
      future: _controller.future,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> controller) {
        if (controller.hasData) {
          return FloatingActionButton(
            onPressed: () async {
              final String url = await controller.data.currentUrl();
              await _showDialog(context);
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text('Saved $url')),
              );
              setState(() {
                textController = TextEditingController(text: '');
              });
            },
            child: Icon(Icons.favorite),
          );
        }
        return Container();
      },
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              color: Colors.indigo,
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: !webViewReady
                  ? null
                  : () => navigate(context, controller, goBack: true),
            ),
            IconButton(
              color: Colors.indigo,
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: !webViewReady
                  ? null
                  : () => navigate(context, controller, goBack: false),
            ),
            IconButton(
              color: Colors.indigo,
              icon: const Icon(Icons.refresh),
              onPressed: !webViewReady ? null : () => controller.reload(),
            ),
            IconButton(
              color: Colors.indigo,
              icon: const Icon(Icons.exit_to_app),
              onPressed: () async {
                await Future.delayed(Duration(seconds: 1));
                return Navigator.pushReplacementNamed(context, '/graph',
                    arguments: null);
              },
            ),
          ],
        );
      },
    );
  }

  navigate(BuildContext context, WebViewController controller,
      {bool goBack: false}) async {
    bool canNavigate =
        goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
            content: Text("No ${goBack ? 'back' : 'forward'} history item")),
      );
    }
  }
}
