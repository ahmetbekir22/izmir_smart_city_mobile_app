import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';

mixin PerformanceMonitoringMixin {
  Trace? _pageTrace;
  Trace? _apiTrace;
  bool _isDisposed = false;
  Timer? _debounceTimer;
  final _metricQueue = <Map<String, dynamic>>[];
  bool _isProcessingQueue = false;
  final Map<String, Trace> _activeTraces = {};
  DateTime? _pageLoadStartTime;

  void startPageLoadTrace(String pageName) {
    if (_isDisposed) return;
    
    _pageLoadStartTime = DateTime.now();
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (_isDisposed) return;
      
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        if (_isDisposed) return;
        _pageTrace?.stop();
        _pageTrace = FirebasePerformance.instance.newTrace('page_load_$pageName');
        _pageTrace?.start();
        
        // Sayfa yükleme başlangıç metriklerini ekle
        _pageTrace?.putAttribute('page_name', pageName);
        _pageTrace?.putAttribute('start_time', _pageLoadStartTime.toString());
      });
    });
  }

  void stopPageLoadTrace() {
    if (_isDisposed || _pageLoadStartTime == null) return;
    
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (_isDisposed) return;
      
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        if (_isDisposed) return;
        
        final loadDuration = DateTime.now().difference(_pageLoadStartTime!).inMilliseconds;
        _pageTrace?.setMetric('load_duration_ms', loadDuration);
        _pageTrace?.putAttribute('end_time', DateTime.now().toString());
        _pageTrace?.stop();
        _pageTrace = null;
        _pageLoadStartTime = null;
      });
    });
  }

  void startApiTrace(String apiName) {
    if (_isDisposed) return;
    
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (_isDisposed) return;
      _apiTrace?.stop();
      _apiTrace = FirebasePerformance.instance.newTrace('api_$apiName');
      _apiTrace?.start();
      _apiTrace?.putAttribute('api_name', apiName);
      _apiTrace?.putAttribute('start_time', DateTime.now().toString());
    });
  }

  void stopApiTrace() {
    if (_isDisposed) return;
    
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (_isDisposed) return;
      if (_apiTrace != null) {
        _apiTrace?.putAttribute('end_time', DateTime.now().toString());
        _apiTrace?.stop();
        _apiTrace = null;
      }
    });
  }

  void startTrace(String traceName) {
    if (_isDisposed) return;
    
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (_isDisposed) return;
      
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        if (_isDisposed) return;
        _activeTraces[traceName]?.stop();
        _activeTraces[traceName] = FirebasePerformance.instance.newTrace(traceName);
        _activeTraces[traceName]?.start();
        _activeTraces[traceName]?.putAttribute('start_time', DateTime.now().toString());
      });
    });
  }

  void stopTrace(String traceName) {
    if (_isDisposed) return;
    
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (_isDisposed) return;
      
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        if (_isDisposed) return;
        if (_activeTraces[traceName] != null) {
          _activeTraces[traceName]?.putAttribute('end_time', DateTime.now().toString());
          _activeTraces[traceName]?.stop();
          _activeTraces.remove(traceName);
        }
      });
    });
  }

  void addMetric(String name, int value) {
    if (_isDisposed) return;
    
    _metricQueue.add({
      'type': 'metric',
      'name': name,
      'value': value,
    });
    
    _processMetricQueue();
  }

  void addAttribute(String name, String value) {
    if (_isDisposed) return;
    
    _metricQueue.add({
      'type': 'attribute',
      'name': name,
      'value': value,
    });
    
    _processMetricQueue();
  }

  void _processMetricQueue() {
    if (_isProcessingQueue || _isDisposed) return;
    
    _isProcessingQueue = true;
    _debounceTimer?.cancel();
    
    _debounceTimer = Timer(const Duration(milliseconds: 100), () {
      if (_isDisposed) {
        _isProcessingQueue = false;
        return;
      }

      SchedulerBinding.instance.scheduleFrameCallback((_) {
        if (_isDisposed) {
          _isProcessingQueue = false;
          return;
        }

        while (_metricQueue.isNotEmpty) {
          final item = _metricQueue.removeAt(0);
          if (item['type'] == 'metric') {
            _pageTrace?.setMetric(item['name'], item['value']);
          } else if (item['type'] == 'attribute') {
            _pageTrace?.putAttribute(item['name'], item['value']);
          }
        }
        
        _isProcessingQueue = false;
      });
    });
  }

  @override
  void dispose() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    _metricQueue.clear();
    _activeTraces.values.forEach((trace) => trace.stop());
    _activeTraces.clear();
    stopPageLoadTrace();
    stopApiTrace();
  }
} 