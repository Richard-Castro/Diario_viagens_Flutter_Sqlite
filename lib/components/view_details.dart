import 'package:agencia_viagens/models/details_model.dart';
import 'package:agencia_viagens/models/trips_model.dart';
import 'package:agencia_viagens/services/database.dart';
import 'package:flutter/material.dart';

class ViewDetail extends StatefulWidget {
  final Trips register;
  final DatabasesTrips dbTrips = DatabasesTrips();
  ViewDetail({required this.register});

  @override
  State<ViewDetail> createState() => _ViewDetailState();
}

class _ViewDetailState extends State<ViewDetail> {
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
        body: Container(
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

          return ListTile(
            title: Card(
              child: Column(
                children: [
                  Text(detail.title),
                  Text(detail.description),
                  Text(detail.tripId.toString()),
                ],
              ),
            ),
          );
        },
      ),
    ));
  }
}
