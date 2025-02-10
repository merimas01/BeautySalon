import 'dart:convert';
import 'package:mobile_app/screens/rezervacije_page.dart';
import 'package:mobile_app/screens/success_page.dart';

import '../models/rezervacija.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

import 'cancel_page.dart';

class PayPalScreen extends StatefulWidget {
  final Rezervacija? lastRezervacija;
  final double totalAmount;

  PayPalScreen({super.key, this.lastRezervacija, required this.totalAmount});

  @override
  _PayPalScreenState createState() => _PayPalScreenState();
}

class _PayPalScreenState extends State<PayPalScreen> {
  bool isLoading = true;
  late final Rezervacija? _lastRezervacija;
  late final double _totalAmount;
  late WebViewController _controller;

  final String clientId =
      'AQM_z2U8Yn7sIuo19d1zQ3kkzT5kTJ_1zh6v-0uzrk8VTWpWNhY2hgKa8Au2UEeu2-yi5EtCFF5XksLq';
  final String clientSecret =
      'EGAe1oij9-LdTE1OYh2Q6FqmKUXq7hcUujiyMeaZhYEZ5YAuVm6G2BdgsKghhcBbFAaDkGjhxZV1YPq5';

  final String _paypalBaseUrl = 'https://api.sandbox.paypal.com'; // Sandbox URL

  @override
  void initState() {
    super.initState();

    _lastRezervacija = widget.lastRezervacija;
    _totalAmount = widget.totalAmount;

    _startPaymentProcess();
  }

  Future<void> _startPaymentProcess() async {
    try {
      final accessToken = await _getAccessToken();
      final orderUrl = await _createOrder(accessToken, _totalAmount);
      _redirectToPayPal(orderUrl);
    } catch (e) {
      print("Error during PayPal payment process: $e");
    }
  }

  Future<String> _getAccessToken() async {
    final response = await http.post(
      Uri.parse('$_paypalBaseUrl/v1/oauth2/token'),
      headers: {
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to obtain PayPal access token');
    }
  }

  Future<String> _createOrder(String accessToken, double total) async {
    final response = await http.post(
      Uri.parse('$_paypalBaseUrl/v2/checkout/orders'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'intent': 'CAPTURE',
        'purchase_units': [
          {
            'amount': {
              'currency_code': 'EUR',
              'value': total,
            },
          },
        ],
        'application_context': {
          'return_url': 'https://your-success-url.com',
          'cancel_url': 'https://your-cancel-url.com',
        }
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final approvalUrl =
          data['links'].firstWhere((link) => link['rel'] == 'approve')['href'];
      return approvalUrl;
    } else {
      throw Exception('Failed to create PayPal order');
    }
  }

  void _redirectToPayPal(String approvalUrl) {
    final webviewController = _createWebViewController(approvalUrl);

    Navigator.of(context).push(MaterialPageRoute(builder: (builder) {
      return Scaffold(
        body: WebViewWidget(
          controller: webviewController,
        ),
      );
    }));
  }

  WebViewController _createWebViewController(String approvalUrl) {
    return WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.startsWith('https://your-success-url.com')) {
              print("Payment successful");

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SuccessPage(
                    lastRezervacija: _lastRezervacija,
                  ),
                ),
              );
            }

            if (url.startsWith('https://your-cancel-url.com')) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const CancelPage(),
                ),
              );
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(approvalUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: (!isLoading)
                ? ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => RezervacijePage(), //parametri
                        ),
                      );
                    },
                    child: const Text("Nazad"),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ],
      ),
    );
  }
}
