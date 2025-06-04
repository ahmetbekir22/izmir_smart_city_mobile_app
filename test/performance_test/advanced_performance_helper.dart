import 'package:firebase_performance/firebase_performance.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';

class AdvancedPerformanceHelper {
  static final AdvancedPerformanceHelper _instance = AdvancedPerformanceHelper._internal();
  factory AdvancedPerformanceHelper() => _instance;
  AdvancedPerformanceHelper._internal();

  Future<T> trackApiCall<T>({
    required String endpoint,
    required Future<T> Function() apiCall,
    Map<String, dynamic>? metadata,
  }) async {
    final trace = FirebasePerformance.instance.newTrace('api_$endpoint');
    await trace.start();
    
    if (metadata != null) {
      metadata.forEach((key, value) {
        trace.putAttribute(key, value.toString());
      });
    }

    final startTime = DateTime.now();
    try {
      final result = await apiCall();
      final duration = DateTime.now().difference(startTime);
      
      // Record response time
      trace.setMetric('response_time_ms', duration.inMilliseconds);
      
      // Record network metrics if available
      if (Platform.isAndroid || Platform.isIOS) {
        try {
          final networkInfo = await _getNetworkInfo();
          trace.setMetric('network_speed_kbps', networkInfo['speed'] ?? 0);
          trace.setMetric('network_latency_ms', networkInfo['latency'] ?? 0);
        } catch (e) {
          debugPrint('Error getting network info: $e');
        }
      }
      
      return result;
    } catch (e) {
      trace.putAttribute('error', e.toString());
      rethrow;
    } finally {
      await trace.stop();
    }
  }

  Future<Map<String, int>> _getNetworkInfo() async {
    // Platform-specific network info implementation
    // This is a placeholder - you'll need to implement platform-specific code
    return {
      'speed': 0,
      'latency': 0,
    };
  }

  Future<void> trackScreenTransition({
    required String fromScreen,
    required String toScreen,
    required Future<void> Function() transition,
  }) async {
    final trace = FirebasePerformance.instance.newTrace('screen_transition_${fromScreen}_to_${toScreen}');
    await trace.start();
    
    final startTime = DateTime.now();
    try {
      await transition();
      final duration = DateTime.now().difference(startTime);
      trace.setMetric('transition_time_ms', duration.inMilliseconds);
    } finally {
      await trace.stop();
    }
  }
} 