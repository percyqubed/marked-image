library marked_image;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'point_marker.dart';
import 'point_picker.dart';
part 'pointer_details.dart';

class MarkedImage extends StatefulWidget {
  MarkedImage({
    Key? key,
    required this.assetImage,
    required this.width,
    required this.debugMode,
    required this.points,
  }) : super(key: key);

  final String assetImage;
  final double width;
  final bool debugMode;
  final List<PointDetails> points;

  @override
  _MarkedImageState createState() => _MarkedImageState();
}

class _MarkedImageState extends State<MarkedImage> {
  double _originalImageWidth = 0;
  double _originalImageHeight = 0;
  double _imageAspectRatio = 0;

  double _imageWidth = 0;
  double _imageHeight = 0;

  List<Widget> _pointsList = [];

  @override
  void initState() {
    super.initState();
    _imageWidth = widget.width;
    getImageInfo();
  }

  Future getImageInfo() async {
    ByteData imageData = await rootBundle.load(widget.assetImage);
    var decodedImage = await decodeImageFromList(imageData.buffer.asUint8List());
    setState(() {
      _originalImageHeight = decodedImage.height.toDouble();
      _originalImageWidth = decodedImage.width.toDouble();
      _imageAspectRatio = _originalImageWidth / _originalImageHeight;
      _imageHeight = _imageWidth / _imageAspectRatio;
    });
    _populatePoints();
  }

  void _populatePoints() async {
    List<Widget> points = [];
    widget.points.forEach((point) {
      double x = point.xPercentage * _imageWidth;
      double y = point.yPercentage * _imageHeight;
      points.add(
        Positioned(
          left: x - 12,
          top: y - 12,
          child: PointMarker(
            message: point.title,
            onTap: point.onTap,
          ),
        ),
      );
    });

    setState(() {
      _pointsList = points;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Image(
              image: AssetImage(widget.assetImage),
              height: _imageHeight,
              width: _imageWidth,
            ),
            Container(
              color: Colors.black.withOpacity(0.5),
              width: _imageWidth,
              height: _imageHeight,
            ),
            ..._pointsList,
            widget.debugMode
                ? Positioned(
                    top: 0,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PointPicker(
                              imageAsset: widget.assetImage,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Pick Point',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                : SizedBox(),
            Positioned(
              left: 20,
              child: Draggable(
                child: Icon(Icons.edit),
                feedback: Icon(
                  Icons.edit,
                  color: Colors.yellow,
                  size: 24,
                ),
                data: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
