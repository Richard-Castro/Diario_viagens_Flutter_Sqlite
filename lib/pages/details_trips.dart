import 'dart:io';

import 'package:agencia_viagens/components/details_widget.dart';
import 'package:agencia_viagens/components/view_details.dart';
import 'package:agencia_viagens/models/details_model.dart';
import 'package:agencia_viagens/models/trips_model.dart';
import 'package:agencia_viagens/pages/register_details_trips.dart';
import '../services/database.dart';
import 'package:flutter/material.dart';

class DetailsTripsPage extends StatefulWidget {
  final Trips register;
  const DetailsTripsPage({
    Key? key,
    required this.register,
  }) : super(key: key);

  @override
  State<DetailsTripsPage> createState() => _DetailsTripsPageState();
}

class _DetailsTripsPageState extends State<DetailsTripsPage> {
  final DatabasesTrips dbTrips = DatabasesTrips();

  List<Trips> trips = [];
  List<Details> details = [];

  @override
  void initState() {
    super.initState();
    _loadTripsFromDatabase();
    _loadDetailsFromDatabase();
  }

  Future<void> _loadTripsFromDatabase() async {
    final tripsList = await dbTrips.getAllTrips();

    setState(() {
      trips = tripsList;
    });
  }

  Future<void> _loadDetailsFromDatabase() async {
    final detailsList = await dbTrips.getAllDetails();
    setState(() {
      details = detailsList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final tripId = widget.register.id;

                await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegisterDetailsTrips(tripId: tripId),
                    ));
                // Recarregue os dados após retornar da página de adição
                _loadTripsFromDatabase();
                _loadDetailsFromDatabase();
              }),
        ],
      ),
      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.register.title,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                widget.register.description,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    widget.register.startDate,
                    style: const TextStyle(fontSize: 15),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  const Text("até"),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    widget.register.endDate,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              widget.register.imagePath != null &&
                      widget.register.imagePath!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        File(widget.register.imagePath!),
                        height: 220, // Ajuste a altura conforme necessário
                        width: 350, // Ajuste a largura conforme necessário
                        fit: BoxFit.cover,
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 30,
              ),
              Text(
                "Mais detalhes da viagem : ${widget.register.title}",
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            // itemCount: details.length,
            // itemBuilder: (context, index) {
            //   final detail = details[index];
            itemCount: details
                .where((detail) => detail.tripId == widget.register.id)
                .length,
            itemBuilder: (context, index) {
              final filteredDetails = details
                  .where((detail) => detail.tripId == widget.register.id)
                  .toList();
              final detail = filteredDetails[index];

              return DetailWidget(detail: detail);
            },
          ),
        ),
      ]),
    );
  }
}
