import 'dart:io';
import 'package:femr_app/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'package:http/http.dart' as http;

class Camcorder extends StatefulWidget {
  @override
  _CamcorderState createState() => _CamcorderState();
}

class _CamcorderState extends State<Camcorder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  File imageFile;
  var prediction = "No Prediction Yet";
  String url =
      "https://face-emotions-detection.azurewebsites.net/face_emotion_img/";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image Picker"),
      ),
      drawer: NavDrawer(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "$prediction",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _decideImage(),
              SizedBox(
                height: 20,
              ),
              Container(
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.blue,
                  onPressed: () {
                    _showChoice(context);
                  },
                  child: Text(
                    "Select Image",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // choice of image
  Widget _decideImage() {
    if (imageFile == null) {
      return Text("No Image Selected");
    } else {
      return Image.file(
        imageFile,
        width: 400,
        height: 500,
      );
    }
  }

  uploadToAzure(String imageFile, String url) async {
    setState(() {
      prediction = "In progress : Wait";
    });

    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('picture', imageFile));
    var res = await request.send();
    var resString = await res.stream.bytesToString();

    setState(() {
      prediction = resString;
      Fluttertoast.showToast(
          msg: "Predication Done",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 15.0);
    });
  }

  //the choice of input
  Future<void> _showChoice(BuildContext context) async {
    showDialog(
        context: context,
        // ignore: missing_return
        builder: (context) {
          return AlertDialog(
            title: Text("Make a Choice!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _getFromGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _getFromCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  /// Get from gallery
  _getFromGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    uploadToAzure(pickedFile.path, url);
    Navigator.of(context).pop();
  }

  /// Get from Camera
  _getFromCamera(BuildContext context) async {
    // ignore: deprecated_member_use
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
    uploadToAzure(pickedFile.path, url);
    Navigator.of(context).pop();
  }
}
