class Part {
  final Duration pace;
  final Duration timespan;

  Part({required this.pace, required this.timespan});

  double getDistance() {
    final paceSeconds = pace.inSeconds;
    if (paceSeconds == 0) return 0.0;
    return timespan.inSeconds / paceSeconds;
  }
}
