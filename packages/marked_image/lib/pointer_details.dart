part of 'marked_image.dart';

class PointDetails {
  final List<Map> points;
  final String title;
  final Function onTap;

  PointDetails({
    required this.points,
    required this.onTap,
    required this.title,
  });
}
