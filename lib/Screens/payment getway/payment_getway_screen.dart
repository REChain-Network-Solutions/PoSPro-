import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:mobile_pos/generated/l10n.dart' as lang;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key, required this.planId, required this.businessId}) : super(key: key);

  final String planId;
  final String businessId;

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

String paymentUrl = 'https://modus.delus.site/payments-gateways/plan_id/business_id';
const String successUrl = 'order-status?status=success';
const String failureUrl = 'order-status?status=failed';

class _PaymentScreenState extends State<PaymentScreen> {
  late WebViewController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    paymentUrl = paymentUrl.replaceAll('plan_id', widget.planId).replaceAll('business_id', widget.businessId);

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            print('Hasina:'+url);
            if (url.contains(successUrl)) {
              print('This is susses');
              Navigator.pop(context,true);
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const SuccessScreen(),
              //     ));
              return;
            }
            if (url.contains(failureUrl)) {
              print('This is Field');
              Navigator.pop(context,false);
              // Navigator.pushReplacement(
              //     context,
              //     MaterialPageRoute(
              //       builder: (context) => const FailureScreen(),
              //     ));
              return;
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          lang.S.of(context).paymentGateway,
           // 'Payment Gateway'
        ),
      ),
      body: WebViewWidget(
        controller: controller,

        // initialUrl: paymentUrl,
        // javascriptMode: JavascriptMode.unrestricted,
        // onWebViewCreated: (WebViewController webViewController) {
        //   _controller = webViewController;
        // },
        // navigationDelegate: (NavigationRequest request) {
        //   if (request.url == successUrl) {
        //     // Handle success
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => SuccessScreen()),
        //     );
        //     return NavigationDecision.prevent;
        //   } else if (request.url == failureUrl) {
        //     // Handle failure
        //     Navigator.pushReplacement(
        //       context,
        //       MaterialPageRoute(builder: (context) => FailureScreen()),
        //     );
        //     return NavigationDecision.prevent;
        //   }
        //   return NavigationDecision.navigate;
        // },
      ),
    );
  }
}

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          lang.S.of(context).paymentSuccess,
           // 'Payment Success'
        ),
      ),
      body:  Center(
        child: Text(
            lang.S.of(context).paymentWasSuccessful,
           // 'Payment was successful!'
        ),
      ),
    );
  }
}

class FailureScreen extends StatelessWidget {
  const FailureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(
          lang.S.of(context).paymentFailed,
           // 'Payment Failed'
        ),
      ),
      body:  Center(
        child: Text(
          lang.S.of(context).paymentFailedPleaseTryAgain,
            //'Payment failed. Please try again.'
        ),
      ),
    );
  }
}
