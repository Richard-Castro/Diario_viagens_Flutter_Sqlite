import 'dart:io';

import 'package:agencia_viagens/components/auth_trips.dart';
import 'package:agencia_viagens/models/details_model.dart';
import 'package:agencia_viagens/pages/alter_details.dart';
import '../services/database.dart';
import 'package:flutter/material.dart';

class DetailWidget extends StatelessWidget {
  final Details detail;
  final DatabasesTrips dbTrips = DatabasesTrips();
  final Authentication authTrips = Authentication();
  DetailWidget({required this.detail});

  Future<void> _editTodo(BuildContext context) async {
    bool auth = await Authentication.authentication();

    if (auth) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlterDetails(id: detail.id),
        ),
      );
    }
  }

  Future<void> _deleteTodo() async {
    bool auth = await Authentication.authentication();
    if (auth) {
      await dbTrips.deleteTrips(detail.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Dismissible(
        onDismissed: (direction) async {
          if (direction == DismissDirection.endToStart) {
            await _editTodo(context);
            // Implemente a lógica para editar o item
          } else if (direction == DismissDirection.startToEnd) {
            await _deleteTodo();
            // Implemente a lógica para excluir o item
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
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
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                detail.endDate,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                  // Exibição da imagem

                  detail.imagePath != null && detail.imagePath!.isNotEmpty
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(6.0),
                            bottomRight: Radius.circular(6.0),
                          ),
                          child: Image.file(
                            File(detail.imagePath!),
                            height: 150, // Ajuste a altura conforme necessário
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
