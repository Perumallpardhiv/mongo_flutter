import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class imageBase64String extends ChangeNotifier {
  Uint8List? imgUnit8List;
  String? base64Img;
  final ImagePicker _picker = ImagePicker();

  pickImageBase64() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    Uint8List imagebyte = await image.readAsBytes();
    imgUnit8List = imagebyte;
    String base64String = base64Encode(imagebyte);
    base64Img = base64String;

    notifyListeners();
  }

  maketonull() {
    imgUnit8List = null;
    base64Img = "";
    notifyListeners();
  }
}
