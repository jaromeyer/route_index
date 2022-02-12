import 'package:flutter/material.dart';

List<String> grades = [
  "B2",
  "B2+",
  "B3-",
  "B3", //+1 ab da inklusiv
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
  "Bernerblock",
  "Chuchichästli",
  "Deponie",
  "Flachland",
  "Garage",
  "Grotte",
  "Laktatpischte",
  "Langeneggerstutz",
  "Mantlewand",
  "Schliicherplättli",
  "Speckegge",
];

Color getColor(int grade) {
  switch (grade) {
    case 0:
    case 1:
      return Colors.orange;
    case 2:
    case 3:
    case 4:
      return Colors.red;
    case 5:
    case 6:
    case 7:
      return Colors.blue;
    case 8:
    case 9:
    case 10:
      return Colors.green;
    case 11:
      return Colors.black;
    default:
      return Colors.transparent;
  }
}
