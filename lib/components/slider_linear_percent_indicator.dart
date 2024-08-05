import 'package:flutter/material.dart';
import 'package:health_care/models/usuario.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class SliderLinearPercentIndicator extends StatefulWidget {
  final double percent;
  final ValueChanged<double>? onChanged;
  final Usuario usuario;
  final bool isAdmin;

  SliderLinearPercentIndicator({
    required this.percent,
    this.onChanged,
    required this.usuario,
    required this.isAdmin
  });

  @override
  _SliderLinearPercentIndicatorState createState() =>
      _SliderLinearPercentIndicatorState();
}

class _SliderLinearPercentIndicatorState
    extends State<SliderLinearPercentIndicator> {
  late double _currentPercent;

  @override
  void initState() {
    super.initState();
    _currentPercent = widget.percent;
  }

  

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearPercentIndicator(
          animation: true,
          animationDuration: 1000,
          barRadius: Radius.circular(300),
          lineHeight: 30.0,
          percent: _currentPercent / 100,
          center: Text(
            '${_currentPercent.toStringAsFixed(1)}%',
            style: TextStyle(fontSize: 17.0),
          ),
          linearStrokeCap: LinearStrokeCap.roundAll,
          backgroundColor: Color.fromARGB(68, 175, 164, 160),
          progressColor: Color.fromARGB(255, 175, 164, 160),
        ),
        if (widget.isAdmin)
          Slider(
            value: _currentPercent,
            min: 0,
            max: 100,
            onChanged: (value) {
              setState(() {
                _currentPercent = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
            },
            activeColor: Colors.transparent,
            inactiveColor: Colors.transparent,
          ),
      ],
    );
  }
}
