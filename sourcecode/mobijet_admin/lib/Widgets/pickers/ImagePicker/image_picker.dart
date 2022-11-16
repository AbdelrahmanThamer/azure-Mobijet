//*************   © Copyrighted by Thinkcreative_Technologies. An Exclusive item of Envato market. Make sure you have purchased a Regular License OR Extended license for the Source Code from Envato to use this product. See the License Defination attached with source code. *********************

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:thinkcreative_technologies/Configs/my_colors.dart';
import 'package:thinkcreative_technologies/Configs/number_limits.dart';
import 'package:thinkcreative_technologies/Utils/open_settings.dart';
import 'package:thinkcreative_technologies/Utils/utils.dart';

class SingleImagePicker extends StatefulWidget {
  SingleImagePicker(
      {Key? key,
      required this.title,
      required this.callback,
      this.recommendedsize,
      this.profile = false})
      : super(key: key);

  final String title;
  final String? recommendedsize;
  final Function callback;
  final bool profile;

  @override
  _SingleImagePickerState createState() => new _SingleImagePickerState();
}

class _SingleImagePickerState extends State<SingleImagePicker> {
  File? _imageFile;
  ImagePicker picker = ImagePicker();
  bool isLoading = false;
  String? error;
  @override
  void initState() {
    super.initState();
  }

  void captureImage(ImageSource captureMode) async {
    error = null;
    try {
      XFile? pickedImage = await (picker.pickImage(source: captureMode));
      if (pickedImage != null) {
        _imageFile = File(pickedImage.path);
        setState(() {});
        if (_imageFile!.lengthSync() / 1000000 >
            Numberlimits.maxImageFileUpload) {
          error =
              'File should be less than ${Numberlimits.maxImageFileUpload}MB\n\nSelected file size is ${(_imageFile!.lengthSync() / 1000000).round()}MB';

          setState(() {
            _imageFile = null;
          });
        } else {
          setState(() {
            _imageFile = File(_imageFile!.path);
          });
        }
      }
    } catch (e) {}
  }

  Widget _buildImage() {
    if (_imageFile != null) {
      return new Image.file(_imageFile!);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          new Text("Take an image",
              textAlign: TextAlign.center,
              style: new TextStyle(
                fontSize: 18.0,
                color: Mycolors.black,
              )),
          widget.recommendedsize == null
              ? SizedBox()
              : SizedBox(
                  height: 58,
                ),
          widget.recommendedsize == null
              ? SizedBox()
              : new Text("Recommended Size\n\n" + widget.recommendedsize!,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    height: 1.0,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w400,
                    color: Mycolors.grey,
                  )),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Mycolors.white,
        appBar: new AppBar(
            elevation: 0.4,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.keyboard_arrow_left,
                size: 30,
                color: Mycolors.black,
              ),
            ),
            title: new Text(
              widget.title,
              style: TextStyle(
                fontSize: 18,
                color: Mycolors.black,
              ),
            ),
            backgroundColor: Mycolors.white,
            actions: _imageFile != null
                ? <Widget>[
                    IconButton(
                        icon: Icon(Icons.check, color: Mycolors.primary),
                        onPressed: () {
                          setState(() {
                            isLoading = true;
                          });
                          widget.callback(_imageFile).then((imageUrl) {
                            Navigator.pop(context, imageUrl);
                          });
                        }),
                    SizedBox(
                      width: 8.0,
                    )
                  ]
                : []),
        body: Stack(children: [
          new Column(children: [
            new Expanded(
                child: new Center(
                    child: error != null
                        ? Center(
                            child: Padding(
                            padding: const EdgeInsets.all(28.0),
                            child: Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                            ),
                          ))
                        : _buildImage())),
            _buildButtons()
          ]),
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Mycolors.loadingindicator)),
                    ),
                    color: Mycolors.white,
                  )
                : Container(),
          )
        ]),
      ),
      onWillPop: () => Future.value(!isLoading),
    );
  }

  Widget _buildButtons() {
    return new ConstrainedBox(
        constraints: BoxConstraints.expand(height: 80.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _buildActionButton(new Key('retake'), Icons.photo_library, () {
                Utils.checkAndRequestPermission(Permission.photos).then((res) {
                  if (res) {
                    captureImage(ImageSource.gallery);
                  } else {
                    Utils.toast(
                        "Gallery Access permission required. Please allow it to continue");
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => OpenSettings()));
                  }
                });
              }),
              _buildActionButton(new Key('upload'), Icons.photo_camera, () {
                Utils.checkAndRequestPermission(Permission.camera).then((res) {
                  if (res) {
                    captureImage(ImageSource.camera);
                  } else {
                    Utils.toast(
                        "Camera Access permission required. Please allow it to continue");
                    Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => OpenSettings()));
                  }
                });
              }),
            ]));
  }

  Widget _buildActionButton(Key key, IconData icon, Function onPressed) {
    return new Expanded(
      // ignore: deprecated_member_use
      child: new RaisedButton(
          key: key,
          child: Icon(icon, size: 30.0),
          shape: new RoundedRectangleBorder(),
          color: Mycolors.secondary,
          textColor: Mycolors.white,
          onPressed: onPressed as void Function()?),
    );
  }
}
