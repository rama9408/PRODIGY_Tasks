
import 'package:flutter/material.dart';

void main() => runApp(CalculatorApp());

class CalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Calculator',
      theme: ThemeData.dark(),
      home: CalculatorHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorHome extends StatefulWidget {
  @override
  _CalculatorHomeState createState() => _CalculatorHomeState();
}

class _CalculatorHomeState extends State<CalculatorHome> {
  String _input = '';
  String _result = '';

  void _buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        _input = '';
        _result = '';
      } else if (value == '=') {
        try {
          _result = _evaluate(_input);
        } catch (e) {
          _result = 'Error';
        }
      } else {
        _input += value;
      }
    });
  }

  String _evaluate(String expression) {
    try {
      final result = _calculate(expression);
      return result.toString();
    } catch (e) {
      return 'Error';
    }
  }

  double _calculate(String expr) {
    List<String> tokens = expr.split(RegExp(r'([+*/-])')).where((s) => s.isNotEmpty).toList();
    List<String> operators = RegExp(r'[+*/-]').allMatches(expr).map((e) => e.group(0)!).toList();

    double result = double.parse(tokens[0]);
    for (int i = 0; i < operators.length; i++) {
      double next = double.parse(tokens[i + 1]);
      switch (operators[i]) {
        case '+':
          result += next;
          break;
        case '-':
          result -= next;
          break;
        case '*':
          result *= next;
          break;
        case '/':
          result /= next;
          break;
      }
    }
    return result;
  }

  Widget _buildButton(String label) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () => _buttonPressed(label),
        child: Text(label, style: TextStyle(fontSize: 24)),
        style: ElevatedButton.styleFrom(padding: EdgeInsets.all(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_input, style: TextStyle(fontSize: 32, color: Colors.white70)),
                  SizedBox(height: 10),
                  Text(_result, style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Row(children: [_buildButton('7'), _buildButton('8'), _buildButton('9'), _buildButton('/')]),
              Row(children: [_buildButton('4'), _buildButton('5'), _buildButton('6'), _buildButton('*')]),
              Row(children: [_buildButton('1'), _buildButton('2'), _buildButton('3'), _buildButton('-')]),
              Row(children: [_buildButton('0'), _buildButton('C'), _buildButton('='), _buildButton('+')]),
            ],
          ),
        ],
      ),
    );
  }
}
