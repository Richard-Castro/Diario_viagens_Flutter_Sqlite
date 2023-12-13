import 'dart:async';
import 'dart:io';

import 'package:agencia_viagens/components/auth_trips.dart';
import 'package:agencia_viagens/components/details_widget.dart';
import 'package:agencia_viagens/models/details_model.dart';
import 'package:agencia_viagens/models/trips_model.dart';
import 'package:agencia_viagens/pages/alter_details.dart';
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

  Future<void> _editTodo(BuildContext context, Details detail) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlterDetails(
          id: detail.id,
          tripId: detail.tripId,
        ),
      ),
    );
    _loadDetailsFromDatabase();
  }

  Future<void> _deleteTodo(Details detail) async {
    bool auth = await Authentication.authentication();
    if (auth) {
      await dbTrips.deleteDetails(detail.id);
      _loadDetailsFromDatabase(); // Atualiza a lista após a exclusão
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.add_circle),
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
              Row(
                children: [
                  Icon(Icons.location_city),
                  SizedBox(width: 8),
                  Text(
                    widget.register.title,
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Text(
                widget.register.description,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    'Início: ${widget.register.startDate}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 202, 202, 202),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Fim: ${widget.register.endDate}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 202, 202, 202),
                    ),
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
                height: 50,
              ),
              Row(
                children: [
                  Icon(Icons.dehaze),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "Mais detalhes da viagem",
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ],
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

              return InkWell(
                onLongPress: () {
                  // Aqui você pode adicionar a lógica para editar o registro
                  _editTodo(context, detail);
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Dismissible(
                    onDismissed: (direction) async {
                      if (direction == DismissDirection.endToStart) {
                        await _deleteTodo(detail);
                      }
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    key: Key(detail.id.toString()),
                    child: ListTile(
                      title: InkWell(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6)),
                          elevation: 8,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        detail.title,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        detail.description,
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Text(
                                            detail.startDate,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            detail.endDate,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                              // Exibição da imagem

                              detail.imagePath != null &&
                                      detail.imagePath!.isNotEmpty
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(6.0),
                                        bottomRight: Radius.circular(6.0),
                                      ),
                                      child: Image.file(
                                        File(detail.imagePath!),
                                        height:
                                            150, // Ajuste a altura conforme necessário
                                        width:
                                            180, // Ajuste a largura conforme necessário
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}
