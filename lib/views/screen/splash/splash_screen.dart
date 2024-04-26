import 'package:flutter/material.dart';
import 'package:smig_app/views/page/ressource_creation_page.dart';
import 'package:smig_app/views/page/utilisateur_modification_page.dart';
import 'package:smig_app/views/screen/signup_or_login/signup_or_login.dart';
import 'dart:math' as math;
import '../../../services/api_service.dart';
import '../../../services/auth_service.dart';
import '../../page/create_user_with_role.dart';
import '../../page/home_page.dart';
import 'package:lottie/lottie.dart';
import '../../page/ressource_list_page.dart';
import '../../page/ressource_page.dart';

import '../../page/search_page.dart';
import '../DashedCirclePainter.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    _checkAuthentication();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _checkAuthentication() async {
    await Future.delayed(const Duration(seconds: 4));
    bool isLoggedIn = await AuthService.isLoggedIn();
    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    } else {
      //var user = await api.getUtilisateur(5);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpOrLogin()/*UserModificationPage(user: user)*/));    }
  }

  @override
  Widget build(BuildContext context) {
    final double offsetX = 45;
    final double offsetY = -40;

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: Offset(offsetX, offsetY),
              child: SizedBox(
                width: 400,
                height: 400,
                child: Lottie.asset('assets/animations/splashScreen/data.json'),
              ),
            ),
            Transform.translate(
              offset: Offset(42.5,25),
              child: Align(
                alignment: Alignment.topRight,
                child: AnimatedBuilder(
                  animation: _rotationController,
                  child: CustomPaint(
                    size: Size(250, 250),
                    painter: DashedCirclePainter(lineColor: Color(0xFF03989E)),
                  ),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * math.pi,
                      child: child,
                    );
                  },
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-125,-5),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedBuilder(
                  animation: _rotationController,
                  child: CustomPaint(
                    size: Size(250, 250),
                    painter: DashedCirclePainter(lineColor: Color(0xFFFFBD59)),
                  ),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * math.pi,
                      child: child,
                    );
                  },
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(-150,-350),
              child: Align(
                alignment: Alignment.topLeft,
                child: AnimatedBuilder(
                  animation: _rotationController,
                  child: CustomPaint(
                    size: Size(450, 450),
                    painter: DashedCirclePainter(lineColor: Color(0xFFFFBD59)),
                  ),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * math.pi,
                      child: child,
                    );
                  },
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(150,-450),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: 650,
                  height: 650,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFFFBD59),
                      width: 3.5,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(150,50),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF03989E),
                      width: 3.5,
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(60,135),
              child: Align(
                alignment: Alignment.bottomRight,
                child: AnimatedBuilder(
                  animation: _rotationController,
                  child: CustomPaint(
                    size: const Size(200, 200),
                    painter: DashedCirclePainter(lineColor: Color(0xFF03989E)),
                  ),
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _rotationController.value * 2 * math.pi,
                      child: child,
                    );
                  },
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(20, 50),
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFBD59),
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: const BoxDecoration(
                        color: Color(0xFF03989E),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(-100, -25),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFF03989E),
                    shape: BoxShape.circle,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                    width: 100,
                    height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFFFBD59),
                          width: 5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                width: 40,
                height: 40,
                child: Image.asset('assets/gouv/marianne.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}