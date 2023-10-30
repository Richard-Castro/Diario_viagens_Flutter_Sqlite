import 'package:agencia_viagens/models/trips_model.dart';
import 'package:flutter/material.dart';

class TripsWidget extends StatelessWidget {
  final Trip register;

  TripsWidget({required this.register});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: ListTile(
        title: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(register.title),
              const SizedBox(height: 5),
              Text(register.description),
              const SizedBox(height: 5),
              Text(register.date),
            ],
          ),
        ),
      ),
    );
  }
}
