import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function(File) onImageSelected;

  ImageInput({Key? key, required this.onImageSelected}) : super(key: key);

  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _imageFile; // Initialize with a default value

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: 400,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.white),
          ),
          child: _imageFile != null
              ? Image.file(
                  _imageFile!,
                  fit: BoxFit.cover,
                )
              : Icon(Icons.image),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final XFile? imageFile = await picker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (imageFile != null) {
                    final File selectedImage = File(imageFile.path);
                    setState(() {
                      _imageFile = selectedImage;
                    });
                    widget.onImageSelected(selectedImage);
                  }
                },
                child: Text("Escolher Imagem"),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.blue, width: 1.0),
                      ),
                    ),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent),
                    shadowColor: MaterialStatePropertyAll(Colors.transparent)),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Container(
                child: ElevatedButton(
                  onPressed: () async {
                    final picker = ImagePicker();
                    final XFile? imageFile = await picker.pickImage(
                      source: ImageSource.camera,
                      maxWidth: 600,
                    );

                    if (imageFile != null) {
                      final File capturedImage = File(imageFile.path);
                      setState(() {
                        _imageFile = capturedImage;
                      });
                      widget.onImageSelected(capturedImage);
                    }
                  },
                  child: Text(
                    "Capturar Foto",
                    style: TextStyle(),
                  ),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.blue, width: 1.0),
                        ),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      shadowColor:
                          MaterialStatePropertyAll(Colors.transparent)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
