import 'dart:io';

import 'package:agencia_viagens/models/details_model.dart';
import 'package:agencia_viagens/components/image_input.dart';
import 'package:agencia_viagens/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RegisterDetailsTrips extends StatefulWidget {
  final int? tripId;

  RegisterDetailsTrips({Key? key, required this.tripId}) : super(key: key);

  @override
  RegisterDetailsTripsState createState() => RegisterDetailsTripsState();
}

class RegisterDetailsTripsState extends State<RegisterDetailsTrips> {
  final DatabasesTrips dbDetails = DatabasesTrips();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedStartDate;
  String? selectedEndDate;
  late File _selectedImage; // New field for selected image

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        selectedStartDate = formatter.format(picked);
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        final DateFormat formatter = DateFormat('dd/MM/yyyy');
        selectedEndDate = formatter.format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Cadastro detalhes da Viagens ${widget.tripId}")),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.title, color: Colors.blue),
                    hintText: "Insira titulo",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.description, color: Colors.blue),
                    hintText: "Escreva uma descrição sobre a viagem",
                    hintStyle: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey, // Ajuste a cor conforme necessário
                        width: 1.0, // Ajuste a largura conforme necessário
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () => _selectStartDate(context),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),

                      shadowColor: MaterialStateProperty.all<Color>(
                          Colors.transparent), // Cor de fundo do botão
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal:
                                12), // Ajuste o preenchimento conforme necessário
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                            color: Colors.white), // Cor do texto do botão
                      ),

                      // Adicione mais propriedades conforme necessário
                    ),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Icon(Icons.date_range, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(
                            selectedStartDate ?? 'Data Inicio',
                            style: const TextStyle(
                                fontSize:
                                    16), // Ajuste o tamanho do texto conforme necessário
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.grey, // Ajuste a cor conforme necessário
                        width: 1.0, // Ajuste a largura conforme necessário
                      ),
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: () => _selectEndDate(context),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.transparent),
                      shadowColor: MaterialStateProperty.all<Color>(
                          Colors.transparent), // Cor de fundo do botão
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal:
                                12), // Ajuste o preenchimento conforme necessário
                      ),
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                            color: Colors.white), // Cor do texto do botão
                      ),
                      // Adicione mais propriedades conforme necessário
                    ),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Icon(Icons.date_range, color: Colors.blue),
                          const SizedBox(width: 10),
                          Text(
                            selectedEndDate ?? 'Data Fim',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Expanded(
                      child: ImageInput(onImageSelected: (File image) {
                        setState(() {
                          _selectedImage = image;
                        });
                      }),
                    ),
                  ],
                ),
                // ImageInput widget for capturing or selecting images
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          const MaterialStatePropertyAll(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: const BorderSide(color: Colors.white, width: 1.0),
                      )),
                      foregroundColor:
                          MaterialStateProperty.all<Color>(Colors.white),
                    ),
                    onPressed: () async {
                      final title = titleController.text;
                      final description = descriptionController.text;

                      if (title.isNotEmpty &&
                          description.isNotEmpty &&
                          selectedStartDate != null &&
                          selectedEndDate != null) {
                        final newTrip = Details(
                          id: 0,
                          tripId: widget.tripId,
                          title: title,
                          description: description,
                          startDate: selectedStartDate!,
                          endDate: selectedEndDate!,
                          imagePath: _selectedImage.path,
                        );
                        await dbDetails.insertDetails(newTrip.toMap());

                        titleController.clear();
                        descriptionController.clear();

                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                          const SnackBar(
                            content: Text('Viagem adicionada com sucesso!'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Por favor, preencha todos os campos.'),
                          ),
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: const Text('Salvar', style: TextStyle(fontSize: 20)),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
