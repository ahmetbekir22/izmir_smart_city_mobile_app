import 'package:flutter/material.dart';
import 'performance_monitor.dart';
import 'performance_helper.dart';

class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  Future<void> _simulateApiCall() async {
    await PerformanceHelper().trackApiCall('example_endpoint', () async {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
    });
  }

  @override
  Widget build(BuildContext context) {
    return PerformanceMonitor(
      screenName: 'example_screen',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Performance Test Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _simulateApiCall,
                child: const Text('Simulate API Call'),
              ),
              const SizedBox(height: 20),
              const Text('This screen is wrapped with PerformanceMonitor'),
            ],
          ),
        ),
      ),
    );
  }
} 