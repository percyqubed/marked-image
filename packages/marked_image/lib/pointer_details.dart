part of 'marked_image.dart';

class PointDetails {
  final double xPercentage;
  final double yPercentage;
  final String title;
  final Function onTap;

  PointDetails({
    required this.xPercentage,
    required this.yPercentage,
    required this.onTap,
    required this.title,
  });
}
