import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget.ksherLink,
        ),
      ),
    );
  }
}
