import 'dart:async';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:passcode_screen/passcode_screen.dart';

import '../models/route_model.dart';
import '../values.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> _selectedSectors = sectors;
  RangeValues _currentGradeRange = RangeValues(0, grades.length - 1.0);
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
    final routes = Hive.box('routes')
        .values
        .where((route) =>
            route.grade >= _currentGradeRange.start.round() &&
            route.grade <= _currentGradeRange.end.round() &&
            _selectedSectors.contains(route.sector))
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
                    Hive.box('routes').add(route);
                    Navigator.pushNamed(context, '/edit', arguments: route)
                        .then((_) => setState(() {}));
                  },
                  icon: const Icon(Icons.add),
                )
              : Container(),
          IconButton(
            onPressed: () {
              if (_godMode) {
                setState(() => _godMode = false);
              } else {
                // open passcode dialog
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
                RangeSlider(
                  values: _currentGradeRange,
                  max: grades.length - 1.0,
                  divisions: grades.length - 1,
                  labels: RangeLabels(
                    grades[_currentGradeRange.start.round()],
                    grades[_currentGradeRange.end.round()],
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _currentGradeRange = values;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: grades
                        .map((grade) => Expanded(
                            child: Text(grade, textAlign: TextAlign.center)))
                        .toList(),
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
                bool isNew = route.date.difference(DateTime.now()) <=
                    const Duration(days: 7);
                return ListTile(
                  title: Text(route.name),
                  subtitle: Text(
                    route.setter + " " + DateFormat("d.M.y").format(route.date),
                  ),
                  trailing: Text(
                    grades[route.grade],
                    style:
                        TextStyle(color: getColor(route.grade), fontSize: 24),
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
