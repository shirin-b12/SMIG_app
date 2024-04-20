import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class ConfirmationRessourceDialog extends StatelessWidget {
  final int ressourceId;
  final ApiService api = ApiService();

  ConfirmationRessourceDialog({required this.ressourceId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirmation'),
      content: Text('Do you want to validate or refuse?'),
      actions: <Widget>[
        TextButton(
          child: Text('Validate'),
          onPressed: () async {
            // Handle validation here
            await api.updateValidationRessource(ressourceId, true);
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Refuse'),
          onPressed: () async {
            // Handle refusal here
            await api.updateValidationRessource(ressourceId, false);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
