// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:decimal/decimal.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.black,
          textTheme:
              const TextTheme(bodyLarge: TextStyle(fontFamily: "Noto Sans"))),
      home: const CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String dataFromState = "0";
  Decimal number1 = Decimal.zero;
  Decimal number2 = Decimal.zero;
  String action = "";
  late List numbersList = [
    "AC",
    "±",
    "%",
    "÷",
    7,
    8,
    9,
    "×",
    4,
    5,
    6,
    "-",
    1,
    2,
    3,
    "+",
    0,
    ".",
    "="
  ];

  void calcFunc(Decimal num1, Decimal num2, String e) {
    if (e == '÷' && num2 != Decimal.zero) {
      dataFromState = (num1 / num2).toString();
    } else if (e == '×') {
      dataFromState = (num1 * num2).toString();
    } else if (e == '-') {
      dataFromState = (num1 - num2).toString();
    } else if (e == '+') {
      dataFromState = (num1 + num2).toString();
    }
  }

  void changeNumber1(dynamic number) {
    if (dataFromState == "0" && number != '.') {
      dataFromState = "";
    }
    if (number == '.') {
      if (!dataFromState.contains('.')) {
        dataFromState += number.toString();
      }
    } else {
      dataFromState += number.toString();
    }
    number1 = Decimal.parse(dataFromState);
    if (dataFromState == "0") {
      numbersList[0] = "AC";
    } else {
      numbersList[0] = "C";
    }
  }

  void changeNumber2(dynamic number) {
    if (dataFromState == "0" && number != '.') {
      dataFromState = "";
    }
    if (number == '.') {
      if (!dataFromState.contains('.')) {
        dataFromState += number.toString();
      }
    } else {
      dataFromState += number.toString();
    }
    number2 = Decimal.parse(dataFromState);
  }

  void changeAction(String act) {
    action = act;
    dataFromState = "0"; // Сбросить значение при выборе операции
  }

  void printResult() {
    bool containsDot = dataFromState.contains(".");
    if (containsDot) {
      number2 = Decimal.parse(dataFromState);
    } else {
      number2 = Decimal.parse(dataFromState);
    }
    dataFromState = number2.toString();
    calcFunc(number1, number2, action);
    number1 = Decimal.zero;
    number2 = Decimal.zero;
    action = "";
  }

  void clearCalc() {
    dataFromState = "0";
    number1 = Decimal.zero;
    number2 = Decimal.zero;
    action = "";
    numbersList[0] = "AC";
  }

  void changeSign() {
    if (dataFromState != "0") {
      if (dataFromState.startsWith('-')) {
        dataFromState = dataFromState.substring(1);
      } else {
        dataFromState = "-$dataFromState";
      }
      if (action.isEmpty) {
        number1 = Decimal.parse(dataFromState);
      } else {
        number2 = Decimal.parse(dataFromState);
      }
    }
  }

  void calculatePercentage() {
    if (dataFromState != "0") {
      Decimal percent =
          (Decimal.parse(dataFromState) / Decimal.parse("100")).toDecimal();
      if (action == "") {
        number1 = percent;
        dataFromState = number1.toString();
      } else {
        number2 = ((number1 * number2) / Decimal.parse("100")).toDecimal();
        dataFromState = number2.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          const SizedBox(
            height: 120,
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      dataFromState,
                      style: const TextStyle(
                          // backgroundColor: Colors.red,
                          fontSize: 100,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    ),
                  ))),
          Expanded(
              child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
            ),
            itemCount: numbersList.length,
            itemBuilder: (context, index) {
              dynamic sense = numbersList[index];
              return Center(
                  child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (sense == "AC" || sense == "C") {
                            clearCalc();
                          } else if (sense == "±") {
                            changeSign();
                          } else if (sense == "%") {
                            calculatePercentage();
                          } else if (sense is num &&
                              number2 == Decimal.zero &&
                              action == '') {
                            changeNumber1(sense);
                          } else if (sense is num &&
                              number1 != Decimal.zero &&
                              action != '') {
                            changeNumber2(sense);
                          } else if (sense is String &&
                              sense != "AC" &&
                              sense != "=" &&
                              sense != ".") {
                            changeAction(sense);
                          } else if (sense == "=") {
                            printResult();
                          } else if (sense == '.') {
                            if (number2 == Decimal.zero && action == '') {
                              changeNumber1(sense);
                            } else if (number1 != Decimal.zero &&
                                action != '') {
                              changeNumber2(sense);
                            }
                          }
                        });
                      },
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                            color: sense == "AC" ||
                                    sense == "±" ||
                                    sense == "%" ||
                                    sense == "C"
                                ? Colors.grey
                                : sense == "÷" ||
                                        sense == "×" ||
                                        sense == "-" ||
                                        sense == "+" ||
                                        sense == "="
                                    ? Colors.orange
                                    : const Color(0xFF323232),
                            borderRadius: BorderRadius.circular(50)),
                        child: Center(
                          child: Text(
                            numbersList[index].toString(),
                            style: TextStyle(
                              color: numbersList[index].toString() == "AC" ||
                                      numbersList[index].toString() == "C" ||
                                      sense == "±" ||
                                      sense == "%"
                                  ? Colors.black
                                  : Colors.white,
                              // fontSize: 40
                              fontSize: numbersList[index].toString() != "AC"
                                  ? 48
                                  : 38,
                            ),
                          ),
                        ),
                      )));
            },
          )),
        ]));
  }
}
