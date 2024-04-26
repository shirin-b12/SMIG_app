import 'package:flutter/material.dart';
import 'package:smig_app/models/categorie.dart';
import 'package:smig_app/models/tag.dart';
import 'package:smig_app/models/type.dart';
import 'package:smig_app/services/api_service.dart';
import 'package:smig_app/views/page/home_page.dart';
import '../../models/ressource.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class RessourceUpdatePage extends StatefulWidget {
  final int ressourceId;

  RessourceUpdatePage({required this.ressourceId});

  @override
  _RessourceUpdatePageState createState() => _RessourceUpdatePageState();
}

class _RessourceUpdatePageState extends State<RessourceUpdatePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController visibiliteController = TextEditingController();
  int? selectedTypeId;
  int? selectedTagId;
  int? selectedCatId;
  List<Type>? types = [];
  List<Tag>? tags = [];
  List<Categorie>? categories = [];
  Ressource? ressource;

  final Color primaryColor = Color(0xFF03989E);

  @override
  void initState() {
    super.initState();
    _fetchMetadata();

  }


  _fetchMetadata() async {
    ressource = await ApiService().getRessource(widget.ressourceId);
    types = await ApiService().fetchTypes();
    tags = await ApiService().fetchTags();
    categories = await ApiService().fetchCategories();
    titleController.text = ressource!.titre;
    descriptionController.text = ressource!.description;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomTopAppBar(),
      bottomNavigationBar: CustomBottomAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/gouv/marianne.png', width: 40, height: 40),
                const Text('Modification de votre ressource',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF015E62),
                  ),
                ),
                SizedBox(height: 50),
                _buildTextFieldWithShadow(controller: titleController, icon: Icons.title, label: 'Titre'),
                SizedBox(height: 16),
                _buildTextFieldWithShadow(controller: descriptionController, icon: Icons.description, label: 'Description'),
                SizedBox(height: 16),
                _buildDropdown<Type>(
                  label: 'Types',
                  selectedValue: selectedTypeId,
                  items: types,
                  onChanged: (newValue) {
                    setState(() {
                      selectedTypeId = newValue;
                    });
                  },
                  getId: (type) => type.id,
                  getName: (type) => type.nom,
                ),
                SizedBox(height: 16),
                _buildDropdown<Tag>(
                  label: 'Tags',
                  selectedValue: selectedTagId,
                  items: tags,
                  onChanged: (newValue) {
                    setState(() {
                      selectedTagId = newValue;
                    });
                  },
                  getId: (tag) => tag.id,
                  getName: (tag) => tag.nom,
                ),
                SizedBox(height: 16),
                _buildDropdown<Categorie>(
                  label: 'Catégories',
                  selectedValue: selectedCatId,
                  items: categories,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCatId = newValue;
                    });
                  },
                  getId: (category) => category.id,
                  getName: (category) => category.nom,
                ),
                SizedBox(height: 50),
                _buildRoundedButton(
                  context: context,
                  buttonColor: Color(0xFF000091),
                  textColor: Colors.white,
                  buttonText: 'Modifier la ressource',
                  iconData: Icons.mode,
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
                      final bool = await ApiService().updateRessource(
                        widget.ressourceId,
                        titleController.text.trim(),
                        descriptionController.text.trim(),
                        selectedCatId!,
                        selectedTypeId!,
                        selectedTagId!,
                      );
                      if (bool) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
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
        primary: buttonColor,
        onPrimary: textColor,
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
      width: double.infinity, // Ensures the dropdown takes the full width available
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: primaryColor, width: 0.5),
        color: Colors.white,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<int>(
          decoration: InputDecoration(
            labelText: label,
            contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            border: InputBorder.none,
          ),
          value: selectedValue,
          isExpanded: true,
          onChanged: onChanged,
          items: items?.map((item) {
            return DropdownMenuItem<int>(
              value: getId(item),
              child: Text(
                getName(item),
                style: TextStyle(color: primaryColor, fontSize: 16),
              ),
            );
          }).toList(),
          icon: Icon(Icons.arrow_drop_down, color: primaryColor),
          style: TextStyle(color: primaryColor, fontSize: 16),
        ),
      ),
    );
  }

}
