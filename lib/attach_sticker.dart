import 'package:flutter/material.dart';

class AttachSticker extends StatefulWidget {
  Image sticker;
  double dx;
  double dy;

  AttachSticker({Key? key, required this.sticker, this.dx = 0.0, this.dy = 0.0})
      : super(key: key);

  void setSticker(Image sticker) {
    this.sticker = sticker;
  }

  void setPosition(double dx, double dy) {
    this.dx = dx;
    this.dy = dy;
  }

  @override
  _AttachStickerState createState() => _AttachStickerState();
}

class _AttachStickerState extends State<AttachSticker> {
  Offset offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
            left: widget.dx,
            top: widget.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                setState(() {
                  widget.dx += details.delta.dx;
                  widget.dy += details.delta.dy;
                  offset = Offset(widget.dx, widget.dy);
                });
              },
            )),
      ],
    );
  }
}
