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
  final Ressource ressource;

  RessourceUpdatePage({required this.ressource});

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

  @override
  void initState() {
    super.initState();

    titleController.text = widget.ressource.titre;
    descriptionController.text = widget.ressource.description;

    selectedTypeId = widget.ressource.type.id;
    selectedTagId = widget.ressource.tags.id;
    selectedCatId = widget.ressource.category.id;

    _fetchMetadata();
  }

  _fetchMetadata() async {
    types = await ApiService().fetchTypes();
    tags = await ApiService().fetchTags();
    categories = await ApiService().fetchCategories();
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
                        widget.ressource.id,
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
