import 'package:hive/hive.dart';

import '../values.dart';

part 'route_model.g.dart';

@HiveType(typeId: 0)
class RouteModel extends HiveObject {
  @HiveField(0)
  String name = "Neue Route";

  @HiveField(1)
  int grade = 0;

  @HiveField(2)
  String sector = "Flachland";

  @HiveField(3)
  String setter = "Markus der Gurkenkönig";

  @HiveField(4)
  DateTime date = DateTime.now();

  @HiveField(5)
  List<int> userGrades = [];

  String getUserGrade() {
    if (userGrades.isEmpty) {
      return "-";
    }
    int avgGrade = (userGrades.reduce((value, element) => value + element) /
            userGrades.length)
        .round();
    return grades[avgGrade];
  }
}
