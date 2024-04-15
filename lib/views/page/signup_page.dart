import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'login_page.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 100),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFF03989E),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.photo,
                      size: 35.0,
                      color: Colors.white,
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: () => {print("kljkljkl")},
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Color(0xFFFFBD59),
                              width: 3,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.camera_alt,
                            color: Color(0xFF03989E),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              _buildTextFieldWithShadow(
                controller: nameController,
                icon: Icons.account_circle,
                label: 'Nom',
              ),
              const SizedBox(height: 16),
              _buildTextFieldWithShadow(
                controller: surnameController,
                icon: Icons.account_circle,
                label: 'Prénom',
              ),
              const SizedBox(height: 16),
              _buildTextFieldWithShadow(
                controller: emailController,
                icon: Icons.email,
                label: 'Email',
              ),
              const SizedBox(height: 16),
              _buildTextFieldWithShadow(
                controller: passwordController,
                icon: Icons.lock,
                label: 'Mot de passe',
                isPassword: true,
              ),
              const SizedBox(height: 50),
              _buildRoundedButton(
                context: context,
                buttonColor: Color(0xFF000091),
                textColor: Colors.white,
                buttonText: 'Créer un compte',
                onPressed: () async {
                  if (nameController.text.trim().isEmpty ||
                      surnameController.text.trim().isEmpty ||
                      emailController.text.trim().isEmpty ||
                      passwordController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Tous les champs sont obligatoires"),
                        backgroundColor: Color(0xFFFFBD59),
                        duration: Duration(seconds: 2),
                        shape: StadiumBorder(),
                        behavior: SnackBarBehavior.floating));
                    return;
                  }
                  try {
                    final utilisateur = await AuthService().createAccount(
                      nameController.text.trim(),
                      surnameController.text.trim(),
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    );
                    if (utilisateur) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Échec lors de la création de compte"),
                          backgroundColor: Color(0xFFFFBD59),
                          duration: Duration(seconds: 2),
                          shape: StadiumBorder(),
                          behavior: SnackBarBehavior.floating));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Échec lors de la création de compte"),
                        backgroundColor: Color(0xFFFFBD59),
                        duration: Duration(seconds: 2),
                        shape: StadiumBorder(),
                        behavior: SnackBarBehavior.floating));
                  }
                },
              ),
              Spacer(),
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
      margin: EdgeInsets.symmetric(horizontal: 50.0),
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
