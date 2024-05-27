import 'package:flutter/material.dart';
import 'package:smig_app/services/api_service.dart';
import 'package:smig_app/views/page/home_page.dart';
import '../../models/role.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class CreateUserWithRolePage extends StatefulWidget {

  @override
  _CreateUserWithRolePageState createState() => _CreateUserWithRolePageState();
}

class _CreateUserWithRolePageState extends State<CreateUserWithRolePage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController prenomController = TextEditingController();
  final TextEditingController nomController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController mdpController = TextEditingController();
  int? selectedRoleId;
  List<Role>? roles = [];

  @override
  void initState() {
    super.initState();

    _fetchMetadata();
  }

  _fetchMetadata() async {
    roles = await ApiService().fetchRoles();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            width: 300,
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/gouv/marianne.png', width: 40, height: 40),
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: 50),
                _buildTextFieldWithShadow(controller: emailController, icon: Icons.email, label: 'Email'),
                SizedBox(height: 16),
                _buildTextFieldWithShadow(controller: prenomController, icon: Icons.abc_rounded, label: 'Prénom'),
                SizedBox(height: 16),
                _buildTextFieldWithShadow(controller: nomController, icon: Icons.abc_rounded, label: 'Nom'),
                SizedBox(height: 16),
                _buildTextFieldWithShadow(controller: telController, icon: Icons.phone, label: 'Téléphone'),
                SizedBox(height: 16),
                _buildTextFieldWithShadow(controller: mdpController, icon: Icons.password_rounded, label: 'Mot de passe'),
                SizedBox(height: 16),
                _buildDropdown<Role>(
                  label: 'Roles',
                  selectedValue: selectedRoleId,
                  items: roles,
                  onChanged: (newValue) {
                    setState(() {
                      selectedRoleId = newValue;
                    });
                  },
                  getId: (Role) => Role.id,
                  getName: (Role) => Role.nom,
                ),
                SizedBox(height: 50),
                _buildRoundedButton(
                  context: context,
                  buttonColor: Color(0xFF000091),
                  textColor: Colors.white,
                  buttonText: 'Créer le compte',
                  iconData: Icons.person_add,
                  onPressed: () async {
                    if (emailController.text.trim().isEmpty
                        || prenomController.text.trim().isEmpty
                        || nomController.text.trim().isEmpty
                        || mdpController.text.trim().isEmpty
                        || selectedRoleId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Les champs suivant L'Email, le Prenom, le Nom, le Mot de passe et le Role sont obligatoires"),
                              backgroundColor: Color(0xFFFFBD59),
                              duration: Duration(seconds: 2),
                              shape: StadiumBorder(),
                              behavior: SnackBarBehavior.floating
                          )
                      );
                      return;
                    }
                    try {
                      Role? selectedRole = roles?[selectedRoleId! - 1];

                      print(selectedRole!.id);
                      print(selectedRole!.nom);

                      final bool = await ApiService().creerUtilisateurAvecRole(
                          nomController.text.trim(),
                          prenomController.text.trim(),
                          emailController.text.trim(),
                          mdpController.text.trim(),
                          telController.text.trim(),
                          selectedRole!);

                      if (bool) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Échec lors de la création du compte"),
                                backgroundColor: Color(0xFFFFBD59),
                                duration: Duration(seconds: 2),
                                shape: StadiumBorder(),
                                behavior: SnackBarBehavior.floating
                            )
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Échec lors de la création du compte 2"),
                              backgroundColor: Color(0xFFFFBD59),
                              duration: Duration(seconds: 2),
                              shape: StadiumBorder(),
                              behavior: SnackBarBehavior.floating
                          )
                      );
                      print(e);
                    }
                  },
                ),
              ],
            ),
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

    return TextField(
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
      ),
    );
  }

  Widget _buildRoundedButton({
    required BuildContext context,
    required Color buttonColor,
    required Color textColor,
    required String buttonText,
    required IconData iconData,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData), // Icône
          SizedBox(width: 10), // Espace entre l'icône et le texte
          Text(buttonText, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required int? selectedValue,
    required List<T>? items,
    required ValueChanged<int?> onChanged,
    required int Function(T) getId,
    required String Function(T) getName,
  }) {
    return Container(
      width: 250,
      child: DropdownButtonFormField<int>(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
        value: selectedValue,
        onChanged: onChanged,
        items: items?.map((item) {
          return DropdownMenuItem<int>(
            value: getId(item),
            child: Text(
              getName(item),
              style: TextStyle(fontSize: 16),
            ),
          );
        }).toList(),
      ),
    );
  }
}
