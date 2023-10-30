import 'package:agencia_viagens/models/trips_model.dart';
import 'package:agencia_viagens/services/database_trip.dart';
import 'package:flutter/material.dart';

class RegisterTrips extends StatefulWidget {
  const RegisterTrips({Key? key}) : super(key: key);

  @override
  RegisterTripsState createState() => RegisterTripsState();
}

class RegisterTripsState extends State<RegisterTrips> {
  final DatabaseTrips dbTrips = DatabaseTrips();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro de Viagens")),
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          // Capture the context
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("Insira um titulo"),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    hintText: "Ex Viagem para Paris",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Descrição"),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    hintText: "Escreva uma descrição sobre a viagem",
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text("Data"),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(
                    hintText: "Data da viagem",
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () async {
                    final title = titleController.text;
                    final description = descriptionController.text;

                    if (title.isNotEmpty && description.isNotEmpty) {
                      final newTrip = Trip(
                        id: 0,
                        title: title,
                        description: description,

                        //date: DateTime('date'),
                      ); // O 'id' pode ser 0 se você desejar que ele seja gerado automaticamente (se configurado assim no banco de dados).
                      await dbTrips.insertTrip(newTrip.toMap());

                      titleController.clear();
                      descriptionController.clear();
                      dateController.clear();

                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        // Use the captured context
                        const SnackBar(
                          content: Text('Viagem adicionada com sucesso!'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                        // Use the captured context
                        const SnackBar(
                          content: Text('Por favor, preencha todos os campos.'),
                        ),
                      );
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Salvar', style: TextStyle(fontSize: 20)),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
