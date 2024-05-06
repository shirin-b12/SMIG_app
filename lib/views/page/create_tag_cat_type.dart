import 'package:flutter/material.dart';
import 'package:smig_app/services/api_service.dart';

import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class CatCreationPage extends StatefulWidget {
  @override
  _CatCreationPageState createState() => _CatCreationPageState();
}

class _CatCreationPageState extends State<CatCreationPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  /*final Image imageController = */
  final TextEditingController visibiliteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
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
              const SizedBox(height: 50),
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
              const SizedBox(height: 16),
              _buildTextFieldWithShadow(
                controller: titleController,
                icon: Icons.abc_rounded,
                label: 'Nom',
              ),
              const SizedBox(height: 50),
              _buildRoundedButton(
                context: context,
                buttonColor: Color(0xFF000091),
                textColor: Colors.white,
                buttonText: 'Créer',
                onPressed: () async {
                  String title = titleController.text.trim();
                  if (title.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Le nom de la catégorie est obligatoire"),
                        backgroundColor: Color(0xFFFFBD59),
                        duration: Duration(seconds: 2),
                        shape: StadiumBorder(),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  try {
                    final ressource = await ApiService().createType(
                      titleController.text.trim(),
                    );
                    if (ressource == null) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Échec lors de la création ee"),
                          backgroundColor: Color(0xFFFFBD59),
                          duration: Duration(seconds: 2),
                          shape: StadiumBorder(),
                          behavior: SnackBarBehavior.floating));
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Échec lors de la création"),
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
