import 'package:flutter/material.dart';
import 'package:smig_app/models/categorie.dart';
import 'package:smig_app/models/type.dart';
import '../../models/tag.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_bottom_app_bar.dart';
import '../../widgets/custom_top_app_bar.dart';

class CreateCatTypeTag extends StatefulWidget {
  const CreateCatTypeTag({super.key});

  @override
  _CreateCatTypeTagState createState() => _CreateCatTypeTagState();
}

class _CreateCatTypeTagState extends State<CreateCatTypeTag> {
  final ApiService api = ApiService();
  final List<String> _categories = [];
  final List<String> _types = [];
  final List<String> _tags = [];

  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Dispose controllers when the widget is disposed
    _categoryController.dispose();
    _typeController.dispose();
    _tagController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomTopAppBar(),
      bottomNavigationBar: const CustomBottomAppBar(),
      body: Center(
        child: Container(
          width: 300,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset('assets/gouv/marianne.png', width: 40, height: 40),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              buildInputField(
                controller: _categoryController,
                label: 'Catégorie',
                hint: 'Entrez une catégorie',
                onPressed: () async {
                  await handleCreateItem(
                    controller: _categoryController,
                    onCreate: api.createCat,
                    onAdd: (String value) {
                      setState(() {
                        _categories.add(value);
                      });
                    },
                  );
                },
              ),
              buildInputField(
                controller: _typeController,
                label: 'Type',
                hint: 'Entrez un type',
                onPressed: () async {
                  await handleCreateItem(
                    controller: _typeController,
                    onCreate: api.createType,
                    onAdd: (String value) {
                      setState(() {
                        _types.add(value);
                      });
                    },
                  );
                },
              ),
              buildInputField(
                controller: _tagController,
                label: 'Tag',
                hint: 'Entrez un tag',
                onPressed: () async {
                  await handleCreateItem(
                    controller: _tagController,
                    onCreate: api.createTag,
                    onAdd: (String value) {
                      setState(() {
                        _tags.add(value);
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> handleCreateItem({
    required TextEditingController controller,
    required Future<void> Function(String) onCreate,
    required Function(String) onAdd,
  }) async {
    String value = controller.text.trim();
    if (value.isNotEmpty) {
      try {
        await onCreate(value);
        setState(() {
          onAdd(value);
          controller.clear();
        });
      } catch (e) {
        // Handle the error appropriately (e.g., show an error message)
        print("Error: $e");
        // Optional: Display an error message to the user or log the error
      }
    }
  }

  /// Creates an input field widget
  Widget buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Future<void> Function() onPressed,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              cursorColor: Colors.teal,
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.teal),
                ),
              ),
            ),
          ),
          // Add an icon button with white icon, custom background color and rounded corners
          Container(
            margin: const EdgeInsets.only(left: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF000091), // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: onPressed,
              child: const Icon(
                Icons.add,
                color: Colors.white, // Icon color set to white
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a list view to display categories, types, or tags
  Widget buildListView(List<String> items, String emptyMessage) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      height: 100.0,
      child: ListView.builder(
        itemCount: items.isNotEmpty ? items.length : 1,
        itemBuilder: (context, index) {
          if (items.isEmpty) {
            return ListTile(
              title: Text(emptyMessage),
            );
          } else {
            return ListTile(
              title: Text(items[index]),
            );
          }
        },
      ),
    );
  }
}