import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../page/home_page.dart';
import '../page/login_page.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  void _checkAuthentication() async {

    await Future.delayed(Duration(seconds: 20));
    bool isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: SizedBox(
          width: 400, // Définissez la largeur souhaitée
          height: 400, // Définissez la hauteur souhaitée
          child: Lottie.asset('assets/data.json'),
        ),
      ),
    );
  }

}
