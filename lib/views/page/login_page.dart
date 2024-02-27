import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../screen/signup_or_login/signup_or_login.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                bool isLoggedIn = await AuthService.isLoggedIn();
                if (isLoggedIn) {
                  Navigator.pop(context);
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignUpOrLogin()));
                }
              },
            ),
          ),
          Flexible(
            flex: 3,
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 100),
                  Image.asset(
                      'assets/smig/logo.png',
                      height: 120,
                  ),
                  const SizedBox(height: 100),
                  _buildTextFieldWithShadow(
                    controller: emailController,
                    icon: Icons.person_outline,
                    label: 'E-mail',
                  ),
                  const SizedBox(height: 16),
                  _buildTextFieldWithShadow(
                    controller: passwordController,
                    icon: Icons.lock,
                    label: 'Mot de passe',
                    isPassword: true,
                  ),
                  const SizedBox(height: 80),
                  _buildRoundedButton(
                    context: context,
                    buttonColor: const Color(0xFF000091),
                    textColor: Colors.white,
                    buttonText: 'Connexion',
                    onPressed: () async {
                      final bool isLoggedIn = await AuthService().login(emailController.text, passwordController.text);
                      if (isLoggedIn) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text("Échec de la connexion"),
                                backgroundColor: Color(0xFFFFBD59),
                                duration: const Duration(seconds: 2),
                                shape: StadiumBorder(),
                                behavior: SnackBarBehavior.floating)
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Align(
              alignment: Alignment.bottomCenter,
                child: Image.asset('assets/gouv/marianne.png', width: 40, height: 40),

            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextFieldWithShadow({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    bool isPassword = false,
  }) {
    Color labelColor = Color(0xFF03989E);
    Color cursorColor = Color(0xFF03989E);
    Color borderColor = Color(0xFF03989E);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 120.0),
      child: TextField(
        controller: controller,
        cursorColor: cursorColor,
        style: TextStyle(color: Colors.black54),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: labelColor),
          labelText: label,
          labelStyle: TextStyle(
            color: labelColor,
            height: 0.5,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          fillColor: Colors.white,
          filled: true,
          contentPadding: EdgeInsets.only(top: 20.0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: borderColor.withOpacity(0.5)),
          ),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off,
              color: labelColor,
            ),
            onPressed: () {
              setState(() {
                _passwordVisible = !_passwordVisible;
              });
            },
          )
              : null,
        ),
        obscureText: isPassword && !_passwordVisible,
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
        primary: buttonColor,
        onPrimary: textColor,
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
