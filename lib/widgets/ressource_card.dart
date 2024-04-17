import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../models/ressource.dart';

class RessourceCard extends StatelessWidget {
  final Ressource ressource;

  RessourceCard({required this.ressource});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(25)),
        border: Border.all(
          color: Color(0xFFFFBD59),
          width: 0.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[200],
                //backgroundImage: ressource.createur.pic != null ? NetworkImage(ressource.createur.pic as String) : null,
                child: ressource.createur.pic == null ? const Icon(Icons.image, color : Color(0xFF03989E)) : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '${ressource.createur.nom} ${ressource.createur.prenom}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF015E62),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child : Text(
              ressource.titre,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF015E62),
              ),
            ),
          ),
          const SizedBox(height: 5),
        Center(
          child :
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Container(
                height: 70.0,
                width: 70.0,
                color: Color(0xFF03989E),
                child: ressource.image == null ? const Icon(Icons.image, color : Color(0xFFFFFFFF)) : null,
              ),
            ),
        ),
          Text(
            ressource.description,
            style: const TextStyle(
              color: Colors.black54,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }



}
