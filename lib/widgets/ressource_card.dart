import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../models/ressource.dart';

class RessourceCard extends StatefulWidget {
  final Ressource ressource;
  final ApiService api = ApiService();
  Future<int> fetchUserId() async {
    int? userId = await AuthService().getCurrentUser();
    return userId ?? 0; // return 0 or a default user ID if userId is null
  }

  RessourceCard({required this.ressource});

  Future<String> fetchUserRole() async {
    String? role = await AuthService().getCurrentUserRole();
    return role ?? '';
  }
  @override
  _RessourceCardState createState() => _RessourceCardState();
}

class _RessourceCardState extends State<RessourceCard> {
  bool isFavorite = false;
  late int userId;
  bool showMore = false;
  final ApiService api = ApiService();


  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    userId = await AuthService().getCurrentUser();
    bool currentFavorite = await api.isFavorite(widget.ressource.id, userId);
    if (mounted) {
      setState(() {
        isFavorite = currentFavorite;
      });
    }
  }


  String formatShortDate(String date) {
    final DateTime parsedDate = DateFormat('dd/MM/yyyy HH:mm:ss').parse(date);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          buildTopRow(),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    widget.ressource.titre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF015E62),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Catégorie: ${widget.ressource.category}",
                        style: const TextStyle(
                          color: Color(0xFF015E62),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Type: ${widget.ressource.type}",
                        style: const TextStyle(
                          color: Color(0xFF015E62),
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Align(
                  alignment: Alignment.center,
                  child: buildImageContainer(),
                ),
                buildToggleMoreButton(),
                Visibility(
                  visible: showMore,
                  child: buildAdditionalDetails(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget buildTopRow() {
    // Similar to your existing code, with Row for the main content
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        CircleAvatar(
          backgroundColor: Colors.grey[200],
          // Assuming Ressource.createur.pic is a String or null
          backgroundImage: widget.ressource.createur.pic != null
              ? NetworkImage(widget.ressource.createur!.getProfileImageUrl())
              : null,
          child: widget.ressource.createur.pic == null
              ? const Icon(Icons.person, color: Color(0xFF03989E))
              : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            '${widget.ressource.createur.nom} ${widget.ressource.createur.prenom}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF015E62),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: Icon(
            isFavorite ? Icons.star : Icons.star_border,
            color: isFavorite ? Color(0xFF03989E) : Colors.grey,
          ),
          onPressed: () async {
            bool success = await api.toggleFavorite(userId, widget.ressource.id);
            if (success) {
              setState(() {
                isFavorite = !isFavorite;
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update favorite status'))
              );
            }
          },
        )
      ],
    );
  }
  Widget buildToggleMoreButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          showMore = !showMore; // Toggle the state to show/hide details
        });
      },
      child: Text(showMore ? "moins..." : "plus...",
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Color(0xFF03989E),
        ),), // Change text based on state
    );
  }
  Widget buildImageContainer() {
    if (widget.ressource.image != null) {
      double screenWidth = MediaQuery.of(context).size.width;
      double screenHeight = MediaQuery.of(context).size.height;

      return Container(
        width: screenWidth * 0.8, // 80% of the screen width
        height: screenHeight * 0.4, // 40% of the screen height
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
            image: NetworkImage(widget.ressource.getRessourceImageUrl()),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      return SizedBox();  // Return an empty box if no image
    }
  }

  Widget buildAdditionalDetails() {
    return Column(
      children: [
        Text(
          '${widget.ressource.description}',
          style: const TextStyle(
            color: Color(0xFF015E62),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Text(
          'Tags: ${widget.ressource.tags}',
          style: const TextStyle(
            color: Color(0xFF015E62),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
        Text(
          'Date de publication: ${formatShortDate(widget.ressource.date_de_creation)}',
          style: const TextStyle(
            color: Color(0xFF015E62),
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
        ),
        // Include other details as needed
      ],
    );
  }
}
