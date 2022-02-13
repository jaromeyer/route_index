import 'dart:async';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:passcode_screen/passcode_screen.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../models/route_model.dart';
import '../values.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _selectedSectors = sectors;
  SfRangeValues _currentGradeRange = SfRangeValues(0, grades.length);
  bool _godMode = false;
  final StreamController<bool> _verificationNotifier =
      StreamController<bool>.broadcast();

  _showPasscodeLock() {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => PasscodeScreen(
          title: const Text(
            'Passcode eingeben',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 28),
          ),
          passwordEnteredCallback: (passcode) =>
              _verificationNotifier.add(passcode == "2011"),
          cancelCallback: () => Navigator.maybePop(context),
          isValidCallback: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Adminmodus aktiviert')),
            );
            setState(() => _godMode = true);
          },
          cancelButton: const Text(
            'Abbrechen',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          deleteButton: const Text(
            'Löschen',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          shouldTriggerVerification: _verificationNotifier.stream,
          passwordDigits: 4,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // get & filter routes
    final allRoutes = Hive.box('routes')
        .values
        .where((route) => _selectedSectors.contains(route.sector));

    List<int> gradeCount = List.filled(grades.length, 0);
    for (RouteModel route in allRoutes) {
      gradeCount[route.grade]++;
    }

    final routes = allRoutes
        .where((route) =>
            route.grade >= _currentGradeRange.start &&
            route.grade <= _currentGradeRange.end - 1)
        .toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            _godMode ? Colors.red : ColorScheme.fromSwatch().primary,
        title: Text("${routes.length} Routen gefunden"),
        actions: [
          _godMode
              ? IconButton(
                  onPressed: () {
                    // add new route and open edit screen
                    final RouteModel route = RouteModel();
                    Navigator.pushNamed(context, '/edit', arguments: route)
                        .then((_) => setState(() {}));
                  },
                  icon: const Icon(Icons.add),
                )
              : Container(),
          IconButton(
            onPressed: () {
              if (_godMode) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Adminmodus deaktiviert')),
                );
                setState(() => _godMode = false);
              } else {
                _showPasscodeLock();
              }
            },
            icon: _godMode
                ? const Icon(Icons.lock_open)
                : const Icon(Icons.lock_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          Material(
            elevation: 2,
            child: Column(
              children: [
                ChipsChoice<String>.multiple(
                  wrapped: true,
                  value: _selectedSectors,
                  onChanged: (val) {
                    setState(() => _selectedSectors = val);
                  },
                  choiceItems: C2Choice.listFrom<String, String>(
                    source: sectors,
                    value: (i, v) => v,
                    label: (i, v) => v,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: SfRangeSelectorTheme(
                    data: SfRangeSelectorThemeData(
                      thumbColor: Colors.white,
                      inactiveRegionColor: Colors.grey[50]?.withAlpha(175),
                      thumbStrokeWidth: 1,
                      thumbStrokeColor: Colors.blueGrey,
                    ),
                    child: SfRangeSelector(
                      onChanged: (range) {
                        setState(() => _currentGradeRange = range);
                      },
                      child: SizedBox(
                        height: 60,
                        child: SfSparkBarChart(
                          axisLineWidth: 0,
                          //labelStyle: const TextStyle(color: Colors.black),
                          labelDisplayMode: SparkChartLabelDisplayMode.all,
                          data: gradeCount,
                        ),
                      ),
                      enableIntervalSelection: true,
                      min: 0,
                      max: grades.length,
                      initialValues: _currentGradeRange,
                      interval: 1,
                      labelPlacement: LabelPlacement.betweenTicks,
                      labelFormatterCallback: (val, _) =>
                          val < grades.length ? grades[val.toInt()] : "",
                      stepSize: 1,
                      showLabels: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: routes.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(height: 1),
              itemBuilder: (BuildContext context, int index) {
                final RouteModel route = routes[routes.length - index - 1];
                bool isNew = DateTime.now().difference(route.date) <=
                    const Duration(days: 7);
                return ListTile(
                  title: Text(
                    (isNew ? "(NEU) " : "") + route.name,
                    style:
                        TextStyle(color: isNew ? Colors.amber : Colors.black),
                  ),
                  subtitle: Text(route.sector),
                  leading: SizedBox(
                    width: 54,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          grades[route.grade],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: getColor(route.grade),
                            fontSize: 24,
                          ),
                        ),
                        route.getUserGrade() > -1
                            ? Text(
                                route.getUserGradeString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: getColor(route.getUserGrade().round()),
                                  fontSize: 14,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                  trailing: Text(
                    route.setter +
                        "\n" +
                        DateFormat("d.M.y").format(route.date),
                    textAlign: TextAlign.right,
                  ),
                  onTap: () => Navigator.pushNamed(
                          context, _godMode ? '/edit' : '/info',
                          arguments: route)
                      .then((_) => setState(() {})),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
