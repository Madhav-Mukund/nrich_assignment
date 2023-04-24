import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageUploadScreen extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<ImageUploadScreen> {
  File? _image;
  final blue = const Color.fromARGB(255, 26, 35, 126);
  final yellow = const Color.fromARGB(255, 255, 193, 7);

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_image == null) {
      return;
    }

    var request = http.MultipartRequest(
        'POST', Uri.parse('https://codelime.in/api/remind-app-token'));

    request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('The image has been uploaded successfully.'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Upload failed. Try again.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Upload Image',
            style: GoogleFonts.lato(),
          ),
          backgroundColor: blue,
          shape: Border(
            bottom: BorderSide(color: yellow, width: 3),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 72, 72, 72),
            ),
            height: 560,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _image == null
                    ? Row()
                    : Row(
                        children: [
                          const Spacer(),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _image = null;
                                });
                              },
                              icon: const Icon(Icons.cancel_outlined))
                        ],
                      ),
                _image == null
                    ? Text(
                        'No image selected',
                        style: GoogleFonts.lato(fontSize: 16),
                      )
                    : Image.file(_image!, width: 360, height: 360),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: _getImageFromGallery,
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(blue)),
                  child: Text(
                    'Select Image',
                    style: GoogleFonts.lato(
                        color: yellow, fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                  onPressed: _uploadImage,
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(blue)),
                  child: Text(
                    'Upload Image',
                    style: GoogleFonts.lato(
                        color: yellow, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
