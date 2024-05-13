import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../models/tiny_ressource.dart';
import '../../views/page/ressource_page.dart';

class TinyRessourceCard extends StatefulWidget {
  final TinyRessource ressource;

  TinyRessourceCard({required this.ressource});

  @override
  _TinyRessourceCardState createState() => _TinyRessourceCardState();
}

class _TinyRessourceCardState extends State<TinyRessourceCard> {
  final ApiService api = ApiService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RessourcePage(resourceId: widget.ressource.id)),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(25)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.ressource.titre,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF015E62),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Color(0xFF03989E)),
              onPressed: () async {
                bool success = await api.deleteRessource(widget.ressource.id);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Resource deleted successfully'))
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Failed to delete resource'))
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
