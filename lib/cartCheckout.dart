import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:provider/provider.dart';
import 'providers/cart_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CartSummary extends StatefulWidget {
  final int loggedInBranchId;
  final int loggedInUserId;
  final double totalAmount;

  const CartSummary({
    super.key,
    required this.loggedInBranchId,
    required this.loggedInUserId,
    required this.totalAmount,
  });

  @override
  _CartSummaryState createState() => _CartSummaryState();
}

class _CartSummaryState extends State<CartSummary> {
  DateTime? selectedDateTime;
  double loyaltyPoints = 0.0;
  double subscriptionCredit = 0.0;
  String userEmail = "";
  String branchName = "";
  bool _isLoading = false;

  final String apiUrl = "http://10.0.2.2/minoriiproject/loyaltyPoints.php";
  final String subscriptionUrl =
      "http://10.0.2.2/minoriiproject/subscription.php";
  final String paymentUrl =
      "http://10.0.2.2/minoriiproject/initiate_payment.php";
  final String getEmailUrl = "http://10.0.2.2/minoriiproject/cartCheckout.php";

  @override
  void initState() {
    super.initState();
    fetchEmailAndBranch();
    fetchLoyaltyPoints();
    fetchSubscriptionCredit();
  }

  Future<void> fetchEmailAndBranch() async {
    if (widget.loggedInUserId == 0) return;
    try {
      final response = await http.post(
        Uri.parse(getEmailUrl),
        body: {"user_id": widget.loggedInUserId.toString()},
      );

      final data = json.decode(response.body);
      if (data["success"] == true) {
        setState(() {
          userEmail = data["email"];
          branchName = data["branch_name"];
        });
      }
    } catch (e) {
      print("Error fetching email and branch: $e");
    }
  }

  Future<void> fetchLoyaltyPoints() async {
    if (widget.totalAmount <= 0) return;
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"total_cost": widget.totalAmount.toString()},
      );

      final data = json.decode(response.body);
      if (data.containsKey("earned_points")) {
        setState(() {
          loyaltyPoints =
              double.tryParse(data["earned_points"].toString()) ?? 0.0;
        });
      }
    } catch (e) {
      print("Error fetching loyalty points: $e");
    }
  }

  Future<void> fetchSubscriptionCredit() async {
    if (widget.loggedInUserId == 0) return;
    try {
      final response = await http.post(
        Uri.parse(subscriptionUrl),
        body: {"user_id": widget.loggedInUserId.toString()},
      );

      final data = json.decode(response.body);
      if (data.containsKey("subscription_id") &&
          data["subscription_id"] != null) {
        setState(() {
          subscriptionCredit =
              double.tryParse(data["success"].toString()) ?? 0.0;
        });
      }
    } catch (e) {
      print("Error fetching subscription credit: $e");
    }
  }

  Future<void> launchPaymentUrl(String paymentUrl) async {
    final Uri url = Uri.parse(paymentUrl);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      print("Could not launch the payment URL");
    }
  }

  Future<void> initiatePayment(double totalAmount) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(paymentUrl),
        body: {
          "amount": totalAmount.toString(),
          "user_id": widget.loggedInUserId.toString(),
          "email": userEmail,
          "order_id": "ORDER-${Random().nextInt(99999)}",
        },
      ).timeout(const Duration(seconds: 15)); // Timeout after 15 seconds

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('payment_url')) {
          final paymentUrl = data['payment_url'];
          await launchPaymentUrl(paymentUrl);
        } else {
          print("Payment API Error: payment_url not found");
        }
      } else {
        print("Payment API error: HTTP ${response.statusCode}");
      }
    } catch (e) {
      print("Error during payment initiation: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget tableCell(String text, [bool isHeader = false]) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cartItems = cartProvider.cartItems;

    double totalPrice = cartItems.values.fold(0, (sum, item) {
      double price = double.tryParse(item['price'].toString()) ?? 0.0;
      int quantity = int.tryParse(item['quantity'].toString()) ?? 0;
      return sum + (price * quantity);
    });

    double remainingAfterLoyalty = max(0, totalPrice - loyaltyPoints);
    double remainingAfterSubscription =
        max(0, remainingAfterLoyalty - subscriptionCredit);
    double finalTotal = max(0, remainingAfterSubscription);

    String orderTime = DateTime.now().toLocal().toString().substring(0, 19);
    String billNumber = "BILL-${Random().nextInt(99999)}";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Summary'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    branchName.isEmpty ? "Loading..." : branchName,
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text("Order Details:"),
                  Text("Date & Time: $orderTime"),
                  Text("Bill No: $billNumber"),
                  const SizedBox(height: 16),
                  const Text("Order Items:"),
                  Table(
                    border: TableBorder.all(),
                    children: [
                      TableRow(
                        children: [
                          tableCell("Item", true),
                          tableCell("Quantity", true),
                          tableCell("Price", true),
                        ],
                      ),
                      ...cartItems.entries.map(
                        (entry) {
                          var item = entry.value;
                          return TableRow(
                            children: [
                              tableCell(item['name']),
                              tableCell(item['quantity'].toString()),
                              tableCell(item['price'].toString()),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Cost Breakdown:"),
                  tableCell(
                      "Original Cost: \$${totalPrice.toStringAsFixed(2)}"),
                  tableCell(
                      "Loyalty Points Used: \$${loyaltyPoints.toStringAsFixed(2)}"),
                  tableCell(
                      "Remaining After Loyalty: \$${remainingAfterLoyalty.toStringAsFixed(2)}"),
                  tableCell(
                      "Subscription Credit Used: \$${subscriptionCredit.toStringAsFixed(2)}"),
                  tableCell("Final Total: \$${finalTotal.toStringAsFixed(2)}"),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                            initiatePayment(finalTotal);
                          },
                    child: const Text('Pay Now'),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
