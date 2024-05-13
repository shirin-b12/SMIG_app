import 'package:flutter/material.dart';
import 'package:smig_app/services/api_service.dart';
import 'package:smig_app/models/utilisateur.dart';
import 'package:smig_app/views/page/utilisateur_profile.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class UserModificationPage extends StatefulWidget {
  final Utilisateur user;

  const UserModificationPage({Key? key, required this.user}) : super(key: key);

  @override
  _UserModificationPageState createState() => _UserModificationPageState();
}

class _UserModificationPageState extends State<UserModificationPage> {
  final _formKey = GlobalKey<FormState>();
  late String nom, prenom, email;
  late int id;
  final ApiService api = ApiService();

  @override
  void initState() {
    super.initState();
    id = widget.user.id;
    nom = widget.user.nom;
    prenom = widget.user.prenom;
    email = widget.user.email;
  }

  Widget _buildTextField({
    required String initialValue,
    required String label,
    required IconData icon,
    required Function(String) onSaved,
    required String? Function(String?) validator,
  }) {
    Color labelColor = Color(0xFF03989E);
    Color cursorColor = Color(0xFF03989E);
    Color borderColor = Color(0xFF03989E);

    return TextFormField(
      initialValue: initialValue,
      cursorColor: cursorColor,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: labelColor),
        labelStyle: TextStyle(
          color: labelColor,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        fillColor: Colors.white,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor.withOpacity(0.5), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      onSaved: (value) => onSaved(value!),
      validator: validator,
      style: TextStyle(color: Colors.black54),
    );
  }


  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool updated = await api.updateUser(id, nom, prenom, email);
      if (updated) {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => UserProfile()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Échec de la mise à jour"),
          backgroundColor: Color(0xFFFFBD59),
          duration: Duration(seconds: 2),
          shape: StadiumBorder(),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset('assets/gouv/marianne.png', width: 40, height: 40),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text('Modification de votre profil',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF015E62),
                        ),
                      ),
                      const SizedBox(height: 60),
                      _buildTextField(
                        initialValue: nom,
                        label: "Nom",
                        icon: Icons.account_circle,
                        onSaved: (value) => nom = value,
                        validator: (value) => value!.isEmpty ? "Veuillez entrer votre nom" : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        initialValue: prenom,
                        label: "Prénom",
                        icon: Icons.account_circle,
                        onSaved: (value) => prenom = value,
                        validator: (value) => value!.isEmpty ? "Veuillez entrer votre prénom" : null,
                      ),
                      const SizedBox(height: 16),
                      _buildTextField(
                        initialValue: email,
                        label: "Email",
                        icon: Icons.email,
                        onSaved: (value) => email = value,
                        validator: (value) => value!.isEmpty ? "Veuillez entrer votre adresse e-mail" : null,
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white, backgroundColor: Color(0xFF000091),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        ),
                        icon: Icon(Icons.mode, size: 24),
                        label: Text('Soumettre'),
                        onPressed: _submit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
