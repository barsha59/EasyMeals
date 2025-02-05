// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'providers/cart_provider.dart'; // Import CartProvider

// class NepaliMenuPage extends StatefulWidget {
//   const NepaliMenuPage({super.key});

//   @override
//   _NepaliMenuPageState createState() => _NepaliMenuPageState();
// }

// class _NepaliMenuPageState extends State<NepaliMenuPage> {
//   final TextEditingController _searchController = TextEditingController();
//   final List<Map<String, dynamic>> menuItems = [
//     {
//       'title': 'Momo',
//       'image': 'assets/momo.jpg',
//       'price': 'Rs. 150',
//       'quantity': 0,
//     },
//     {
//       'title': 'Thukpa',
//       'image': 'assets/thukpa.jpg',
//       'price': 'Rs. 200',
//       'quantity': 0,
//     },
//     {
//       'title': 'Chatamaari',
//       'image': 'assets/chataamari.jpg',
//       'price': 'Rs. 100',
//       'quantity': 0,
//     },
//     {
//       'title': 'Sel Roti',
//       'image': 'assets/selroti.jpg',
//       'price': 'Rs. 20',
//       'quantity': 0,
//     },
//     {
//       'title': 'Khana Set (Veg)',
//       'image': 'assets/khana set veg.jpg',
//       'price': 'Rs. 350',
//       'quantity': 0,
//     },
//     {
//       'title': 'Khana Set (Chicken)',
//       'image': 'assets/khanaset nonveg.jpg',
//       'price': 'Rs. 500',
//       'quantity': 0,
//     },
//     {
//       'title': 'Yomari',
//       'image': 'assets/yomari.jpg',
//       'price': 'Rs. 80',
//       'quantity': 0,
//     },
//     {
//       'title': 'Newari Khaja Set',
//       'image': 'assets/newari khaja set.jpg',
//       'price': 'Rs. 250',
//       'quantity': 0,
//     },
//     {
//       'title': 'Parotha',
//       'image': 'assets/parotha.jpg',
//       'price': 'Rs. 40',
//       'quantity': 0,
//     },
//   ];

//   List<Map<String, dynamic>> filteredMenuItems = [];

//   @override
//   void initState() {
//     super.initState();
//     filteredMenuItems = List.from(menuItems);
//   }

//   // Method to handle adding items to the cart
//   void addToCart(Map<String, dynamic> item) {
//     final cartProvider = Provider.of<CartProvider>(context, listen: false);

//     // Calculate the total price
//     final int quantity = item['quantity'];
//     final int pricePerUnit =
//         int.parse(item['price'].split(' ').last); // Extract numeric price
//     final int totalPrice = quantity * pricePerUnit;

//     // Add to the cart
//     cartProvider.addToCart({
//       'title': item['title'],
//       'price': totalPrice, // Total price
//       'quantity': quantity,
//       'image': item['image'], // Include the image
//     });

//     // Reset quantity
//     setState(() {
//       item['quantity'] = 0;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('${item['title']} added to cart!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFFFC400),
//         title: const Text(
//           'Nepali Cuisine',
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//         centerTitle: true,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Container(
//         color: const Color(0xFFFFF9E5),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 controller: _searchController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding: const EdgeInsets.symmetric(vertical: 10),
//                   prefixIcon: const Icon(Icons.search, color: Colors.grey),
//                   hintText: 'Search',
//                   hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide:
//                         const BorderSide(color: Colors.lightGreen, width: 2),
//                   ),
//                   enabledBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide:
//                         const BorderSide(color: Colors.blueGrey, width: 2),
//                   ),
//                   focusedBorder: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(12),
//                     borderSide:
//                         const BorderSide(color: Colors.blueGrey, width: 2),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Scrollbar(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: filteredMenuItems.map((item) {
//                       return Card(
//                         margin: const EdgeInsets.only(bottom: 16.0),
//                         color: Colors.white,
//                         elevation: 5,
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Row(
//                             children: [
//                               ClipRRect(
//                                 borderRadius: BorderRadius.circular(8.0),
//                                 child: Image.asset(
//                                   item['image'],
//                                   width: 80,
//                                   height: 80,
//                                   fit: BoxFit.cover,
//                                 ),
//                               ),
//                               const SizedBox(width: 16),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       item['title'],
//                                       style: const TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Text(
//                                       'Rs. ${item['price']}',
//                                       style: const TextStyle(
//                                         fontSize: 16,
//                                         color: Colors.red,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.remove,
//                                         color: Colors.red),
//                                     onPressed: () {
//                                       setState(() {
//                                         if (item['quantity'] > 0) {
//                                           item['quantity']--;
//                                         }
//                                       });
//                                     },
//                                   ),
//                                   Text(
//                                     '${item['quantity']}',
//                                     style: const TextStyle(
//                                       fontSize: 16,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.add,
//                                         color: Colors.redAccent),
//                                     onPressed: () {
//                                       setState(() {
//                                         item['quantity']++;
//                                       });
//                                     },
//                                   ),
//                                   const SizedBox(width: 10),
//                                   IconButton(
//                                     icon: const Icon(Icons.shopping_cart,
//                                         color: Colors.green),
//                                     onPressed: () {
//                                       if (item['quantity'] > 0) {
//                                         addToCart(item);
//                                       } else {
//                                         ScaffoldMessenger.of(context)
//                                             .showSnackBar(
//                                           const SnackBar(
//                                             content: Text(
//                                                 'Please select a quantity!'),
//                                           ),
//                                         );
//                                       }
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
