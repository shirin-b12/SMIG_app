import 'package:flutter/material.dart';
import 'package:smig_app/views/page/login_page.dart';
import '../../page/signup_page.dart';
import '../DashedCirclePainter.dart';

class SignUpOrLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    width: 100,
                    height: 100,
                    child: Image.asset('assets/gouv/ministere.png'),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(120, -100),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFBD59),
                      shape: BoxShape.circle,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 285,
                        height: 285,
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
                offset: Offset(50, 100),
                child: Align(
                  alignment: Alignment.topRight,
                  child: CustomPaint(
                    size: Size(150, 150),
                    painter: DashedCirclePainter(lineColor: Color(0xFFFFBD59)),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-100, 190),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: const BoxDecoration(
                      color: Color(0xFF03989E),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(-30, -80),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: CustomPaint(
                    size: Size(120, 120),
                    painter: DashedCirclePainter(lineColor: Color(0xFFFFBD59)),
                  ),
                ),
              ),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/smig/logo.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 60),
                    _buildRoundedButton(
                      context: context,
                      buttonColor: const Color(0xFF000091),
                      textColor: Colors.white,
                      buttonText: 'Connexion',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'OU',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildRoundedButton(
                      context: context,
                      buttonColor: const Color(0xFF03989E),
                      textColor: Colors.white,
                      buttonText: 'Inscription',
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedButton({
    required BuildContext context,
    required Color buttonColor,
    required Color textColor,
    required String buttonText,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor,
        backgroundColor: buttonColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      ),
      onPressed: onPressed,
      child: Text(buttonText, style: TextStyle(fontSize: 16)),
    );
  }
}
