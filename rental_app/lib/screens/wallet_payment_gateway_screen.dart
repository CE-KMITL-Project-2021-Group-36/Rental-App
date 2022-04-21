import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class PaymentGatewayScreen extends StatefulWidget {
  const PaymentGatewayScreen({Key? key, required this.ksherLink})
      : super(key: key);

  final String ksherLink;

  @override
  State<PaymentGatewayScreen> createState() => _PaymentGatewayScreenState();

  static const String routeName = '/wallet_payment_gateway';

  static Route route({required String ksherLink}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => PaymentGatewayScreen(
        ksherLink: ksherLink,
      ),
    );
  }
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  // late WebViewController _controller;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      javaScriptCanOpenWindowsAutomatically: true,
    ),
  );

  final InAppBrowser browser = InAppBrowser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 252, 68, 108),
        title: const Text('Ksher Payment Gateway'),
        leading: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            // _controller.clearCache();
            // CookieManager().clearCookies();
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        // child: WebView(
        //   javascriptMode: JavascriptMode.unrestricted,
        //   initialUrl: widget.ksherLink,
        //   onWebViewCreated: (_controller) {
        //     this._controller = _controller;
        //     // _controller.clearCache();
        //     // CookieManager().clearCookies();
        //   },
        // ),
        child: InAppWebView(
          initialUrlRequest: URLRequest(url: Uri.parse(widget.ksherLink)),
          initialOptions: options,
        ),
      ),
    );
  }
}
