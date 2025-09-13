import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:gweatherforecast/resource/service/subscription_service.dart';

class VerifyPage extends StatefulWidget {
  final String token;
  const VerifyPage({super.key, required this.token});

  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  final _service = SubscriptionService();
  bool _isLoading = true;
  bool _success = false;

  @override
  void initState() {
    super.initState();
    _verify();
  }

  Future<void> _verify() async {
    try {
      final success = await _service.confirmEmail(widget.token);
      setState(() {
        _success = success;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _success = false;
        _isLoading = false;
      });
    }
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
      // ép browser URL về "/"
      html.window.history.pushState(null, 'Home', '/');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _success
            ? const Text(
                "Email verified successfully!",
                style: TextStyle(fontSize: 18, color: Colors.green),
              )
            : const Text(
                "Invalid or expired link.",
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
      ),
    );
  }
}
