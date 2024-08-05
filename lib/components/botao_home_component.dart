import 'package:flutter/material.dart';

class BotaoHomeWidget extends StatefulWidget {
  final IconData icon;
  final String text;
  final Color color;
  final void Function()? onPress;
  const BotaoHomeWidget(
      {super.key,
      required this.icon,
      this.onPress,
      required this.color,
      required this.text});

  @override
  State<BotaoHomeWidget> createState() => _BotaoHomeWidgetState();
}

class _BotaoHomeWidgetState extends State<BotaoHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SafeArea(
        top: false,
        bottom: false,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(150, 150),
            backgroundColor: const Color.fromARGB(255, 250, 247, 245),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
              side: BorderSide.none,
            ),
          ),
          onPressed: () {
            widget.onPress;
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 50,
                color: widget.color,
              ),
              Text(
                widget.text,
                style: TextStyle(
                  color: widget.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
