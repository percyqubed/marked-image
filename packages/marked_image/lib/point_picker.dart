import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'point_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

import 'widget_information.dart';

class PointPicker extends StatefulWidget {
  PointPicker({Key? key, required this.imageAsset}) : super(key: key);

  final String imageAsset;
  @override
  _PointPickerState createState() => _PointPickerState();
}

class _PointPickerState extends State<PointPicker> {
  File? _image;
  double _imagePositionX = 0;
  double _imagePositionY = 0;

  double _originalImageWidth = 0;
  double _originalImageHeight = 0;
  double _imageAspectRatio = 0;

  double _imageWidth = 400;
  double _imageHeight = 0;

  double _pointerX = 0;
  double _pointerY = 0;

  double _pointerXRatio = 0;
  double _pointerYRatio = 0;

  @override
  void initState() {
    super.initState();
    getImage();
  }

  _setCurrentPoint(Offset offset) {
    var x = offset.dx;
    var y = offset.dy;

    print('X: $x, Y: $y');

    var imageX = x - _imagePositionX;
    var imageY = y - _imagePositionY;

    setState(() {
      _pointerXRatio = imageX / _imageWidth;
      _pointerYRatio = imageY / _imageHeight;
      _pointerX = imageX;
      _pointerY = imageY;
    });
  }

  _onPointerDown(PointerDownEvent event) {
    _setCurrentPoint(event.position);
  }

  _onPointerUp(PointerUpEvent event) {
    _setCurrentPoint(event.position);
  }

  _onPointerMove(PointerMoveEvent event) {
    _setCurrentPoint(event.position);
  }

  Future<File> getImageFileFromAssets(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    String fileName = basename(assetPath);
    Directory dir = await getApplicationDocumentsDirectory();
    final String temporaryPath = '${dir.path}/$fileName';
    final file = File(temporaryPath);
    await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future getImage() async {
    var image = await getImageFileFromAssets(widget.imageAsset);
    var decodedImage = await decodeImageFromList(image.readAsBytesSync());
    setState(() {
      _originalImageHeight = decodedImage.height.toDouble();
      _originalImageWidth = decodedImage.width.toDouble();
      _imageAspectRatio = _originalImageWidth / _originalImageHeight;

      print('Width: $_originalImageWidth');
      print('Height: $_originalImageHeight');
      print('Aspect Ratio: $_imageAspectRatio');
      _imageHeight = _imageWidth / _imageAspectRatio;
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Point Picker'),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        child: _image != null
            ? Center(
                child: Stack(
                  children: [
                    WidgetInfomation(
                      onChange: (data) {
                        Offset position = data[WidgetInfo.position];
                        setState(() {
                          _imagePositionX = position.dx;
                          _imagePositionY = position.dy;
                        });
                      },
                      child: Image(
                        image: FileImage(_image!),
                        height: _imageHeight,
                        width: _imageWidth,
                      ),
                    ),
                    Listener(
                      onPointerDown: _onPointerDown,
                      onPointerUp: _onPointerUp,
                      onPointerMove: _onPointerMove,
                      child: Container(
                        color: Colors.black.withOpacity(0.5),
                        width: _imageWidth,
                        height: _imageHeight,
                      ),
                    ),
                    Positioned(
                      left: _pointerX - 12,
                      top: _pointerY - 12,
                      child: PointMarker(
                        message: 'X: ${_pointerXRatio.toStringAsFixed(2)}, Y: ${_pointerYRatio.toStringAsFixed(2)}',
                        onTap: () {
                          print('X: ${_pointerXRatio.toStringAsFixed(2)}, Y: ${_pointerYRatio.toStringAsFixed(2)}');
                        },
                      ),
                    ),
                  ],
                ),
              )
            : SizedBox(),
      ),
    );
  }
}
