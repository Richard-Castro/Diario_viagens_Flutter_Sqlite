import 'dart:io';

import 'package:agencia_viagens/components/trips_widget.dart';
import 'package:agencia_viagens/models/trips_model.dart';
import 'package:agencia_viagens/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProcessTrips extends StatefulWidget {
  const ProcessTrips({super.key});

  @override
  State<ProcessTrips> createState() => _ProcessTripsState();
}

class _ProcessTripsState extends State<ProcessTrips> {
  final DatabasesTrips dbTrips = DatabasesTrips();

  List<Trips> trips = [];

  @override
  void initState() {
    super.initState();
    _loadTripsFromDatabase();
  }

  Future<void> _loadTripsFromDatabase() async {
    final tripsList = await dbTrips.getAllTrips();
    setState(() {
      trips = tripsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDate = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Viagens em processo"),
      ),
      body: Container(
        child: ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {
            final register = trips[index];
            if (register.endDate != null) {
              DateTime endDate =
                  DateFormat('dd/MM/yyyy').parse(register.endDate!);

              if (endDate.isAfter(currentDate)) {
                return TripsWidget(register: register);
              }
            }
            // Retorna um contêiner vazio se a condição não for atendida
            return Container();
          },
        ),
      ),
    );
  }
}
