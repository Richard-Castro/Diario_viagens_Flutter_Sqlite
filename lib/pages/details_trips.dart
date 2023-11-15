import 'dart:io';

import 'package:agencia_viagens/models/trips_model.dart';
import 'package:flutter/material.dart';

class DetailsTripsPage extends StatelessWidget {
  final Trip register;
  const DetailsTripsPage({
    super.key,
    required this.register,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  register.title,
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  register.description,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      register.startDate,
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
                      register.endDate,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                register.imagePath != null && register.imagePath!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(register.imagePath!),
                          height: 220, // Ajuste a altura conforme necessário
                          width: 350, // Ajuste a largura conforme necessário
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Mais detalhes da viagem :",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
