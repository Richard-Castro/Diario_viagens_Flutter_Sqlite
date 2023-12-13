import 'dart:io';

import 'package:agencia_viagens/components/auth_trips.dart';
import 'package:agencia_viagens/components/trips_widget.dart';
import 'package:agencia_viagens/models/trips_model.dart';
import 'package:agencia_viagens/pages/alter_trips.dart';
import 'package:agencia_viagens/pages/details_trips.dart';
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

  Future<void> _editTodo(BuildContext context, Trips register) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlterTrips(id: register.id),
      ),
    );
    _loadTripsFromDatabase();
  }

  Future<void> _deleteTodo(Trips register) async {
    bool auth = await Authentication.authentication();
    if (auth) {
      await dbTrips.deleteTrips(register.id);
      _loadTripsFromDatabase();
    }
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
                    return InkWell(
                      onLongPress: () {
                        _editTodo(context, register);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Dismissible(
                          onDismissed: (direction) async {
                            if (direction == DismissDirection.startToEnd) {
                              await _deleteTodo(register);
                            }

                            print(
                                'Falha na autenticação. A exclusão não é permitida.');
                          },
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 16),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                          key: Key(register.id.toString()),
                          child: ListTile(
                            title: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => DetailsTripsPage(
                                              register: register,
                                            )));
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                elevation: 8,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              register.title,
                                              style: const TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 15),
                                            Text(
                                              register.description,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const SizedBox(height: 30),
                                            Row(
                                              children: [
                                                Text(
                                                  register.startDate,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey),
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  register.endDate,
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Exibição da imagem

                                    register.imagePath != null &&
                                            register.imagePath!.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(6.0),
                                              bottomRight: Radius.circular(6.0),
                                            ),
                                            child: Image.file(
                                              File(register.imagePath!),
                                              height:
                                                  200, // Ajuste a altura conforme necessário
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
                  }
                }
                return Container();
              }),
        ));
  }
}
