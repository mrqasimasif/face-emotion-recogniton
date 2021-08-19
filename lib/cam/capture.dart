import 'dart:io';
import 'package:femr_app/drawer.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dio/dio.dart';

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
                style: TextStyle(fontSize: 18),
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
      upload(imageFile);
      return Image.file(
        imageFile,
        width: 400,
        height: 500,
      );
    }
  }

  // image post to the uri

  _upLoadImage(File image) async {
    setState(() {
      prediction = "In Progress";
    });

    String path = image.path;
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    //var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    FormData formData = FormData.fromMap({
      "picture":
          await MultipartFile.fromFile(path, filename: basename(image.path))
    });

    Dio dio = new Dio();
    var respone = await dio.post<String>(
        "https://face-emotions-detection.azurewebsites.net/face_emotion_img/",
        data: formData);
    if (respone.statusCode == 200) {
      Fluttertoast.showToast(
          msg: 'Done!', gravity: ToastGravity.BOTTOM, textColor: Colors.grey);
      setState(() {
        prediction = jsonDecode(respone.data.toString())['prediction'];
      });
    }
  }

  var response = await http.post(Uri.parse(uploaduri), body: imageFile);
      if (response.statusCode == 200) {
        var jsondata = json.decode(response.body); //decode json data
        if (jsondata["error"]) {

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
    Navigator.of(context).pop();
  }
}
