import 'package:flutter/material.dart';
import 'package:smig_app/services/api_service.dart';
import 'package:smig_app/views/page/ressource_list_page.dart';
import '../../services/auth_service.dart';
import 'login_page.dart';

class RessourceCreationPage extends StatefulWidget {
  @override
  _RessourceCreationPageState createState() => _RessourceCreationPageState();
}

class _RessourceCreationPageState extends State<RessourceCreationPage> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  /*final DateTime creationDateController = DateTime.now();
  final TextEditingController viewController = TextEditingController();*/

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Créer une ressource')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Titre'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: ElevatedButton(
                onPressed: () async {
                  final ressource = await ApiService().createRessource(
                    titleController.text,
                    descriptionController.text
                  );

                  if (ressource != null) {
                    print("OKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RessourceListPage()));
                  }
                  else if (titleController.text == "" || descriptionController.text == ""){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Veuillez remplir tout les champs nécessaires")));
                  }
                  else {
                    // Afficher une erreur
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Échec de la création de la ressource")));
                  }
                },
                child: Text('Créer une ressource'),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

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
                        onTap: ()=>{
                          print("kljkljkl")
                        },
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
                controller: titleController,
                icon: Icons.account_circle,
                label: 'Titre',
              ),
              const SizedBox(height: 16),
              _buildTextFieldWithShadow(
                controller: descriptionController,
                icon: Icons.account_circle,
                label: 'Description',
              ),
              const SizedBox(height: 50),
              _buildRoundedButton(
                context: context,
                buttonColor: Color(0xFF000091),
                textColor: Colors.white,
                buttonText: 'Créer une ressource',
                onPressed: () async {
                  if (titleController.text.trim().isEmpty || descriptionController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Tous les champs sont obligatoires"),
                            backgroundColor: Color(0xFFFFBD59),
                            duration: Duration(seconds: 2),
                            shape: StadiumBorder(),
                            behavior: SnackBarBehavior.floating
                        )
                    );
                    return;
                  }
                  try {
                    final ressource = await ApiService().createRessource(
                      titleController.text.trim(),
                      descriptionController.text.trim(),
                    );
                    if (ressource != null) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RessourceListPage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Échec lors de la création de la ressource"),
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
                            content: Text("Échec lors de la création de la ressource"),
                            backgroundColor: Color(0xFFFFBD59),
                            duration: Duration(seconds: 2),
                            shape: StadiumBorder(),
                            behavior: SnackBarBehavior.floating
                        )
                    );
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

