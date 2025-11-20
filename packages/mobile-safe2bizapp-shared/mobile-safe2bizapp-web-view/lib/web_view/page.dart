import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

class WebViewParams {
  final String title;
  final String initialUrl;

  const WebViewParams({
    required this.title,
    required this.initialUrl,
  });
}

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class WebViewPage extends StatefulWidget {
  final WebViewParams params;

  const WebViewPage({
    Key? key,
    required this.params,
  }) : super(key: key);

  @override
  _WebViewPage createState() => _WebViewPage();
}

class _WebViewPage extends State<WebViewPage> {


  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}



// --------------------

// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewParams {
//   final String title;
//   final String initialUrl;

//   const WebViewParams({
//     required this.title,
//     required this.initialUrl,
//   });
// }

// class WebViewPage extends StatefulWidget {
//   final WebViewParams params;

//   const WebViewPage({
//     Key? key,
//     required this.params,
//   }) : super(key: key);

//   @override
//   _WebViewPage createState() => _WebViewPage();
// }

// class _WebViewPage extends State<WebViewPage> {
//   bool _isLoading = false;

//   @override
//   void initState() {
//     // Enable virtual display.
//     //  if (Platform.isAndroid) WebView.platform = AndroidWebView();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xff0A3987),
//         title: Text(
//           widget.params.title,
//         ),
//       ),
//       body: Stack(
//         alignment: Alignment.topCenter,
//         children: [
//           WebView(
//             initialUrl: widget.params.initialUrl,
//             javascriptMode: JavascriptMode.unrestricted,
//             onPageStarted: (data) {
//               setState(() {
//                 _isLoading = true;
//               });
//             },
//             onPageFinished: (data) {
//               setState(() {
//                 _isLoading = false;
//               });
//             },
//           ),
//           _isLoading
//               ? Positioned(
//                   child: Center(
//                     child: CircularProgressIndicator(color: Color(0xff0A3987)),
//                   ),
//                 ) //Lottie.asset('assets/animations/loading.json'))
//               : const SizedBox.shrink(),
//         ],
//       ),
//     );
//   }
// }
