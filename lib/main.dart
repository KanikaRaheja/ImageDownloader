import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

// class _MyAppState extends State<MyApp> {
//   Position? _position;

//   void _getCurrentLocation() async {
//     Position position = await _determinePosition();
//     setState(() {
//       _position = position;
//     });
//   }
// }

class _MyAppState extends State<MyApp> {
  Position? _position;

  void _getCurrentLocation() async {
    // Position position = await Geolocator.getCurrentPosition();
    // print(position);

    Position position = await _determinePosition();
    setState(() {
      if (position != null) {
        _position = position;
      } else {
        print("geo");
      }
    });
  }

  Future<Position> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  var _image;
  var image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickerimage = await picker.getImage(source: ImageSource.camera);

    setState(() {
      if (pickerimage != null) {
        // image = pickerimage.path;
        _image = File(pickerimage.path);
      } else {
        print("No image selected!!");
      }
    });
  }

  Future downloadImage(image) async {
    await GallerySaver.saveImage(image.path);
  }

  @override
  Widget build(BuildContext context) {
    var time = DateTime.now();
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text("Flutter image picker!!")),
            body: Column(
              children: [
                Container(
                  child: _image == null
                      ? Text("no image selected")
                      : Image.file(_image),
                ),
                Container(
                  child: _position != null
                      ? Text('Current Location: ' + _position.toString())
                      : Text("position"),
                ),
                Container(child: Text("current Date/Time : $time")),
              ],
            ),
            floatingActionButton:
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              FloatingActionButton(
                child: Icon(Icons.download),
                onPressed: () {
                  downloadImage(_image);
                },
                heroTag: null,
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                onPressed: () {
                  getImage();
                  _getCurrentLocation();
                },
                child: Icon(Icons.camera),
              ),
            ])));
  }
}
