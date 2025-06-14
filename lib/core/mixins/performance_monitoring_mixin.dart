import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/scheduler.dart';
import 'dart:async';
import 'dart:developer' as developer;

mixin PerformanceMonitoringMixin {
  Trace? _pageTrace;
  Trace? _apiTrace;
  bool _isDisposed = false;
  Timer? _debounceTimer;
  final _metricQueue = <Map<String, dynamic>>[];
  bool _isProcessingQueue = false;
  final Map<String, Trace> _activeTraces = {};
  DateTime? _pageLoadStartTime;
  static final Map<String, DateTime> _navigationStartTimes = {};
  static final Map<String, DateTime> _apiStartTimes = {};
  static final Map<String, int> _pageLoadCounts = {};

  // Sayfa geçişi başladığında çağrılacak metod
  static void startNavigationTrace(String pageName) {
    developer.log('Starting navigation trace for: $pageName', name: 'Performance');
    _navigationStartTimes[pageName] = DateTime.now();
  }

  // Sayfa geçişi tamamlandığında çağrılacak metod
  static void stopNavigationTrace(String pageName) {
    final startTime = _navigationStartTimes[pageName];
    if (startTime == null) {
      developer.log('No navigation start time found for: $pageName', name: 'Performance');
      return;
    }

    final endTime = DateTime.now();
    final navigationDuration = endTime.difference(startTime).inMilliseconds;
    
    developer.log('Navigation duration for $pageName: ${navigationDuration}ms', name: 'Performance');

    final trace = FirebasePerformance.instance.newTrace('navigation_$pageName');
    trace.start();
    trace.setMetric('navigation_duration_ms', navigationDuration);
    trace.putAttribute('page_name', pageName);
    trace.putAttribute('start_time', startTime.toString());
    trace.putAttribute('end_time', endTime.toString());
    trace.stop();

    _navigationStartTimes.remove(pageName);
    developer.log('Navigation trace completed for: $pageName', name: 'Performance');
  }

  // API çağrısı başladığında çağrılacak metod
  static void startApiCall(String apiName) {
    _apiStartTimes[apiName] = DateTime.now();
  }

  // API çağrısı tamamlandığında çağrılacak metod
  static void stopApiCall(String apiName, {int? responseSize, String? statusCode}) {
    final startTime = _apiStartTimes[apiName];
    if (startTime == null) return;

    final endTime = DateTime.now();
    final apiDuration = endTime.difference(startTime).inMilliseconds;

    final trace = FirebasePerformance.instance.newTrace('api_$apiName');
    trace.start();
    trace.setMetric('response_time_ms', apiDuration);
    trace.putAttribute('api_name', apiName);
    trace.putAttribute('start_time', startTime.toString());
    trace.putAttribute('end_time', endTime.toString());
    if (responseSize != null) {
      trace.setMetric('response_size_bytes', responseSize);
    }
    if (statusCode != null) {
      trace.putAttribute('status_code', statusCode);
    }
    trace.stop();

    _apiStartTimes.remove(apiName);
  }

  void startPageLoadTrace(String pageName) {
    if (_isDisposed) return;
    
    developer.log('Starting page load trace for: $pageName', name: 'Performance');
    
    // Önceki trace'i temizle
    if (_pageTrace != null) {
      developer.log('Cleaning up previous trace', name: 'Performance');
      _pageTrace?.stop();
      _pageTrace = null;
    }
    
    // Yeni trace başlat
    _pageLoadStartTime = DateTime.now();
    _pageTrace = FirebasePerformance.instance.newTrace('page_load_$pageName');
    _pageTrace?.start();
    
    // Sayfa yükleme sayacını güncelle
    _pageLoadCounts[pageName] = (_pageLoadCounts[pageName] ?? 0) + 1;
    
    // Başlangıç metriklerini ekle
    _pageTrace?.putAttribute('page_name', pageName);
    _pageTrace?.putAttribute('start_time', _pageLoadStartTime.toString());
    _pageTrace?.putAttribute('load_count', _pageLoadCounts[pageName].toString());
    _pageTrace?.setMetric('load_start_ms', _pageLoadStartTime!.millisecondsSinceEpoch);
    
    developer.log('Page load trace started with metrics', name: 'Performance');
  }

  void stopPageLoadTrace() {
    if (_isDisposed || _pageLoadStartTime == null || _pageTrace == null) {
      developer.log('Cannot stop page load trace - invalid state', name: 'Performance');
      return;
    }
    
    final endTime = DateTime.now();
    final loadDuration = endTime.difference(_pageLoadStartTime!).inMilliseconds;
    
    developer.log('Stopping page load trace. Duration: ${loadDuration}ms', name: 'Performance');
    
    // Süre çok uzunsa (örneğin 30 saniyeden fazla) trace'i iptal et
    if (loadDuration > 30000) {
      developer.log('Page load duration too long, cancelling trace', name: 'Performance');
      _pageTrace?.stop();
      _pageTrace = null;
      _pageLoadStartTime = null;
      return;
    }
    
    // Normal süre ise metrikleri kaydet
    _pageTrace?.setMetric('load_duration_ms', loadDuration);
    _pageTrace?.setMetric('load_end_ms', endTime.millisecondsSinceEpoch);
    _pageTrace?.putAttribute('end_time', endTime.toString());
    
    // Trace'i hemen durdur ve gönder
    _pageTrace?.stop();
    _pageTrace = null;
    _pageLoadStartTime = null;
    
    developer.log('Page load trace stopped and metrics recorded', name: 'Performance');
  }

  void startApiTrace(String apiName) {
    if (_isDisposed) return;
    
    _apiTrace?.stop();
    _apiTrace = FirebasePerformance.instance.newTrace('api_$apiName');
    _apiTrace?.start();
    _apiTrace?.putAttribute('api_name', apiName);
    _apiTrace?.putAttribute('start_time', DateTime.now().toString());
  }

  void stopApiTrace() {
    if (_isDisposed || _apiTrace == null) return;
    
    _apiTrace?.putAttribute('end_time', DateTime.now().toString());
    _apiTrace?.stop();
    _apiTrace = null;
  }

  void startTrace(String traceName) {
    if (_isDisposed) return;
    
    _activeTraces[traceName]?.stop();
    _activeTraces[traceName] = FirebasePerformance.instance.newTrace(traceName);
    _activeTraces[traceName]?.start();
    _activeTraces[traceName]?.putAttribute('start_time', DateTime.now().toString());
  }

  void stopTrace(String traceName) {
    if (_isDisposed || _activeTraces[traceName] == null) return;
    
    _activeTraces[traceName]?.putAttribute('end_time', DateTime.now().toString());
    _activeTraces[traceName]?.stop();
    _activeTraces.remove(traceName);
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
    
    while (_metricQueue.isNotEmpty) {
      final item = _metricQueue.removeAt(0);
      if (item['type'] == 'metric') {
        _pageTrace?.setMetric(item['name'], item['value']);
      } else if (item['type'] == 'attribute') {
        _pageTrace?.putAttribute(item['name'], item['value']);
      }
    }
    
    _isProcessingQueue = false;
  }

  void cleanup() {
    _isDisposed = true;
    _debounceTimer?.cancel();
    _metricQueue.clear();
    
    // Aktif trace'leri temizle
    _activeTraces.forEach((name, trace) {
      developer.log('Cleaning up active trace: $name', name: 'Performance');
      trace.stop();
    });
    _activeTraces.clear();
    
    // Sayfa trace'ini temizle
    if (_pageTrace != null) {
      developer.log('Cleaning up page trace', name: 'Performance');
      stopPageLoadTrace();
    }
  }
} 