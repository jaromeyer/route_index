import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/route_model.dart';
import '../values.dart';

class RouteScreen extends StatefulWidget {
  final RouteModel route;

  const RouteScreen({Key? key, required this.route}) : super(key: key);

  @override
  State<RouteScreen> createState() => _RouteScreenState();
}

class _RouteScreenState extends State<RouteScreen> {
  late double _currentSliderValue = widget.route.grade.toDouble();
  bool _savedRating = false;

  Expanded _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              count,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final RouteModel route = widget.route;
    return Scaffold(
      appBar: AppBar(
        title: Text(route.name),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: Row(
              children: <Widget>[
                _buildStatCard('Sektor', route.sector, Colors.orange),
                _buildStatCard('Schrauber', route.setter, Colors.red),
              ],
            ),
          ),
          SizedBox(
            height: 100,
            child: Row(
              children: <Widget>[
                _buildStatCard(
                    'Schwierigkeit', grades[route.grade], Colors.green),
                _buildStatCard(
                    'Bewertung',
                    '${route.getUserGrade()} (${route.userGrades.length})',
                    Colors.lightBlue),
                _buildStatCard('Schraubdatum',
                    DateFormat("d.M.y").format(route.date), Colors.purple),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  "Route bewerten",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Slider(
                  thumbColor: Colors.white,
                  activeColor: Colors.white,
                  inactiveColor: Colors.white,
                  value: _currentSliderValue,
                  max: grades.length - 1.0,
                  divisions: grades.length - 1,
                  label: grades[_currentSliderValue.round()],
                  onChanged: (double value) {
                    if (!_savedRating) {
                      setState(() => _currentSliderValue = value);
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: grades
                      .map(
                        (grade) => Expanded(
                          child: Text(
                            grade,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  child: _savedRating
                      ? const Text("Bewertung gespeichert",
                          style: TextStyle(color: Colors.white, fontSize: 16))
                      : ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.white),
                          child: const Text(
                            "Bewertung speichern",
                            style: TextStyle(color: Colors.indigo),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Bewertung gespeichert'),
                                action: SnackBarAction(
                                  label: 'Rückgängig',
                                  onPressed: () {
                                    setState(() {
                                      _savedRating = false;
                                      route.userGrades.removeLast();
                                    });
                                    route.save();
                                  },
                                ),
                              ),
                            );
                            setState(() {
                              _savedRating = true;
                              route.userGrades.add(_currentSliderValue.round());
                            });
                            route.save();
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
