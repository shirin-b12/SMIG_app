import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smig_app/views/page/signup_page.dart';

import '../../services/auth_service.dart';
import '../screen/signup_or_login/signup_or_login.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final TextEditingController _controller = TextEditingController();
  String _errorMessage = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final text = _controller.text.trim();

    if (text.isEmpty) {
      setState(() {
        _errorMessage = 'Veuillez entrer votre numéro de sécurité sociale';
      });
      return;
    }

    bool hasDigits = RegExp(r'\d').hasMatch(text);
    bool hasLetters = RegExp(r'[a-zA-Z]').hasMatch(text);
    bool hasSpecialChars = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(text);

    if (!(hasDigits && !hasLetters && !hasSpecialChars)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Veuillez entrer un numéro valide'),
              backgroundColor: Color(0xFFFFBD59),
              duration: Duration(seconds: 2),
              shape: StadiumBorder(),
              behavior: SnackBarBehavior.floating
          )
      );
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () async {
                          bool isLoggedIn = await AuthService.isLoggedIn();
                          if (isLoggedIn) {
                            Navigator.pop(context);
                          } else {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(builder: (context) => SignUpOrLogin()));
                          }
                        },
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                    Image.asset('assets/smig/logo.png', height: 120),
                    SizedBox(height: 40),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: 'Entrer votre n° de sécurité sociale',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(13),
                      ],
                    ),
                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_errorMessage, style: TextStyle(color: Colors.red)),
                      ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _verify,
                      child: Text('Vérification'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Color(0xFF000091),
                        shape: StadiumBorder(),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          Image.asset('assets/gouv/marianne.png', width: 40, height: 40),
          SizedBox(height: 10),  // Adjust spacing as needed
        ],
      ),
    );
  }
}
