import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

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

  _showConfirmDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Route löschen"),
          content: Text("Route ${widget.route.name} wirklich löschen?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Abbrechen"),
            ),
            TextButton(
              onPressed: () {
                widget.route.delete().then((_) =>
                    Navigator.popUntil(context, ModalRoute.withName('/')));
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Route gelöscht'),
                ));
              },
              child: const Text("Löschen"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Route bearbeiten"),
        actions: [
          IconButton(
            onPressed: _showConfirmDeleteDialog,
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: 'Name',
                suffixIcon: IconButton(
                  onPressed: _nameController.clear,
                  icon: const Icon(Icons.clear),
                ),
              ),
              controller: _nameController,
              textInputAction: TextInputAction.next,
              onSubmitted: (_) => FocusScope.of(context).nextFocus(),
            ),
            TextField(
              decoration: InputDecoration(
                border: const UnderlineInputBorder(),
                labelText: 'Schrauber',
                suffixIcon: IconButton(
                  onPressed: _setterController.clear,
                  icon: const Icon(Icons.clear),
                ),
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
              padding: const EdgeInsets.only(bottom: 12, left: 10, right: 10),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: const Text("Bewertungen löschen"),
                  onPressed: () {
                    widget.route.userGrades = [];
                    widget.route.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bewertungen gelöscht')),
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text("Speichern"),
                  onPressed: () {
                    widget.route.name = _nameController.text;
                    widget.route.setter = _setterController.text;
                    widget.route.sector = _sector;
                    widget.route.grade = _currentSliderValue.round();
                    try {
                      widget.route.save();
                    } catch (err) {
                      Hive.box('routes').add(widget.route);
                    }
                    Navigator.pop(context);
                  },
                ),
                ElevatedButton(
                  child: const Text("Kommentare löschen"),
                  onPressed: () {
                    widget.route.comments = [];
                    widget.route.save();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kommentare gelöscht')),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
