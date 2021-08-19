import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

// ignore: must_be_immutable
class Scan extends StatefulWidget {
  @override
  ScanState createState() {
    return new ScanState();
  }
}

class ScanState extends State<Scan> {
  List _outputs;

  // Input file
  File imageFile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  pickImage() async {
    // ignore: deprecated_member_use
    var imageFile = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(imageFile.path) as PickedFile;
    });
  }

  _openGallery(BuildContext context) async {
    // ignore: deprecated_member_use
    var picture = await ImagePicker().getImage(source: ImageSource.gallery);
    this.setState(() {
      imageFile = File(picture.path);
    });
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    // ignore: deprecated_member_use
    var picture = await ImagePicker().getImage(source: ImageSource.camera);
    this.setState(() {
      imageFile = File(picture.path);
    });

    Navigator.of(context).pop();
  }

  Widget _decideImage() {
    if (imageFile == null) {
      return Text("No Image Selected");
    } else {
      return Image.file(
        imageFile,
        width: 400,
        height: 400,
      );
    }
  }

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
                      _openGallery(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Image Captured"),
        ),
        body: Container(
            child: Center(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _decideImage(),
            Container(
              margin: EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  imageFile == null ? Container() : Image.file(imageFile),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Predictions Suck"),
                  imageFile == null
                      ? Container()
                      : _outputs != null
                          ? Text(
                              "${_outputs[0]["label"]}",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  background: Paint()..color = Colors.white),

                              // _outputs != null ?
                              // Text(_outputs[0]["labels"],style: TextStyle(color: Colors.white ,fontSize: 20),
                            )
                          : Container(child: Text(""))
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {
                _showChoice(context);
              },
              child: Text("Select Image"),
            )
          ],
        ))));
  }
}
