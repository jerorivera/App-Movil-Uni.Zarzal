import 'package:flutter/material.dart';

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _input = "0";
  String _operation = "";
  String _displayOperation = "";
  double _firstNumber = 0;
  bool _isNewNumber = true;
  bool _hasDecimal = false;
  String _currentNumber = "";

  void _onButtonClick(String value) {
    setState(() {
      // Manejo de números y punto decimal
      if (value.compareTo("0") >= 0 && value.compareTo("9") <= 0 ||
          value == ".") {
        if (_isNewNumber) {
          _currentNumber = value == "." ? "0." : value;
          _isNewNumber = false;
        } else {
          if (value == "." && !_hasDecimal) {
            _currentNumber += value;
            _hasDecimal = true;
          } else if (value != ".") {
            _currentNumber =
                _currentNumber == "0" ? value : _currentNumber + value;
          }
        }
        _input = _currentNumber;
        if (_operation.isEmpty) {
          _displayOperation = _currentNumber;
        } else {
          _displayOperation = "$_firstNumber $_operation $_currentNumber";
        }
      }
      // Manejo de operaciones
      else if (value == "+" || value == "-" || value == "×" || value == "÷") {
        _firstNumber = double.parse(_currentNumber);
        _operation = value;
        _isNewNumber = true;
        _hasDecimal = false;
        _displayOperation = "$_firstNumber $value";
      }
      // Calcular resultado
      else if (value == "=") {
        if (_operation.isNotEmpty) {
          double secondNumber = double.parse(_currentNumber);
          switch (_operation) {
            case "+":
              _input = (_firstNumber + secondNumber).toString();
              break;
            case "-":
              _input = (_firstNumber - secondNumber).toString();
              break;
            case "×":
              _input = (_firstNumber * secondNumber).toString();
              break;
            case "÷":
              _input = (_firstNumber / secondNumber).toString();
              break;
          }
          _currentNumber = _input;
          _isNewNumber = true;
          _hasDecimal = _input.contains(".");
          _displayOperation = _input;
          _operation = "";
        }
      }
      // Limpiar todo
      else if (value == "AC") {
        _input = "0";
        _operation = "";
        _displayOperation = "0";
        _firstNumber = 0;
        _isNewNumber = true;
        _hasDecimal = false;
        _currentNumber = "0";
      }
      // Cambiar signo
      else if (value == "±") {
        if (_currentNumber.startsWith("-")) {
          _currentNumber = _currentNumber.substring(1);
        } else {
          _currentNumber = "-$_currentNumber";
        }
        _input = _currentNumber;
        if (_operation.isEmpty) {
          _displayOperation = _currentNumber;
        } else {
          _displayOperation = "$_firstNumber $_operation $_currentNumber";
        }
      }
      // Porcentaje
      else if (value == "%") {
        _currentNumber = (double.parse(_currentNumber) / 100).toString();
        _input = _currentNumber;
        if (_operation.isEmpty) {
          _displayOperation = _currentNumber;
        } else {
          _displayOperation = "$_firstNumber $_operation $_currentNumber";
        }
      }

      // Eliminar .0 de números enteros
      if (_input.endsWith(".0")) {
        _input = _input.substring(0, _input.length - 2);
        _currentNumber =
            _currentNumber.endsWith(".0")
                ? _currentNumber.substring(0, _currentNumber.length - 2)
                : _currentNumber;
        if (_displayOperation.endsWith(".0")) {
          _displayOperation = _displayOperation.substring(
            0,
            _displayOperation.length - 2,
          );
        }
      }
    });
  }

  Widget _buildButton(String value, {Color? color, Color? textColor}) {
    bool isWide = value == "0";
    bool isOperator = ["+", "-", "×", "÷", "="].contains(value);

    return Expanded(
      flex: isWide ? 2 : 1,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ElevatedButton(
          onPressed: () => _onButtonClick(value),
          style: ElevatedButton.styleFrom(
            shape: isWide ? const StadiumBorder() : const CircleBorder(),
            padding: const EdgeInsets.all(24),
            backgroundColor:
                color ?? (isOperator ? Colors.orange : Colors.grey[850]),
          ),
          child: Text(
            value,
            style: TextStyle(fontSize: 30, color: textColor ?? Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      _displayOperation,
                      style: TextStyle(
                        fontSize: _displayOperation.length > 10 ? 50 : 80,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    _buildButton(
                      "AC",
                      color: Colors.grey[400],
                      textColor: Colors.black,
                    ),
                    _buildButton(
                      "±",
                      color: Colors.grey[400],
                      textColor: Colors.black,
                    ),
                    _buildButton(
                      "%",
                      color: Colors.grey[400],
                      textColor: Colors.black,
                    ),
                    _buildButton("÷"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("7"),
                    _buildButton("8"),
                    _buildButton("9"),
                    _buildButton("×"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("4"),
                    _buildButton("5"),
                    _buildButton("6"),
                    _buildButton("-"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("1"),
                    _buildButton("2"),
                    _buildButton("3"),
                    _buildButton("+"),
                  ],
                ),
                Row(
                  children: [
                    _buildButton("0"),
                    _buildButton("."),
                    _buildButton("="),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
