// import 'package:flutter/material.dart';
// import 's_login_page.dart';
// import 's_signup_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Easy Meals',
//       theme: ThemeData(
//         primarySwatch: Colors.orange,
//       ),
//       initialRoute: '/s_signup_page',
//       routes: {
//         '/s_signup_page': (context) => const s_SignUpScreen(),
//         '/s_login_page': (context) => const s_LoginScreen(),
//       },
//     );
//   }
// }

// for user side
import 'package:flutter/material.dart';
import 'providers/cart_provider.dart';
import 'package:provider/provider.dart';
// Import the CartProvider
import 'signup_page.dart';
import 'login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Easy Meals',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/signup_page',
      routes: {
        '/signup_page': (context) => const SignUpScreen(),
        '/login_page': (context) => const LoginScreen(),
      },
    );
  }
}
