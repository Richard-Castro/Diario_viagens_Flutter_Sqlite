import 'package:agencia_viagens/components/trips_widget.dart';
import 'package:agencia_viagens/models/trips_model.dart';
import 'package:agencia_viagens/pages/register_trips.dart';
import 'package:agencia_viagens/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
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
          title: const Text("Diario de Viagens"),
          actions: <Widget>[
            IconButton(
                icon: const Icon(
                  Icons.add_circle,
                ),
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
        body: Container(
          child: ListView.builder(
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final register = trips[index];
                if (register.endDate != null) {
                  DateTime endDate =
                      DateFormat('dd/MM/yyyy').parse(register.endDate!);

                  if (endDate.isBefore(currentDate)) {
                    return TripsWidget(register: register);
                  }
                }
                return Container();
              }),
        ));
  }
}
