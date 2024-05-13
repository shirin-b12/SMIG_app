import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ConfirmationRessourceDialog extends StatelessWidget {
  final int ressourceId;
  final bool reponce;
  final ApiService api = ApiService();

  ConfirmationRessourceDialog(
      {required this.ressourceId, required this.reponce});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Confirmation',
      ),
      content: Text(
        'Etes vous sur?',
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Valider',
          ),
          onPressed: () async {
            print(reponce);
            await api.updateValidationRessource(ressourceId, reponce);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'Annuler',
          ),
          onPressed: () async {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
