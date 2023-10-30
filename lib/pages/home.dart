import 'package:agencia_viagens/components/trips_widget.dart';
import 'package:agencia_viagens/models/trips_model.dart';
import 'package:agencia_viagens/pages/register_trips.dart';
import 'package:agencia_viagens/services/database_trip.dart';
import 'package:flutter/material.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  final DatabaseTrips dbTrips = DatabaseTrips();
  List<Trip> trips = [];

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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Diario de Viagens"),
          actions: <Widget>[
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterTrips()));
                  // Recarregue os dados após retornar da página de adição
                  _loadTripsFromDatabase();
                }),
          ],
        ),
        body: ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final register = trips[index];
              return TripsWidget(register: register);
            }));
  }
}
