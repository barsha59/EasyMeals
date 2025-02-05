import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BillPage extends StatefulWidget {
  final int branchId; // Branch ID passed from the previous page
  final int userId; // User ID passed from the previous page

  const BillPage({super.key, required this.branchId, required this.userId});

  @override
  _BillPageState createState() => _BillPageState();
}

class _BillPageState extends State<BillPage> {
  List<dynamic> billItems = [];
  double totalAmount = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBillData();
  }

  Future<void> _fetchBillData() async {
    final url = Uri.parse('http://10.0.2.2/minoriiproject/billpage.php');
    final response = await http.post(url, body: {
      'branch_id': widget.branchId.toString(),
      'user_id': widget.userId.toString(),
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        setState(() {
          billItems = data['bill_items'];
          totalAmount = data['total_amount'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bill Details'),
          backgroundColor: const Color(0xFFFFDE21),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: billItems.length,
                      itemBuilder: (context, index) {
                        var item = billItems[index];
                        return ListTile(
                          title: Text(item['item_name']),
                          subtitle: Text('Qty: ${item['quantity']}'),
                          trailing: Text('₹${item['price']}'),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total: ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '₹$totalAmount',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle checkout or any action here
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: const Color(0xFFFFDE21),
                    ),
                    child: const Text('Proceed to Payment'),
                  ),
                ],
              ),
      ),
    );
  }
}
