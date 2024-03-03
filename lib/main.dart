import 'package:flutter/material.dart';
import 'package:smig_app/views/page/login_page.dart';
import 'package:smig_app/views/page/resource_creation_page.dart';
import 'package:smig_app/views/page/resource_list_page.dart';
import 'package:smig_app/views/page/signup_page.dart';
import 'package:smig_app/views/page/verif_numSecu.dart';
import 'package:smig_app/views/screen/splash/splash_screen.dart';
import 'views/page/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMIG App',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/verification': (context) => VerificationPage(),
        '/resource_list': (context) => ResourceListPage(),
        '/resource_creation': (context) => ResourceCreationPage()
      },
    );
  }
}


