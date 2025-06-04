import 'package:flutter/material.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

class AdvancedPerformanceMonitor extends StatefulWidget {
  final Widget child;
  final String screenName;

  const AdvancedPerformanceMonitor({
    Key? key,
    required this.child,
    required this.screenName,
  }) : super(key: key);

  @override
  State<AdvancedPerformanceMonitor> createState() => _AdvancedPerformanceMonitorState();
}

class _AdvancedPerformanceMonitorState extends State<AdvancedPerformanceMonitor> with WidgetsBindingObserver {
  late Trace _trace;
  DateTime? _startTime;
  Timer? _metricsTimer;
  int _frameCount = 0;
  DateTime? _lastFrameTime;
  double _currentFps = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startTrace();
    _startMetricsCollection();
  }

  @override
  void dispose() {
    _stopMetricsCollection();
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
      _trace.setMetric('final_fps', _currentFps.toInt());
      _trace.stop();
    }
  }

  void _startMetricsCollection() {
    _metricsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _collectMetrics();
    });
  }

  void _stopMetricsCollection() {
    _metricsTimer?.cancel();
  }

  Future<void> _collectMetrics() async {
    if (!mounted) return;

    // Frame rate calculation
    if (_lastFrameTime != null) {
      final now = DateTime.now();
      final frameTime = now.difference(_lastFrameTime!);
      if (frameTime.inMilliseconds > 0) {
        _currentFps = 1000 / frameTime.inMilliseconds;
      }
    }
    _lastFrameTime = DateTime.now();

    // Memory usage
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        final memoryInfo = await _getMemoryInfo();
        _trace.setMetric('memory_usage_mb', memoryInfo['usedMemory']?.toInt() ?? 0);
      } catch (e) {
        debugPrint('Error getting memory info: $e');
      }
    }

    // CPU usage
    if (Platform.isAndroid || Platform.isIOS) {
      try {
        final cpuUsage = await _getCpuUsage();
        _trace.setMetric('cpu_usage_percent', cpuUsage.toInt());
      } catch (e) {
        debugPrint('Error getting CPU usage: $e');
      }
    }
  }

  Future<Map<String, double>> _getMemoryInfo() async {
    // Platform-specific memory info implementation
    // This is a placeholder - you'll need to implement platform-specific code
    return {'usedMemory': 0.0};
  }

  Future<double> _getCpuUsage() async {
    // Platform-specific CPU usage implementation
    // This is a placeholder - you'll need to implement platform-specific code
    return 0.0;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startTrace();
      _startMetricsCollection();
    } else if (state == AppLifecycleState.paused) {
      _stopTrace();
      _stopMetricsCollection();
    }
  }

  @override
  Widget build(BuildContext context) {
    _frameCount++;
    return widget.child;
  }
} 