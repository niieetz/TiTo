import 'package:flutter/material.dart';
import 'package:tito/pace_to_distance/part.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _distance = 0.0;
  Duration _duration = Duration.zero;
  Duration _pace = Duration.zero;
  List<Part> parts = [];

  Duration parseDuration(String input) {
    final parts = input.split(":");
    if (parts.length == 1) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      return Duration(minutes: minutes);
    } else if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return Duration(minutes: minutes, seconds: seconds);
    }
    return Duration.zero;
  }

  Future<Part?> showPartDialog(BuildContext context) {
    final paceController = TextEditingController();
    final timespanController = TextEditingController();

    return showDialog<Part>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new part"),
          scrollable:
              true, // <-- ganz wichtig, dann schiebt er sich mit dem Keyboard hoch
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: paceController,
                decoration: const InputDecoration(labelText: "Pace (mm:ss)"),
              ),
              TextField(
                controller: timespanController,
                decoration: const InputDecoration(
                  labelText: "Duration (mm:ss)",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final pace = parseDuration(paceController.text);
                final timespan = parseDuration(timespanController.text);

                final part = Part(pace: pace, timespan: timespan);

                Navigator.of(context).pop(part);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  String durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60).abs());
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60).abs());
    String result = '';
    if (duration.inHours > 0) {
      result += duration.inHours.toString();
      result += ':';
    }
    result += '$twoDigitMinutes:$twoDigitSeconds';
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: <Widget>[
          Row(
            children: [
              const Spacer(),
              const Text('Total duration: '),
              Text(durationToString(_duration)),
              const Spacer(),
              const Text('Avg. pace: '),
              Text(durationToString(_pace)),
              const Text(' min/km'),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              const Spacer(),
              Text('Total distance: ${_distance.toStringAsFixed(2)} km'),
              const Spacer(),
            ],
          ),
          Expanded(
            child: parts.isEmpty
                ? const Center(child: Text("No parts added yet"))
                : ListView.builder(
                    itemCount: parts.length,
                    itemBuilder: (context, index) {
                      final part = parts[index];
                      return ListTile(
                        title: Text(
                          "Pace: ${durationToString(part.pace)}, Duration: ${durationToString(part.timespan)}",
                        ),
                        subtitle: Text(
                          "Distance: ${part.getDistance().toStringAsFixed(2)} km",
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () async {
              final newPart = await showPartDialog(context);
              if (newPart != null) {
                setState(() {
                  parts.add(newPart);

                  // recalc totals
                  _distance = parts.fold(
                    0.0,
                    (sum, p) => sum + p.getDistance(),
                  );
                  _duration = Duration(
                    seconds: parts.fold(
                      0,
                      (sum, p) => sum + p.timespan.inSeconds,
                    ),
                  );

                  final totalSeconds = parts.fold<int>(
                    0,
                    (sum, p) => sum + p.timespan.inSeconds,
                  );
                  final totalDistance = parts.fold<double>(
                    0,
                    (sum, p) => sum + p.getDistance(),
                  );

                  _pace = totalDistance > 0
                      ? Duration(
                          seconds: (totalSeconds / totalDistance).round(),
                        )
                      : Duration.zero;
                });
              }
            },
            tooltip: 'Add',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 12),
          FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              setState(() {
                parts.clear();
                _distance = 0.0;
                _duration = Duration.zero;
                _pace = Duration.zero;
              });
            },
            tooltip: 'Reset',
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
