import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  final Widget child;
  final Color color;
  final void Function()? onPress;

  CustomCard({Key? key, required this.child, this.onPress, required this.color})
      : super(key: key);

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return TapRegion(
      onTapInside: (_) => setState(() => _isHovered = true),
      onTapOutside: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
    onTap: widget.onPress,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: _isHovered
            ? const Color.fromARGB(255, 187, 186, 186)
            : widget.color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      transform: _isHovered
          ? Matrix4.translationValues(10, 0, 0)
          : Matrix4.translationValues(0, 0, 0),
      child: widget.child,
    ),
  ),
    );
  }
}
