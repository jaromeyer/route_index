import 'package:hive/hive.dart';

import '../values.dart';

part 'route_model.g.dart';

@HiveType(typeId: 0)
class RouteModel extends HiveObject {
  @HiveField(0)
  String name = "";

  @HiveField(1)
  int grade = 5;

  @HiveField(2)
  String sector = "Flachland";

  @HiveField(3)
  String setter = "";

  @HiveField(4)
  DateTime date = DateTime.now();

  @HiveField(5)
  List<int> userGrades = [];

  @HiveField(6)
  List<String> comments = [];

  double getUserGrade() {
    if (userGrades.isEmpty) {
      return 0;
    }
    return (userGrades.reduce((value, element) => value + element) /
        userGrades.length);
  }

  String getUserGradeString() {
    if (userGrades.isEmpty) {
      return "-";
    }
    return "${grades[getUserGrade().round()]} (${userGrades.length})";
  }
}
