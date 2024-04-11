import 'package:dua/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({super.key, required this.url});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
            'assets/images/logoi.png',
            width: 225
        ),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
      ),
      body: Stack(
        children:  [
          WebViewWidget(
            controller: WebViewController()
              ..setJavaScriptMode(JavaScriptMode.disabled)
              ..setBackgroundColor(const Color(0x00000000))
              ..setNavigationDelegate(
                NavigationDelegate(
                    onPageFinished: (String url) {
                      // setState(() {
                      //   _isLoading = false;
                      // });
                    },
                    onNavigationRequest: (NavigationRequest request) {
                      if (request.url.startsWith('https://play.google.com')) {
                        // Open the URL in the browser.
                        return NavigationDecision.prevent;
                      }
                      return NavigationDecision.navigate;
                    }
                ),
              )
              ..loadRequest(Uri.parse(widget.url)),
          ),
          FutureBuilder(
              future: Future.delayed(Duration(seconds: 3)),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              }
          )
        ],
      ),
    );
  }
}