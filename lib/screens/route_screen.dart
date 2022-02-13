import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
  final TextEditingController _commentController = TextEditingController();
  bool _savedRating = false;

  Expanded _buildStatCard(String title, String count, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(6.0),
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

  Container _buildRatingsCard(RouteModel route) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.indigo,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Bewertungen (${route.userGrades.length})",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6, bottom: 12),
            child: SfLinearGauge(
              showAxisTrack: false,
              showTicks: true,
              minorTicksPerInterval: 0,
              interval: 1,
              minimum: 0,
              maximum: grades.length - 1,
              labelFormatterCallback: (val) {
                return grades[int.parse(val)];
              },
              axisLabelStyle: const TextStyle(fontSize: 16),
              useRangeColorForAxis: true,
              markerPointers: [
                LinearShapePointer(
                  color: getColor(route.getUserGrade().round()),
                  value: route.getUserGrade(),
                  position: LinearElementPosition.outside,
                  offset: 5,
                ),
              ],
              ranges: const [
                LinearGaugeRange(
                  startValue: 0,
                  endValue: 1.5,
                  position: LinearElementPosition.outside,
                  color: Colors.orange,
                ),
                LinearGaugeRange(
                  startValue: 1.5,
                  endValue: 4.5,
                  position: LinearElementPosition.outside,
                  color: Colors.red,
                ),
                LinearGaugeRange(
                  startValue: 4.5,
                  endValue: 7.5,
                  position: LinearElementPosition.outside,
                  color: Colors.blue,
                ),
                LinearGaugeRange(
                  startValue: 7.5,
                  endValue: 10.5,
                  position: LinearElementPosition.outside,
                  color: Colors.green,
                ),
                LinearGaugeRange(
                  startValue: 10.5,
                  endValue: 11,
                  position: LinearElementPosition.outside,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          const Text(
            "Neue Bewertung abgeben",
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: grades
                  .map((grade) => SizedBox(
                        width: 30,
                        child: Text(
                          grade,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8),
            child: _savedRating
                ? const Text("Bewertung gespeichert",
                    style: TextStyle(color: Colors.white, fontSize: 16))
                : ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.white),
                    child: const Text(
                      "Bewertung speichern",
                      style: TextStyle(color: Colors.indigo),
                    ),
                    onPressed: () {
                      setState(() {
                        _savedRating = true;
                        route.userGrades.add(_currentSliderValue.round());
                      });
                      route.save();
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
                    },
                  ),
          ),
        ],
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
      body: Padding(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: Row(
                children: <Widget>[
                  _buildStatCard('Sektor', route.sector, Colors.cyan),
                  _buildStatCard('Schrauber', route.setter, Colors.blueGrey),
                ],
              ),
            ),
            SizedBox(
              height: 100,
              child: Row(
                children: <Widget>[
                  _buildStatCard('Schwierigkeitsgrad offiziell',
                      grades[route.grade], getColor(route.grade)),
                  _buildStatCard('Schraubdatum',
                      DateFormat("d.M.y").format(route.date), Colors.purple),
                ],
              ),
            ),
            _buildRatingsCard(route),
            Expanded(
              child: Card(
                margin: const EdgeInsets.all(0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText:
                              'Kommentar hinzufügen (Enter zum speichern)',
                        ),
                        //keyboardType: TextInputType.text,
                        controller: _commentController,
                        onSubmitted: (value) {
                          setState(() {
                            _commentController.clear();
                            route.comments.add(value);
                          });
                          route.save();
                        },
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: route.comments.length,
                        itemBuilder: (BuildContext context, int index) {
                          final String comment =
                              route.comments[route.comments.length - index - 1];
                          return ListTile(
                            title: Text(comment),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
