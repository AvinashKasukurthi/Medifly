import 'package:flutter/material.dart';
import 'package:medifly/PaymentConts.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({@required this.amount,this.orderid});
  final String amount;
  final String orderid;

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  WebViewController _webController;

  String _loadHTML() {
    return "<html> <body onload ='document.f.submit();'> <form id ='f' name='f' method='post' action ='$PAYMENT_URL'> <input type='hidden' name='orderID' value='${widget.orderid}' />" +
        "<input type='hidden' name='custID' value='${ORDER_DATA["custID"]}' />" +
        "<input type='hidden' name='custEmail' value='${ORDER_DATA["custEmail"]}' />" +
        "<input type='hidden' name='custPhone' value='${ORDER_DATA["custPhone"]}' />" +
        "<input type='hidden' name='amount' value= '${widget.amount}' />" +
        "</form> </body> </html>";
  }

  @override
  void dispose() {
    _webController = null;
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webController = controller;
              _webController.loadUrl(
                  new Uri.dataFromString(_loadHTML(), mimeType: 'text/html')
                      .toString());
            },
          ),
        ),
      ),
    );
  }
}
