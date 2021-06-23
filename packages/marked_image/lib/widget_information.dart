import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class WidgetInfomation extends StatefulWidget {
  final Widget? child;
  final Function? onChange;

  const WidgetInfomation({
    Key? key,
    @required this.onChange,
    @required this.child,
  }) : super(key: key);

  @override
  _WidgetInfomationState createState() => _WidgetInfomationState();
}

class _WidgetInfomationState extends State<WidgetInfomation> {
  @override
  Widget build(BuildContext context) {
    SchedulerBinding.instance!.addPostFrameCallback(postFrameCallback);
    return Container(
      key: widgetKey,
      child: widget.child,
    );
  }

  var widgetKey = GlobalKey();
  var oldSize;

  void postFrameCallback(_) {
    BuildContext? context = widgetKey.currentContext;
    RenderBox? box = context!.findRenderObject() as RenderBox;

    Offset position = box.localToGlobal(Offset.zero);

    var newSize = context.size;
    if (oldSize == newSize) return;

    oldSize = newSize;
    Map<WidgetInfo, dynamic> widgetInfo = {
      WidgetInfo.size: newSize,
      WidgetInfo.position: position,
    };
    widget.onChange!(widgetInfo);
  }
}

enum WidgetInfo { size, position }
