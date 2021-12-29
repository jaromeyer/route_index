import 'package:flutter/material.dart';

List<String> grades = [
  "B1",
  "B2",
  "B3",
  "B3+",
  "B4-",
  "B4",
  "B4+",
  "B5-",
  "B5",
  "B5+",
  "B6",
];

final List<String> sectors = [
  "Flachland",
  "Laktatpiste",
  "Garage",
  "Grotte",
  "Langeneggersturtz",
  "Schmieregge",
];

Color getColor(int grade) {
  switch (grade) {
    case 0:
      return Colors.yellow;
    case 1:
      return Colors.orange;
    case 2:
    case 3:
      return Colors.red;
    case 4:
    case 5:
    case 6:
      return Colors.blue;
    case 7:
    case 8:
    case 9:
      return Colors.green;
    default:
      return Colors.black;
  }
}
