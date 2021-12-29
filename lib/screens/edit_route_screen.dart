import 'package:flutter/material.dart';

import '../models/route_model.dart';
import '../values.dart';

class EditRouteScreen extends StatefulWidget {
  final RouteModel route;

  const EditRouteScreen({Key? key, required this.route}) : super(key: key);

  @override
  State<EditRouteScreen> createState() => _EditRouteScreenState();
}

class _EditRouteScreenState extends State<EditRouteScreen> {
  late double _currentSliderValue = widget.route.grade.toDouble();
  late String _sector = widget.route.sector;
  late final TextEditingController _nameController =
      TextEditingController(text: widget.route.name);
  late final TextEditingController _setterController =
      TextEditingController(text: widget.route.setter);

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _nameController.dispose();
    _setterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Route bearbeiten"),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Route gelöscht')),
              );
              widget.route.delete().then((value) => Navigator.pop(context));
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Name',
              ),
              controller: _nameController,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Schrauber',
              ),
              controller: _setterController,
            ),
            DropdownButtonFormField(
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Sektor',
              ),
              value: _sector,
              items: sectors.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() => _sector = value.toString());
              },
            ),
            Slider(
              value: _currentSliderValue,
              max: grades.length - 1.0,
              divisions: grades.length - 1,
              label: grades[_currentSliderValue.round()],
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
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
                        )))
                    .toList(),
              ),
            ),
            ElevatedButton(
              child: const Text("Speichern"),
              onPressed: () {
                widget.route.name = _nameController.text;
                widget.route.setter = _setterController.text;
                widget.route.sector = _sector;
                widget.route.grade = _currentSliderValue.round();
                widget.route.save();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
