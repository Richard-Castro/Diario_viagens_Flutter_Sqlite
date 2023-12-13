import 'dart:io';

import 'package:agencia_viagens/models/trips_model.dart';
import 'package:agencia_viagens/components/image_input.dart';
import 'package:agencia_viagens/pages/main_page.dart';
import '../services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlterTrips extends StatefulWidget {
  final int? id;
  AlterTrips({required this.id, Key? key}) : super(key: key);

  @override
  AlterTripsState createState() => AlterTripsState();
}

class AlterTripsState extends State<AlterTrips> {
  final DatabasesTrips dbTrips = DatabasesTrips();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedStartDate;
  String? selectedEndDate;
  late File _selectedImage = File('');
  List<Trips> trips = []; // New field for selected image

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final String newStartDate = formatter.format(picked);

      if (selectedEndDate == null ||
          newStartDate.compareTo(selectedEndDate!) <= 0) {
        setState(() {
          selectedStartDate = newStartDate;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Data de início não pode ser maior que a data de término.'),
          ),
        );
      }
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
      final DateFormat formatter = DateFormat('dd/MM/yyyy');
      final String newEndDate = formatter.format(picked);

      if (selectedStartDate == null ||
          newEndDate.compareTo(selectedStartDate!) >= 0) {
        setState(() {
          selectedEndDate = newEndDate;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Data de término não pode ser menor que a data de início.'),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTripsFromDatabase();
  }

  Future<void> _loadTripsFromDatabase() async {
    final tripsList = await dbTrips.getAllTrips();
    final int id = widget.id ?? 0;
    final Trips trip = await _getTripById(id);
    setState(() {
      trips = tripsList;
      titleController.text = trip.title;
      descriptionController.text = trip.description;
      selectedStartDate = trip.startDate;
      selectedEndDate = trip.endDate;
      _selectedImage = File(trip.imagePath);
    });
  }

  Future<Trips> _getTripById(int id) async {
    final Trips trip = await dbTrips.getTripById(id);
    return trip;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Alterar Cadastro de Viagens")),
        body: Builder(
          builder: (BuildContext scaffoldContext) {
            return SingleChildScrollView(
              child: Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
                            color:
                                Colors.grey, // Ajuste a cor conforme necessário
                            width: 1.0, // Ajuste a largura conforme necessário
                          ),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => _selectStartDate(context),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),

                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.transparent), // Cor de fundo do botão
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
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
                            color:
                                Colors.grey, // Ajuste a cor conforme necessário
                            width: 1.0, // Ajuste a largura conforme necessário
                          ),
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () => _selectEndDate(context),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.transparent),
                          shadowColor: MaterialStateProperty.all<Color>(
                              Colors.transparent), // Cor de fundo do botão
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry>(
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
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blue),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: const BorderSide(
                                color: Colors.white, width: 1.0),
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
                              selectedEndDate != null &&
                              _selectedImage.path.isNotEmpty) {
                            final newTrip = Trips(
                              id: widget.id,
                              title: title,
                              description: description,
                              startDate: selectedStartDate!,
                              endDate: selectedEndDate!,
                              imagePath: _selectedImage.path,
                            );
                            await dbTrips.updateTrips(newTrip.toMap());

                            titleController.clear();
                            descriptionController.clear();

                            await ScaffoldMessenger.of(scaffoldContext)
                                .showSnackBar(
                              const SnackBar(
                                content: Text('Viagem adicionada com sucesso!'),
                              ),
                            );
                            Navigator.pop(context);
                          } else {
                            await ScaffoldMessenger.of(scaffoldContext)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Por favor, preencha todos os campos.'),
                              ),
                            );
                          }
                        },
                        child: const Text('Salvar',
                            style: TextStyle(fontSize: 20)),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
