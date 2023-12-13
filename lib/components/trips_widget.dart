// ignore_for_file: unused_import

import 'dart:io';

import 'package:agencia_viagens/components/auth_trips.dart';
import 'package:agencia_viagens/models/trips_model.dart';
import 'package:agencia_viagens/pages/alter_trips.dart';
import 'package:agencia_viagens/pages/details_trips.dart';
import '../services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TripsWidget extends StatefulWidget {
  final Trips register;

  TripsWidget({required this.register});

  @override
  State<TripsWidget> createState() => _TripsWidgetState();
}

class _TripsWidgetState extends State<TripsWidget> {
  final DatabasesTrips dbTrips = DatabasesTrips();

  final Authentication authTrips = Authentication();

  Future<void> _editTodo(BuildContext context) async {
    //bool auth = await Authentication.authentication();

    // if (auth) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlterTrips(id: widget.register.id),
      ),
    );
    //s}
  }

  Future<void> _deleteTodo() async {
    bool auth = await Authentication.authentication();
    if (auth) {
      await dbTrips.deleteTrips(widget.register.id);
     
    }
  }

  // var detailsTrips = Trip(
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Dismissible(
        onDismissed: (direction) async {
          if (direction == DismissDirection.endToStart) {
            await _editTodo(context);
          } else if (direction == DismissDirection.startToEnd) {
            await _deleteTodo();
          }

          print('Falha na autenticação. A exclusão não é permitida.');
        },
        background: Container(
          color: Colors.red,
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 16),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        secondaryBackground: Container(
          color: Colors.orange,
          child: const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ),
        ),
        key: Key(widget.register.id.toString()),
        child: ListTile(
          title: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailsTripsPage(
                            register: widget.register,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.register.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            widget.register.description,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Text(
                                widget.register.startDate,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                widget.register.endDate,
                                style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
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

                  widget.register.imagePath != null &&
                          widget.register.imagePath!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0),
                          ),
                          child: Image.file(
                            File(widget.register.imagePath!),
                            height: 200, // Ajuste a altura conforme necessário
                            width: 180, // Ajuste a largura conforme necessário
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
    );
  }
}
