import 'package:flutter/material.dart';
import 'package:firebase_performance/firebase_performance.dart';

class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final String screenName;

  const PerformanceMonitor({
    Key? key,
    required this.child,
    required this.screenName,
  }) : super(key: key);

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> with WidgetsBindingObserver {
  late Trace _trace;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTrace();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTrace();
    super.dispose();
  }

  void _startTrace() {
    _trace = FirebasePerformance.instance.newTrace('screen_${widget.screenName}');
    _trace.start();
    _startTime = DateTime.now();
  }

  void _stopTrace() {
    if (_startTime != null) {
      final duration = DateTime.now().difference(_startTime!);
      _trace.setMetric('render_time_ms', duration.inMilliseconds);
      _trace.stop();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTrace();
    } else if (state == AppLifecycleState.paused) {
      _stopTrace();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
} 