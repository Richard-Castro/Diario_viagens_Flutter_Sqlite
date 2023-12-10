import 'dart:io';

import 'package:agencia_viagens/models/details_model.dart';
import 'package:agencia_viagens/components/image_input.dart';
import 'package:agencia_viagens/models/trips_model.dart';
import 'package:agencia_viagens/pages/details_trips.dart';
import 'package:agencia_viagens/services/database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlterDetails extends StatefulWidget {
  final int? id;

  AlterDetails({required this.id, Key? key}) : super(key: key);

  @override
  AlterDetailsState createState() => AlterDetailsState();
}

class AlterDetailsState extends State<AlterDetails> {
  final DatabasesTrips dbDetails = DatabasesTrips();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? selectedStartDate;
  String? selectedEndDate;

  late File _selectedImage;

  List<Details> details = [];

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
  void initState() {
    super.initState();
    _loadTripsFromDatabase();
  }

  Future<void> _loadTripsFromDatabase() async {
    final detailsList = await dbDetails.getAllDetails();
    final int id = widget.id ?? 0;
    final Details detail = await _getDetailsById(id);
    setState(() {
      details = detailsList;

      titleController.text = detail.title;
      descriptionController.text = detail.description;
      selectedStartDate = detail.startDate;
      selectedEndDate = detail.endDate;
      _selectedImage = File(detail.imagePath);
    });
  }

  Future<Details> _getDetailsById(int id) async {
    final Details detail = await dbDetails.getDetailsById(id);
    return detail;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Executado quando o botão de voltar é pressionado
        Navigator.of(context).pop(); // Fecha a tela atual
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => DetailsTripsPage(
        //       register: widget.id,
        //     ), // Substitua MyHome pela sua tela inicial
        //   ),
        // );
        return false; // Retorna false para impedir que o Flutter pop a tela novamente
      },
      child: Scaffold(
        appBar: AppBar(title: const Text("Cadastro detalhes da Viagens")),
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
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side:
                              const BorderSide(color: Colors.white, width: 1.0),
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
                        _loadTripsFromDatabase();
                      },
                      child:
                          const Text('Salvar', style: TextStyle(fontSize: 20)),
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
