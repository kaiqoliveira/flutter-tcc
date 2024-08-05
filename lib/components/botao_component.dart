import 'package:flutter/material.dart';

class BotaoWidget extends StatefulWidget {
  final void Function()? onPress;
  final String text;
  
  const BotaoWidget({Key? key, this.onPress, required this.text}) : super(key: key);

  @override
  State<BotaoWidget> createState() => _BotaoWidgetState();
}

class _BotaoWidgetState extends State<BotaoWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(300, 70),
          backgroundColor: const Color.fromARGB(255, 175, 164, 160),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
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
          // Adicione os parênteses para chamar a função
          widget.onPress!();
        },
        child: Text(widget.text),
      ),
    );
  }
}
