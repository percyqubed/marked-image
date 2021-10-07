import 'package:flutter/material.dart';

class PointMarker extends StatefulWidget {
  final Function onTap;
  final String message;

  PointMarker({required this.message, required this.onTap});

  @override
  _PointMarkerState createState() => _PointMarkerState();
}

class _PointMarkerState extends State<PointMarker> {
  @override
  Widget build(BuildContext context) {
    final key = GlobalKey<State<Tooltip>>();
    return Tooltip(
      key: key,
      message: widget.message,
      child: DragTarget<int>(
        onWillAccept: (item) => true,
        onAccept: (value) {
          _onTap(key);
        },
        builder: (context, candidates, rejects) {
          return Opacity(
            opacity: 1,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => _onTap(key),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.yellow,
                    width: 4,
                  ),
                  shape: BoxShape.circle,
                ),
                height: 24,
                width: 24,
                child: Center(
                  child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _onTap(GlobalKey key) {
    final dynamic tooltip = key.currentState;
    tooltip?.ensureTooltipVisible();
    widget.onTap();
  }
}
