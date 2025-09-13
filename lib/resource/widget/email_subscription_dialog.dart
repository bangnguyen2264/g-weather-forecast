import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gweatherforecast/presentation/subscription_provider.dart';
import 'package:provider/provider.dart';

class EmailSubscriptionDialog extends StatefulWidget {
  const EmailSubscriptionDialog({super.key});

  @override
  State<EmailSubscriptionDialog> createState() => _EmailSubscriptionDialogState();
}

class _EmailSubscriptionDialogState extends State<EmailSubscriptionDialog> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleSubscribe(SubscriptionProvider subscription) async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await subscription.subscribe(_emailController.text.trim());
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification email sent to ${_emailController.text.trim()}")),
          );
        }
      } catch (_) {
        // lỗi đã được set trong provider
      }
    }
  }

  Future<void> _handleUnsubscribe(SubscriptionProvider subscription) async {
    try {
      await subscription.unsubscribe(_emailController.text.trim());
      if (context.mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("You have unsubscribed from weather updates")));
      }
    } catch (_) {
      // lỗi đã được set trong provider
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscription = context.watch<SubscriptionProvider>();

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 450),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              Text(
                "Manage Weather Email Subscription",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),

              /// Hiển thị lỗi (nếu có)
              if (subscription.errorMessage != null) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    border: Border.all(color: Colors.red.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    subscription.errorMessage!,
                    style: TextStyle(color: Colors.red.shade700, fontSize: 13),
                  ),
                ),
              ],

              /// Input luôn hiển thị
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: kIsWeb ? TextInputType.text : TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email address",
                    hintText: "Enter your email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    }
                    if (!value.contains("@") || !value.contains(".")) {
                      return "Invalid email format";
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) {
                    if (subscription.isSubscribeMode) {
                      _handleSubscribe(subscription);
                    } else {
                      _handleUnsubscribe(subscription);
                    }
                  },
                ),
              ),
              const SizedBox(height: 12),

              /// Text chuyển chế độ
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => subscription.toggleMode(),
                  child: Text(
                    subscription.isSubscribeMode
                        ? "Already subscribed? Unsubscribe"
                        : "Want to subscribe again?",
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              /// Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: subscription.isLoading
                        ? null
                        : () {
                            if (subscription.isSubscribeMode) {
                              _handleSubscribe(subscription);
                            } else {
                              _handleUnsubscribe(subscription);
                            }
                          },
                    icon: subscription.isLoading
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(
                            subscription.isSubscribeMode
                                ? Icons.send_outlined
                                : Icons.cancel_outlined,
                          ),
                    label: Text(subscription.isSubscribeMode ? "Subscribe" : "Unsubscribe"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: subscription.isSubscribeMode ? Colors.blue : Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
