import 'package:agencia_viagens/models/trips_model.dart';
import 'package:flutter/material.dart';

class TripsWidget extends StatelessWidget {
  final Trip register;

  TripsWidget({required this.register});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(register.title),
          Text(register.description),
        ],
      ),
    );
  }
}
