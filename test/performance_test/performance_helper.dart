import 'package:firebase_performance/firebase_performance.dart';

class PerformanceHelper {
  static final PerformanceHelper _instance = PerformanceHelper._internal();
  factory PerformanceHelper() => _instance;
  PerformanceHelper._internal();

  Future<void> startAppLaunchTrace() async {
    final trace = FirebasePerformance.instance.newTrace('app_launch');
    await trace.start();
    return;
  }

  Future<void> stopAppLaunchTrace() async {
    final trace = FirebasePerformance.instance.newTrace('app_launch');
    await trace.stop();
    return;
  }

  Future<void> trackApiCall(String endpoint, Future<void> Function() apiCall) async {
    final trace = FirebasePerformance.instance.newTrace('api_$endpoint');
    await trace.start();
    
    try {
      await apiCall();
    } finally {
      await trace.stop();
    }
  }

  Future<void> trackMemoryUsage() async {
    final trace = FirebasePerformance.instance.newTrace('memory_usage');
    await trace.start();
    
    // Memory usage tracking logic here
    // Note: Flutter doesn't provide direct memory usage APIs
    // You might need to use platform-specific code for detailed memory tracking
    
    await trace.stop();
  }

  Future<void> trackCpuUsage() async {
    final trace = FirebasePerformance.instance.newTrace('cpu_usage');
    await trace.start();
    
    // CPU usage tracking logic here
    // Note: Flutter doesn't provide direct CPU usage APIs
    // You might need to use platform-specific code for detailed CPU tracking
    
    await trace.stop();
  }

  Future<void> trackFrameRate() async {
    final trace = FirebasePerformance.instance.newTrace('frame_rate');
    await trace.start();
    
    // Frame rate tracking logic here
    // You can use Flutter's PerformanceOverlay widget for visual feedback
    
    await trace.stop();
  }
} 